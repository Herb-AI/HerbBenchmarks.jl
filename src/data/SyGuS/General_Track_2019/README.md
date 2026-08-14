# SyGuS-Comp 2019 — General Track

All **945** General-track benchmarks of the 2019 Syntax-Guided Synthesis
Competition (SyGuS-Comp), as formal synthesis problems: each specification is
a SyGuS-IF **v1** file (`set-logic BV` or `LIA`) with one or more
`(synth-fun ...)`s, universally quantified `declare-var`s, and
`(constraint ...)` clauses that are arbitrary SMT formulas — *not* IO
examples. A candidate solves a problem iff it satisfies all constraints for
all inputs, which is decided by the Z3 SMT solver.

Provenance: copied verbatim from the SyGuS-Comp benchmark collection
([SyGuS-Org/benchmarks](https://github.com/SyGuS-Org/benchmarks)), directory
`comp/2019/General_Track` (see `citation.bib`). Local source:
`BenchmarkHackathon/benchmarks/comp/2019/General_Track`. The five benchmark
families become id prefixes (`<subdirs>_<basename>`, sanitized to Julia
identifiers, non-alphanumerics → `_`):

| family (id prefix) | files | contents |
|---|---|---|
| `bv_conditional_inverses_*` | 160 | 4-bit conditional inverse synthesis, single synth-fun **with** v1 grammar |
| `bv_invertibility_conditions_*` | 160 | 4-bit invertibility conditions (Bool synth-fun, two-nonterminal grammar) |
| `cegist_cav18_*` | 58 | `inv/`, `comparisons/`, `hackers/`, `other/`: BV32/Bool problems, synth-funs **without** grammars, up to 3 synth-funs per file |
| `from_2018_*` | 551 | LIA + BV64/BV32 problems incl. `icfp_*` (PBE-shaped BV constraints, treated as formal constraints), `CrCi/`, `hd-pareto/` |
| `woosuk_*` | 16 | Boolean circuit resynthesis with 9-nonterminal depth grammars |

Counts: 945 source files, **945 shipped, 0 excluded**. Every shipped
specification was batch-verified: `check_program` with a trivial candidate
returns a clean `sat`/`unsat` verdict via z3 on every problem.

## Layout

- `specifications/<id>.sl` — the original files, unmodified.
- `data.jl` (generated) — `problem_<id> = Problem(..., SMTSpecification((...)))`
  with fields `logic`, `synth_funs` (vector of
  `(name, params, param_sorts, ret_sort)` NamedTuples), `free_vars`
  (`(name, sort)` NamedTuples), `n_constraints`, `spec_file`, and `nt_sorts`
  (nonterminal → sort of the primary grammar). Constraint bodies and
  `define-fun` preambles are *not* inlined (files can be large); the checking
  utilities always (re)parse the `.sl` via `parse_spec_file(spec_file)`.
- `grammars.jl` (generated) — `grammar_<id> = @csgrammar ... ` per problem.
- Shared parsing/checking code: `../sygus_comp_2019_common.jl`
  (module `HerbBenchmarks.SyGuSComp2019Common`), re-exported by this module.

## Grammar translation rules

File grammars (SyGuS-IF v1) are translated 1:1 into `@csgrammar`:

- Nonterminal names are kept as-is (`Start`, `StartBv`, `depth7`, `NT1`, ...).
- Every SMT operator becomes a Julia *call* with the same name:
  `(bvadd Start Start)` → `bvadd(Start, Start)`, `(and D1 D2)` → `and(D1, D2)`,
  `(shr1 Start)` → `shr1(Start)`. Operators that are not valid Julia call
  names are mapped: `=` → `eq(...)`, `=>` → `implies(...)`, `ite` → `ite(...)`;
  names with dashes use `var"..."` (e.g. `var"get-y"(...)`). Arithmetic and
  comparisons (`+ - * < <= > >=`) are written infix — Julia parses them to the
  same call form. `expr_to_smt` inverts exactly this mapping (`eq`→`=`,
  `implies`→`=>`, `ite`/`ifelse`→`ite`, everything else verbatim).
- Parameters appear under their **original names** (`s`, `t`, `n89`,
  `var"x.end"`) — no `_arg_i` renaming, so `expr_to_smt` needs no argument
  mapping.
- BV literals become `UInt64` hex literals (`#x8` → `0x0000000000000008`).
  When printing SMT, `expr_to_smt` pads them to the problem's BitVec width,
  which it reads from `ret_sort`/`nt_sorts` (each problem uses a single
  width). The `nt_sorts` field of every problem maps the primary grammar's
  nonterminals to their SMT sorts.
- The v1 special terminals `(Constant <sort>)` / `(Variable <sort>)` (29/28
  `from_2018` files) expand to the constants `0`,`1` of that sort / all
  synth-fun parameters of that sort.
- Two grammars (`from_2018_inv_gen_ex23`, `from_2018_unbdd_inv_gen_ex23`)
  enumerate ~10 000 integer constants (−5000..5000) in a `Const`
  nonterminal; these are capped to the 120 literals closest to 0 (the full
  range made the grammar unusable for enumeration and pathologically slow to
  load). This is the only deviation from the source grammars.
- The 107 synth-funs **without** a grammar (all of `cegist_cav18`, some
  `from_2018`) get a *default* grammar built from the signature: parameters,
  literal constants harvested from the constraints plus `0`/`1`, and a
  standard operator set (BV: `bvadd bvsub bvand bvor bvxor bvmul bvudiv
  bvurem bvshl bvlshr bvashr bvneg bvnot`, `ite` over BV comparisons; LIA:
  `+ - *`, `ite`, comparisons; Bool: `and or not xor`). These defaults are
  *not* part of the source files.

### Multi-synth-fun problems

47 problems (all of `cegist_cav18/inv`, some `from_2018` `t*.sl`) synthesize
**several** functions at once. For these, `grammar_<id>__<fname>` is defined
per synthesized function and `grammar_<id>` is an alias of the first one, e.g.

```julia
GT.problem_cegist_cav18_inv_danger_loop40.spec.formula.synth_funs
# 3-element Vector: (name = :D, ...Bool), (name = :R, ...BitVec 32), (name = :S, ...)
GT.grammar_cegist_cav18_inv_danger_loop40__D   # Bool grammar for D
GT.grammar_cegist_cav18_inv_danger_loop40__R   # BV32 grammar for R
GT.grammar_cegist_cav18_inv_danger_loop40__S   # BV32 grammar for S
```

`check_program` then takes a `Dict{Symbol,candidate}` keyed by synth-fun name
(see below).

## Requirements

- A `z3` binary on your `PATH` (`brew install z3`; tested with Z3 4.16.0).
  The module loads without z3 — the binary is only invoked inside
  `check_program`/`check_clauses`.
- [`HerbSearch`](https://github.com/Herb-AI/HerbSearch.jl) for the iterators
  (not a dependency of HerbBenchmarks; `pkg> add HerbSearch`).

## Initializing and running an iterator

```julia
using HerbBenchmarks, HerbGrammar, HerbSearch
const GT = HerbBenchmarks.General_Track_2019

problem = GT.problem_woosuk_sygus_iter_14_1   # Problem{SMTSpecification}
grammar = GT.grammar_woosuk_sygus_iter_14_1   # the file's 9-nonterminal depth grammar
spec    = problem.spec.formula                # logic, synth_funs, free_vars, n_constraints, spec_file, nt_sorts

# ... or through the generic interface:
pair = get_problem_grammar_pair(GT, "woosuk_sygus_iter_14_1")

iterator = BFSIterator(grammar, :Start, max_depth=6)
for (i, program) in enumerate(iterator)
    println(rulenode2expr(program, grammar))
    i >= 5 && break
end
```

Output:

```
n136
n158
not(n136)
not(n158)
not(n136)
```

## Checking programs against the specification with Z3

`check_program(spec, expr)` converts the Julia expression to an SMT-LIB term
(`expr_to_smt`), builds a verification query on a temporary `.smt2` file, and
runs z3. `unsat` ⟹ verified; `sat` ⟹ the model is a counterexample.

```julia
using HerbBenchmarks.SyGuSComp2019Common: check_program, check_clauses, expr_to_smt, verification_query

check_program(spec, true)     # candidate: the constant true circuit
```

```
(verified = false, counterexample = Dict{Symbol, Any}(:n158 => true, :n129 => false, :n89 => true, :n136 => false))
```

The reference circuit (the `origCir` define-fun body written in the grammar's
call syntax) verifies:

```julia
ref = :(not(and(and(not(and(n136, n129)), n89), n158)))
check_program(spec, ref)
```

```
(verified = true, counterexample = nothing)
```

A BV example (`from_2018`, 32-bit) with the identity candidate — note
the BV counterexample values come back as `UInt64`:

```julia
bv = GT.problem_from_2018_btr_solution_4.spec.formula
check_program(bv, :x)
```

```
(verified = false, counterexample = Dict{Symbol, Any}(:bit => 0x0000000000000000, :x => 0x0000000080000001))
```

And a multi-synth-fun problem takes one candidate per synthesized function
(exprs from the per-function grammars, or raw SMT strings):

```julia
cg = GT.problem_cegist_cav18_inv_danger_loop40.spec.formula
check_program(cg, Dict{Symbol,Any}(:D => true, :R => :x, :S => :y))
```

```
(verified = false, counterexample = Dict{Symbol, Any}(:y => 0x000000000000dfff, :x => 0x000000000000dfff))
```

## Putting it together: enumerate and check

```julia
using HerbBenchmarks, HerbGrammar, HerbSearch
using HerbBenchmarks.SyGuSComp2019Common: check_program

function enumerate_and_check(spec, grammar; max_depth=6)
    checked = 0
    for program in BFSIterator(grammar, :Start; max_depth=max_depth)
        checked += 1
        expr = rulenode2expr(program, grammar)
        if check_program(spec, expr).verified
            return (solution=expr, checked=checked)
        end
    end
    return (solution=nothing, checked=checked)
end

GT = HerbBenchmarks.General_Track_2019
enumerate_and_check(GT.problem_bv_conditional_inverses_find_inv_ne_bvadd_4bit.spec.formula,
                    GT.grammar_bv_conditional_inverses_find_inv_ne_bvadd_4bit)
```

Output (about 1.3 seconds — one z3 subprocess per candidate; deliberately **not**
CEGIS, counterexamples are never fed back into the search):

```
(solution = :(bvadd(bvnot(s), t)), checked = 234)
```

## Z3 query semantics

- **Full spec** (`check_program`/`verification_query`): free variables become
  `declare-const`s, the file's preamble is emitted *in source order* with each
  `synth-fun` replaced at its position by a `define-fun` of the candidate (so
  `define-fun`s that call the synthesized function — e.g. the
  `bv_conditional_inverses` `l`/`SC` helpers — stay well-formed), and the
  *negation* of the conjunction of all constraints is asserted. `unsat` ⟹
  verified. v1 quirks are normalized on the way out: `(BitVec n)` → SMT-LIB 2
  `(_ BitVec n)`, and v1 `let` bindings `(x <sort> <term>)` → `(x <term>)`.
- **Per clause** (`check_clauses`): one z3 process, one assumption literal
  per clause with `(assert (=> csat_i (not Ci)))` and one
  `(check-sat-assuming (csat_i))` per clause — the same "Method 2" as
  `Formal_CLIA_2026`. `true` at position `i` means clause `i` holds
  universally for the candidate. Note the clauses are checked independently;
  the conjunction of per-clause verdicts equals full-spec verification.

## Notes and limitations

- `get_problem`, `get_grammar`, `get_problem_grammar_pair`, `get_benchmark`,
  `get_all_identifiers` work with this module. IO-example utilities
  (`write_problem`, `HerbSearch.synth`, interpreters) do not apply to
  `Problem{SMTSpecification}`; use `check_program`/`check_clauses`.
- `parse_spec_file(path)` re-parses any `.sl` into a `CompSpec` (ordered
  preamble items, signatures, free vars incl. sorts, canonical constraint
  strings).
- The `from_2018` `icfp_*`/PBE-shaped files have **no** `declare-var`s (all
  constraints are ground); `check_program` then returns an empty
  counterexample `Dict` when unverified.
