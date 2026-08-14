# SyGuS-Comp 2019 — CLIA Track

All **88** CLIA-track benchmarks of the 2019 Syntax-Guided Synthesis
Competition (SyGuS-Comp), as formal synthesis problems: each specification is
a SyGuS-IF **v1** file (`set-logic LIA`) with a single `(synth-fun ...)`,
universally quantified `declare-var`s, and `(constraint ...)` clauses that are
arbitrary conditional-linear-integer-arithmetic formulas — *not* IO examples.
A candidate solves a problem iff it satisfies all constraints for all inputs,
decided by the Z3 SMT solver.

Provenance: copied verbatim from the SyGuS-Comp benchmark collection
([SyGuS-Org/benchmarks](https://github.com/SyGuS-Org/benchmarks)), directory
`comp/2019/CLIA_Track` (all 88 files are in the `from_2018/` subdirectory; see
`citation.bib`). Local source:
`BenchmarkHackathon/benchmarks/comp/2019/CLIA_Track`. Ids are the sanitized
`from_2018_<basename>` (non-alphanumerics → `_`): `from_2018_jmbl_fg_max2`,
`from_2018_arraysearch16`, `from_2018_fg_max19`, ….

Counts: 88 source files, **88 shipped, 0 excluded**. Every specification was
batch-verified — `check_program` with a trivial candidate returns a clean
`sat`/`unsat` verdict on every problem.

## Layout

- `specifications/<id>.sl` — the original files, unmodified.
- `data.jl` (generated) — `problem_<id> = Problem(..., SMTSpecification((...)))`
  with fields `logic`, `synth_funs` (`(name, params, param_sorts, ret_sort)`),
  `free_vars` (`(name, sort)`), `n_constraints`, `spec_file`, `nt_sorts`.
  The checking utilities always (re)parse the `.sl` via `parse_spec_file`.
- `grammars.jl` (generated) — `grammar_<id> = @csgrammar ...` per problem.
- Shared parsing/checking code: `../sygus_comp_2019_common.jl` (module
  `HerbBenchmarks.SyGuSComp2019Common`), re-exported by this module.

## Grammars

The CLIA synth-funs ship **without** a grammar in the source files, so each
problem gets a *default* CLIA grammar built from its signature: the parameters,
the integer literals appearing in the constraints together with `0`/`1`, the
arithmetic operators `+ - *`, an `ite`, and the comparisons. In call syntax:

```julia
grammar_from_2018_jmbl_fg_max2 = @csgrammar begin
    Start = Term
    Term  = x; Term = y; Term = 0; Term = 1
    Term  = Term + Term
    Term  = Term - Term
    Term  = Term * Term
    Term  = ite(Cond, Term, Term)
    Cond  = Term < Term;  Cond = Term <= Term
    Cond  = Term > Term;  Cond = Term >= Term
    Cond  = eq(Term, Term)
end
```

`eq` maps to SMT `=` and `ite`/`ifelse` to SMT `ite`; `expr_to_smt` inverts
this (see the General-track README for the full mapping). Parameters keep their
original names (`x`, `y`, `x0`…`x18`), so no `_arg_i` renaming is needed.

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
const CT = HerbBenchmarks.CLIA_Track_2019

problem = CT.problem_from_2018_jmbl_fg_max2   # max2(x, y): universally quantified spec
grammar = CT.grammar_from_2018_jmbl_fg_max2
spec    = problem.spec.formula

# enumerate a few candidates
for (i, p) in enumerate(BFSIterator(grammar, :Start, max_depth=3))
    println(rulenode2expr(p, grammar)); i >= 5 && break
end

# the identity candidate max2(x,y)=x is not a max — z3 returns a counterexample:
check_program(spec, :x)
```

```
(verified = false, counterexample = Dict{Symbol, Any}(:y => 0, :x => -1))
```

Per-clause universal satisfaction (`x >= x` holds, `x >= y` does not, and the
"result is x or y" clause holds):

```julia
check_clauses(spec, :x)
```

```
Bool[1, 0, 1]
```

The reference solution verifies:

```julia
check_program(spec, :(ite(x < y, y, x)))
```

```
(verified = true, counterexample = nothing)
```

### Enumerate and check

```julia
using HerbBenchmarks.SyGuSComp2019Common: check_program

function enumerate_and_check(spec, grammar; max_depth=4)
    checked = 0
    for program in BFSIterator(grammar, :Start; max_depth=max_depth)
        checked += 1
        expr = rulenode2expr(program, grammar)
        check_program(spec, expr).verified && return (solution=expr, checked=checked)
    end
    return (solution=nothing, checked=checked)
end

enumerate_and_check(CT.problem_from_2018_jmbl_fg_max2.spec.formula,
                    CT.grammar_from_2018_jmbl_fg_max2)
```

```
(solution = :(ite(x < y, y, x)), checked = 1225)
```

The solution `ite(x < y, y, x)` needs depth 4 in this grammar
(`Start → Term → ite(Cond, Term, Term)`, `Cond → Term < Term`); at
`max_depth=3` the loop exhausts 52 candidates and returns nothing. This is
plain enumerate-and-check — counterexamples are never fed back into the search
(that is CEGIS, deliberately out of scope here). The larger `max19`-style
problems (up to 19 parameters) will not close within a shallow depth bound.

## Z3 query semantics

- **Full spec** (`check_program`): free variables become `declare-const`s, the
  synth-fun is replaced by a `define-fun` of the candidate, and the *negation*
  of the conjunction of all constraints is asserted. `unsat` ⟹ verified; `sat`
  ⟹ the model is a counterexample input (`Dict{Symbol,Any}`, Int values).
- **Per clause** (`check_clauses`): one z3 process, one assumption literal per
  clause with `(check-sat-assuming ...)` (the same "Method 2" as
  `Formal_CLIA_2026`). `true` at position `i` means clause `i` holds
  universally.

## Notes

- `get_problem`, `get_grammar`, `get_problem_grammar_pair`, `get_benchmark`,
  `get_all_identifiers` work with this module. IO-example utilities do not
  apply to `Problem{SMTSpecification}`; use `check_program`/`check_clauses`.
- These 88 problems overlap in origin with the `Formal_CLIA_2026` set (a
  smaller hand-curated CLIA collection); this folder is the complete 2019
  competition CLIA track.
