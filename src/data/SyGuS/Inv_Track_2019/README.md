# SyGuS-Comp 2019 — Invariant Track

All **858** Inv-track benchmarks of the 2019 Syntax-Guided Synthesis
Competition (SyGuS-Comp): loop-invariant synthesis problems. Each specification
is a SyGuS-IF **v1** file using `(synth-inv inv-f ((v σ)...))` with
`declare-primed-var`s and `define-fun` `pre-f`/`trans-f`/`post-f`; 843 use
`set-logic LIA`, 15 are Boolean Lustre problems with `set-logic SAT`. A
candidate invariant solves a problem iff it satisfies the three verification
conditions for all states, decided by the Z3 SMT solver.

Provenance: copied verbatim from the SyGuS-Comp benchmark collection
([SyGuS-Org/benchmarks](https://github.com/SyGuS-Org/benchmarks)), directory
`comp/2019/Inv_Track` (see `citation.bib`). Local source:
`BenchmarkHackathon/benchmarks/comp/2019/Inv_Track`. The three families become
id prefixes (`<subdir>_<basename>`, sanitized to Julia identifiers):

| family (id prefix) | files | contents |
|---|---|---|
| `From2018_*` | 127 | 2018-carryover LIA invariant problems (`brett`, `cars`, `fib_*`, …) |
| `Lustre_*` | 455 | Lustre reactive-system invariants (LIA; the 15 `set-logic SAT` Boolean problems are here) |
| `XC_*` | 276 | LIA program-verification invariants |

Counts: 858 source files, **858 shipped, 0 excluded**. Every specification was
batch-verified — `check_program` with a trivial candidate returns a clean
`sat`/`unsat` verdict on every problem.

## inv-constraint expansion

`synth-inv` has no explicit constraints; the single
`(inv-constraint inv-f pre-f trans-f post-f)` is expanded **at parse time**
into the three standard verification conditions over the unprimed program
variables `v` and their primed successors `v!`:

1. `(=> (pre-f v...) (inv-f v...))` — initiation,
2. `(=> (and (inv-f v...) (trans-f v... v!...)) (inv-f v!...))` — consecution,
3. `(=> (inv-f v...) (post-f v...))` — safety.

So `check_clauses` returns a 3-element vector in exactly this order, and
`n_constraints == 3` for every problem. `declare-primed-var p σ` introduces
both `p` and `p!` as free variables.

## Grammars

`synth-inv` declares no grammar, so each problem gets a *default* invariant
grammar over the **unprimed** parameters: Boolean combinations (`and`, `or`,
`not`) of comparison atoms (`eq`, `<`, `<=`, `>`, `>=`) between linear integer
`Term`s (parameters, the constants appearing in `pre`/`trans`/`post` plus
`0`/`1`, and `+`/`-`). The Boolean-typed (`set-logic SAT`) problems get purely
Boolean combinations of their Bool parameters. Example:

```julia
grammar_From2018_brett = @csgrammar begin
    Start = true; Start = false
    Start = and(Start, Start); Start = or(Start, Start); Start = not(Start)
    Start = eq(Term, Term)
    Start = Term < Term;  Start = Term <= Term
    Start = Term > Term;  Start = Term >= Term
    Term  = p; Term = c; Term = cl; Term = 0; Term = 1; Term = 4
    Term  = Term + Term; Term = Term - Term
end
```

`eq` maps to SMT `=`; parameters keep their original names (no `_arg_i`).
These default grammars are not part of the source files.

## Requirements

- A `z3` binary on your `PATH` (`brew install z3`; tested with Z3 4.16.0). The
  module loads without z3 — the binary is only invoked inside the `check_*`
  calls.
- [`HerbSearch`](https://github.com/Herb-AI/HerbSearch.jl) for the iterators
  (not a dependency of HerbBenchmarks; `pkg> add HerbSearch`).

## Initializing, running an iterator, and checking with Z3

```julia
using HerbBenchmarks, HerbGrammar, HerbSearch
using HerbBenchmarks.SyGuSComp2019Common: check_program, check_clauses
const IT = HerbBenchmarks.Inv_Track_2019

problem = IT.problem_From2018_brett
grammar = IT.grammar_From2018_brett
spec    = problem.spec.formula          # 3 constraints (init/consecution/safety)

for (i, p) in enumerate(BFSIterator(grammar, :Start, max_depth=2))
    println(rulenode2expr(p, grammar)); i >= 5 && break
end

# the invariant `true` is too weak — it fails a verification condition,
# and z3 returns a counterexample state (unprimed + primed variables):
check_program(spec, true)
```

```
(verified = false, counterexample = Dict{Symbol, Any}(:c! => 0, :cl => 0, :p => 0, :c => 4, :p! => 0, :cl! => 0))
```

Per-clause check of the invariant `false` — it fails initiation (`pre ⟹ false`)
but vacuously satisfies consecution and safety:

```julia
check_clauses(spec, false)
```

```
Bool[0, 1, 1]
```

A valid invariant (`unsat` on all three conditions) returns
`(verified = true, counterexample = nothing)`. Enumerate-and-check works as in
the other tracks (`BFSIterator` + `check_program`, stop at the first verified
program); it is plain enumerate-and-check, not CEGIS.

## Z3 query semantics

- **Full spec** (`check_program`): free variables (unprimed and primed) become
  `declare-const`s, the `pre`/`trans`/`post` `define-fun`s are emitted in source
  order with `inv-f` replaced by a `define-fun` of the candidate, and the
  *negation* of the conjunction of the three verification conditions is
  asserted. `unsat` ⟹ the candidate is a valid inductive invariant. The
  `set-logic SAT` Lustre problems are checked under z3's `ALL` logic, and v1
  `let` sort-annotations `(x σ t)` are rewritten to SMT-LIB 2 `(x t)`.
- **Per clause** (`check_clauses`): one z3 process, one assumption literal per
  verification condition (`check-sat-assuming`); `true` at position `i` means
  condition `i` (init / consecution / safety) holds.

## Notes

- `get_problem`, `get_grammar`, `get_problem_grammar_pair`, `get_benchmark`,
  `get_all_identifiers` work with this module. IO-example utilities do not
  apply to `Problem{SMTSpecification}`; use `check_program`/`check_clauses`.
- The synthesized function is named `inv-f` (with a dash); for the single
  synth-fun a bare candidate suffices, and `expr_to_smt`/`verification_query`
  emit `var"inv-f"`-style names correctly.
