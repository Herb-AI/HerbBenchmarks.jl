# Formal CLIA 2026

31 conditional linear integer arithmetic (CLIA) synthesis problems specified by
**universally quantified formal SMT constraints** — not IO examples. Every
specification is a SyGuS v2 file (`set-logic LIA`) with a single
`(synth-fun f ((p Int) ...) Int)`, universally quantified `declare-var`s, and a
set of `(constraint ...)` clauses. A program solves a problem iff it satisfies
*all* clauses for *all* inputs, which is decided by the Z3 SMT solver.

The problems originate from a master students' CEGIS project:
[Rav0702/CEGIS](https://github.com/Rav0702/CEGIS), branch
`partial_specification_satisfaction_and_iterator_constraints` (see
`citation.bib`). The original `.sl` files are shipped unmodified in
`specifications/`, renamed to the benchmark id. `grammars.jl` and `data.jl` are
generated from those files (each problem's grammar contains the problem's
arguments, the integer constants appearing in its constraints plus `0`/`1`,
`+ - *`, `ifelse`, and the comparison operators).

In contrast to the students' project, this benchmark set deliberately ships
**no CEGIS loop** — only utilities to *check* enumerated programs against the
specification (whole-spec and per-clause), exactly in the students' style:
Z3 is run as a subprocess on a temporary `.smt2` file.

## Problems

| id | synth-fun | #params | #clauses | students' reference solution (`.solution` file) |
|----|-----------|---------|----------|--------------------------------------------------|
| `abs` | `absv` | 1 | 3 | — |
| `abs_diff` | `adiff` | 2 | 4 | — |
| `clamp01` | `clamp` | 1 | 3 | — |
| `min2` | `min2` | 2 | 3 | — |
| `min3` | `min3` | 3 | 4 | — |
| `relu` | `relu` | 1 | 3 | — |
| `sign` | `sign` | 1 | 3 | — |
| `max3` | `max3` | 3 | 4 | — |
| `max4` | `max4` | 4 | 5 | — |
| `max5` | `max5` | 5 | 6 | — |
| `max6` | `max6` | 6 | 7 | — |
| `max7` | `max7` | 7 | 8 | — |
| `max8` | `max8` | 8 | 9 | — |
| `abs_value_easy` | `abs_val` | 1 | 3 | `ifelse(x < 0, 0 - x, x)` ✓ |
| `abs_value_medium` | `abs_val` | 1 | 11 | `x` ✗ |
| `abs_value_hard` | `abs_val` | 1 | 15 | `x` ✗ |
| `clamp_value_easy` | `clamp` | 1 | 4 | `ifelse(x < 10, 0 < x, 10)` ✗ (cegis_failure) |
| `clamp_value_medium` | `clamp` | 3 | 6 | `ifelse(max_val < x, max_val, x)` ✗ |
| `clamp_value_hard` | `adaptive_clamp` | 5 | 8 | `(hard_max < 0 - soft_min) * soft_min` ✗ (cegis_failure) |
| `conditional_sum_easy` | `cond_sum` | 2 | 3 | `(x < x * x) * 10` ✗ (cegis_failure) |
| `conditional_sum_medium` | `cond_sum` | 2 | 5 | `0 - (x < y)` ✗ (cegis_failure) |
| `conditional_sum_hard` | `cond_sum` | 3 | 8 | `ifelse(z < 15, 0, z)` ✗ (cegis_failure) |
| `find_max_three_easy` | `max3` | 3 | 4 | `(1 >= y * x) - 1` ✗ (cegis_failure) |
| `find_max_three_medium` | `max3` | 3 | 10 | `ifelse(y < x, x, y)` ✗ |
| `find_max_three_hard` | `max3` | 3 | 15 | `ifelse(y < x, x, y)` ✗ |
| `max_two_easy` | `max2` | 2 | 3 | `ifelse(y < x, x, y)` ✓ |
| `max_two_medium` | `max2` | 2 | 5 | `ifelse(y < x, x, y)` ✓ |
| `max_two_hard` | `max2` | 2 | 15 | `y` ✗ |
| `sign_function_easy` | `sign` | 1 | 4 | `(0 < x) - (x < 0)` ✓ |
| `sign_function_medium` | `sign` | 1 | 17 | `x` ✗ |
| `sign_function_hard` | `sign` | 1 | 18 | `x` ✗ |

✓/✗ = whether the recorded solution actually passes our Z3 verification of the
full spec. The `formal/` and `max_n/` problems ship no `.solution` files; the
obvious nested-`ifelse` solutions of all 13 verify. Several `.solution` files
recorded by the students' pipeline as `cegis_success` (e.g. `x` for
`abs_value_medium`) do **not** satisfy their own spec — treat the ✗ rows as
"no known reference solution", the specs themselves are still meaningful.
Solutions like `(0 < x) - (x < 0)` use the students' Bool→Int coercion; in
this grammar write them with `ifelse`, e.g.
`ifelse(0 < x, 1, 0) - ifelse(x < 0, 1, 0)` (verified ✓ for
`sign_function_easy`).

Note on `min`/`max` helpers: `conditional_sum_medium`, `find_max_three_medium`,
`find_max_three_hard`, and `max_two_hard` declare helper signatures
`(declare-fun min (Int Int) Int)` / `max` and use them in constraints. The
checking utilities give them their standard LIA semantics
(`(define-fun max ((a Int) (b Int)) Int (ite (>= a b) a b))`, analogously for
`min`) instead of leaving them uninterpreted — with uninterpreted symbols no
program could ever be verified.

## Requirements

- A `z3` binary on your `PATH` (`brew install z3` on macOS, or your distro's
  package; tested with Z3 4.16.0). The module itself loads without z3 — the
  binary is only invoked inside `check_program`/`check_clauses`.
- [`HerbSearch`](https://github.com/Herb-AI/HerbSearch.jl) for the iterators.
  It is *not* a dependency of HerbBenchmarks — add it to your own environment
  (`pkg> add HerbSearch`) together with `HerbGrammar` and `HerbBenchmarks`.

## Initializing and running an iterator

```julia
using HerbBenchmarks, HerbGrammar, HerbSearch
const CLIA = HerbBenchmarks.Formal_CLIA_2026

# Problems and grammars share the same id suffix:
problem = CLIA.problem_abs          # Problem{SMTSpecification}
grammar = CLIA.grammar_abs          # matching @csgrammar
spec    = problem.spec.formula      # (logic, fname, params, free_vars, constraints, spec_file)

# ... or fetch both through the generic interface:
pair = get_problem_grammar_pair(CLIA, "abs")   # pair.problem, pair.grammar

# Enumerate programs breadth-first:
iterator = BFSIterator(grammar, :Start, max_depth=3)
for (i, program) in enumerate(iterator)
    println(rulenode2expr(program, grammar))
    i >= 5 && break
end
```

Output:

```
_arg_1
0
1
_arg_1 + _arg_1
_arg_1 + 0
```

## Checking programs against the specification with Z3

`check_program(spec, expr)` converts a Julia expression (as produced by
`rulenode2expr`) to an SMT-LIB term via `expr_to_smt`, builds a verification
query, and runs z3 on a temporary `.smt2` file. The identity candidate does
not implement `abs`, and z3 hands back a concrete counterexample input:

```julia
identity_expr = :(_arg_1)           # e.g. rulenode2expr(program, grammar)
expr_to_smt(identity_expr, spec.params)   # "x"
check_program(spec, identity_expr)
```

```
(verified = false, counterexample = Dict(:x => -1))
```

The reference solution verifies:

```julia
ref_expr = :(ifelse(_arg_1 >= 0, _arg_1, 0 - _arg_1))
expr_to_smt(ref_expr, spec.params)  # "(ite (>= x 0) x (- 0 x))"
check_program(spec, ref_expr)
```

```
(verified = true, counterexample = nothing)
```

`check_clauses` reports *per-clause* universal satisfaction (all clauses are
checked in one z3 process via `check-sat-assuming`, see below). The identity
candidate on `abs` satisfies only the second clause,
`(=> (>= x 0) (= (absv x) x))`:

```julia
check_clauses(spec, identity_expr)
```

```
Bool[0, 1, 0]
```

For reference, the full-spec query that `check_program` sends to z3
(`verification_query(spec, expr_to_smt(identity_expr, spec.params))`):

```smt2
(set-logic LIA)
(define-fun absv ((x Int)) Int x)
(declare-const x Int)
(assert (not (and (>= (absv x) 0) (=> (>= x 0) (= (absv x) x)) (=> (< x 0) (= (absv x) (- x))))))
(check-sat)
(get-value (x))
```

## Putting it together: enumerate and check

Plain enumerate-and-check: walk the iterator and stop at the first program z3
verifies. This is deliberately **not** CEGIS — no counterexample is ever fed
back into the search; counterexample-guided loops are out of scope for this
benchmark set (see the students' project for one).

```julia
using HerbBenchmarks, HerbGrammar, HerbSearch
const CLIA = HerbBenchmarks.Formal_CLIA_2026
using .CLIA: check_program

function enumerate_and_check(spec, grammar; max_depth=4)
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

enumerate_and_check(CLIA.problem_abs.spec.formula, CLIA.grammar_abs)
```

Output (about 7 seconds — one z3 subprocess per candidate):

```
(solution = :(ifelse(_arg_1 < 0, 0 - _arg_1, _arg_1)), checked = 1158)
```

## Z3 query semantics

- **Full spec** (`check_program` / `verification_query`): the candidate is
  inlined as a `define-fun`, the free variables become `declare-const`s, and
  the *negation* of the conjunction of all constraint clauses is asserted.
  `unsat` ⟹ no input violates any clause ⟹ the program satisfies the
  specification universally (`verified = true`). `sat` ⟹ the model is a
  concrete counterexample input (returned as a `Dict{Symbol,Int}`).
- **Per clause** (`check_clauses`): a single z3 process declares one Boolean
  assumption literal `csat_i` per clause with `(assert (=> csat_i (not Ci)))`,
  then runs `(check-sat-assuming (csat_i))` once per clause (the students'
  "Method 2": the context is parsed once and learned clauses are reused).
  `unsat` after the `clause_i` echo marker ⟹ clause `i` is satisfied
  universally.

## Notes and limitations

- `get_problem`, `get_grammar`, `get_problem_grammar_pair`, `get_benchmark`,
  and `get_all_identifiers` all work with this module (identifiers are e.g.
  `"abs"`, `"max_two_hard"`). Utilities that assume IO-example specifications —
  e.g. `HerbBenchmarks.write_problem` or evaluation-based search helpers such
  as `HerbSearch.synth` — do not apply to `Problem{SMTSpecification}`; use
  `check_program`/`check_clauses` instead.
- `parse_spec(path)` re-parses any of the `.sl` files into a `CLIASpec` with
  the same fields as the NamedTuple stored in the problems (the constraint
  strings in `data.jl` are exactly its canonical serialization).
