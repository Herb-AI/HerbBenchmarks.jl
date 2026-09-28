# Hacker's Delight (SyGuS, `BV` logic)

The 27 Hacker's Delight bit-manipulation problems from the SyGuS benchmark suite
(`hd-01.sl` ... `hd-27.sl`, logic `BV`, 64-bit bit-vectors), converted from
constraint-based synthesis problems into programming-by-example problems.

Unlike `PBE_BV_Track_2018` (its parent module), the original files are *not* PBE
problems: they specify the target through a reference implementation,

```smt2
(define-fun hd01 ((x (BitVec 64))) (BitVec 64) (bvand x (bvsub x #x0000000000000001)))
(declare-var x (BitVec 64))
(constraint (= (hd01 x) (f x)))
```

The examples in `data.jl` were sampled from exactly that constraint with z3.

## What is in here

| file | contents |
| --- | --- |
| `hd_primitives.jl` | the SMT-LIB `FixedSizeBitVectors` operators at width 64 |
| `grammars.jl` | `grammar_hd_01` ... `grammar_hd_27`, the original `synth-fun` grammars |
| `data.jl` | `problem_hd_01` ... `problem_hd_27`, 10 `IOExample`s each |
| `solutions.jl` | `solution_hd_01` ... `solution_hd_27`, the original `define-fun`s |

Arguments are named `_arg_1`, `_arg_2`, ... in the HerbBenchmarks convention; the
mapping to the SyGuS names (`x`, `y`, `m`, `k`, `a`, `b`, `c`) is in a comment
above each grammar.

Four problems -- `hd_10`, `hd_11`, `hd_12` and `hd_18` -- synthesise a *predicate*:
their `Start` nonterminal is `Bool` and their `IOExample`s have `Bool` outputs.
The other 23 return a bit-vector. Every grammar has two sorts; `Start` is always
the start symbol.

```julia
using HerbBenchmarks
const HD = HerbBenchmarks.PBE_BV_Track_2018.Hackers_Delight

pgp = HerbBenchmarks.get_problem_grammar_pair(HD, "hd_01")
interpret = HD.make_hd_interpreter(pgp.grammar)

# bvand(_arg_1, bvsub(_arg_1, 0x1)) -- the reference program
prog = RuleNode(3, [RuleNode(16), RuleNode(15, [RuleNode(16), RuleNode(19)])])
all(interpret(prog, ex) == ex.out for ex in pgp.problem.spec)   # true
```

## How the examples were sampled

For each benchmark the reference implementation is handed to z3 as a constraint
over a free input and a free output,

```smt2
(assert (= __out (hd01 x)))
```

and every example is a **model of that constraint**, so it is consistent with the
reference implementation by construction. Ten random models would mostly take the
same path through the specification, so the solver is additionally driven with
*assumptions* (which only ever restrict the models, never the constraint):

* **branch and predicate coverage** -- every Boolean subterm of the specification
  (`ite` conditions, comparisons, and the Boolean result of the predicate
  problems) is forced to `true` in one model and to `false` in another;
* **magnitude corner cases** -- the first argument is pinned to `0`, `1`,
  all-ones and the sign bit;
* **output diversity** -- each model is asked to produce an output value that has
  not been seen yet (dropped when unsatisfiable, e.g. for the `Bool` problems);
* **randomised bit assumptions** -- a random subset of the input bits is pinned to
  random values at a randomly chosen magnitude (8/16/32/64 significant bits), the
  solver fills in the rest;
* every model must differ from all previously sampled **inputs**.

Two problems take a shift distance `k` (`hd_19`, `hd_26`). It is restricted to
`[1, 63]`: for `k >= 64` every SMT-LIB shift collapses to `0`, and such examples
carry no information about the problem.

All 270 examples were re-checked in Julia: evaluating `solution_hd_NN` on the
inputs reproduces the recorded outputs exactly.

## Primitives

`hd_primitives.jl` implements the SMT-LIB 2.6 `FixedSizeBitVectors` operators at
width 64. The cases where a naive Julia translation is wrong:

| operator | SMT-LIB semantics |
| --- | --- |
| `bvudiv(a, 0)` | all-ones, **not** an error |
| `bvurem(a, 0)` | `a` |
| `bvsdiv`, `bvsrem` | defined by reduction to `bvudiv`/`bvurem`, so `bvsdiv(a, 0)` is `-1` for `a >= 0` and `1` for `a < 0`, and `bvsdiv(typemin, -1)` wraps to `typemin` instead of overflowing |
| `bvshl`, `bvlshr` | distance `>= 64` yields `0` |
| `bvashr` | *arithmetic* shift -- Julia's `>>` on a `UInt64` is a **logical** shift, so the operand is reinterpreted as `Int64`; distance `>= 64` yields all-ones or `0` depending on the sign |
| `bvslt`, `bvsle`, `bvsgt`, `bvsge` | two's complement comparison, not `UInt64` comparison |

These were differentially tested against z3 on 135,310 cases (all corner-case
pairs plus randomised inputs and shift distances around and beyond the width);
all of them agree.

`bvredor` deliberately deviates from SMT-LIB: the standard's `bvredor` returns a
`(_ BitVec 1)`, but `hd-18.sl` uses it as a `Bool` (under `not`/`and`, and as a
production of the `Bool` nonterminal), which only type-checks with a `Bool`
result.

## Specifications that do not match their description

Every `.sl` file starts with a natural-language comment. Each `define-fun` was
checked against an independent 64-bit implementation of that comment by asking
z3 to prove equivalence. **17 of 27 match; 10 do not.** These are properties of
the upstream SyGuS benchmarks, not of this conversion -- the `define-fun` is what
the SyGuS `constraint` refers to, so it is what the examples here were sampled
from, and it is what a synthesiser is expected to reproduce.

Most of the mismatches are 32-bit Hacker's Delight algorithms transplanted to
64-bit bit-vectors with their 32-bit constants left in place.

| problem | comment says | what the `define-fun` actually computes |
| --- | --- | --- |
| `hd_09` | absolute value | the 32-bit trick, `(x ^ (x >>a 31)) - (x >>a 31)`; correct only for `x` in 32 signed bits |
| `hd_12` | `nlz(x) < nlz(y)` | `nlz(x) <= nlz(y)` (`x=0xbbc15a1f00000000, y=0x8648000000000000`) |
| `hd_13` | sign function | uses a 31-bit shift; wrong for *every* `x > 0` (e.g. `sign(1) = 0x1ffffffff`). Correct only for `-2^31 <= x <= 0` |
| `hd_15` | floor of the average | *ceiling* of the average, `(x|y) - ((x^y) >> 1)` |
| `hd_20` | next higher number with the same popcount | uses `x ^ (x & -x)` where the algorithm needs `x ^ (x + (x & -x))`; e.g. `f(0b110000) = 64`, correct is `65` |
| `hd_22` | parity | parity of the **low 32 bits** only |
| `hd_23` | popcount | popcount of the **low 32 bits** only (`f(0xffffffffffffffff) = 32`) |
| `hd_24` | round up to the next power of two | the 32-bit `clp2` (missing the `>> 32` step); correct only for `x <= 2^31` |
| `hd_25` | high half of the 128-bit product | the `mulhu` schema with 16-bit shifts and an all-ones mask instead of `0xffff`; correct only for `x, y < 2^16` |
| `hd_26` | round `x` up to a multiple of `2^k` | adds `2^k + 1` instead of `2^k - 1`, i.e. rounds `x + 2` up to a multiple of `2^k` |

`hd_16` and `hd_27` carry no comment at all; they are signed `max` and signed
`min` respectively.

Two further points that are not bugs but are worth knowing:

* `hd_02` ("test if `x` is of the form `2^n - 1`") returns a bit-vector, not a
  `Bool`: the test is `f(x) == 0`. That is faithful to the original.
* `hd_11` and `hd_12` carry the *same* comment; `hd_11` really is `<`, `hd_12` is
  `<=`.

## Source

Files taken from `src/test/benchmarks/hackers-delight/` of the Probe artifact,
which in turn takes them from the SyGuS benchmark repository (see
`../../citation.bib`). The problems originate from Henry S. Warren Jr.,
*Hacker's Delight*, Addison-Wesley.
