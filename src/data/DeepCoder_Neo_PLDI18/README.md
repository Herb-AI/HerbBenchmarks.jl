# Neo PLDI'18 DeepCoder benchmark

The 100 DeepCoder problems used to evaluate Neo:

> Feng, Y., Martins, R., Bastani, O., & Dillig, I. (2018). Program synthesis using
> conflict-driven learning. PLDI 2018, 420–435.

taken from Neo's repository, https://github.com/utopia-group/neo, folder
`problem/DeepCoder-pldi18` (commit `1d3572f`). Unlike `DeepCoder_2016` (which is
Neo's `problem/DeepCoder-T5` set and has examples only), every problem here comes
with the program that generated it: five components, 7–12 nodes in this grammar.

## Files

- `generate.py`: generates `data.jl`, `grammars.jl`, `solutions.jl` (and
  `status.json`) from Neo's JSON files:
  `python3 generate.py <neo>/problem/DeepCoder-pldi18`. It translates each
  program into this grammar, builds its `RuleNode`, and evaluates it on Neo's
  examples with this benchmark's semantics (mirrored from `list_functions.jl`).
- `verify.jl`: re-checks the generated solutions in Julia (RuleNode round trip,
  size, and outputs computed with this module's functions).
- `data.jl`: `problem_NNN`, Neo's examples (`NNN` = the number in Neo's file name
  `progNNN.json`; the files' `name` field is not used, since `prog98.json` is also
  named `prog48`).
- `grammars.jl`: `grammar_NNN`, the DeepCoder grammar of this repository with
  `access` instead of `getindex`, plus `Start` and the problem's arguments
  (`ExprArr` for lists, `ExprNum` for integers).
- `solutions.jl`: `solution_NNN = (expr, rulenode, size, neo_program)`.
  `rulenode` uses `grammar_NNN`'s rule indices, including the `Start` rule.
- `list_functions.jl`: copied from `DeepCoder_2016`, plus `access`, and with Neo's
  power (see Semantics).

## Semantics

Neo's `ACCESS` is 0-based. This benchmark uses `access(xs, n) = xs[n + 1]`,
which throws out of range (Neo returns 256 as a "no value" placeholder).
Powers follow Neo: Neo's `^` (`PrimitiveBinop.java`) starts from `res = a` and
multiplies by `a` another `b` times, so `MAP-POW(x, k)` computes x^(k+1), and x
for k ≤ 0. `binopPow` does the same, with checked multiplication (so it throws
on overflow, like `binopMult`). Everything else follows `DeepCoder_2016`'s `list_functions.jl`.

## Benched problems

90 of the 100 solutions reproduce Neo's outputs under these semantics.
The other 10 are commented out in all three files (marked `BENCHED`,
with the reason). `generate.py` diagnoses each one by switching on Neo's
semantics until the outputs match:

- **overflow**: Neo's interpreter is Java with 32-bit `int`s, which wrap around on overflow; Herb multiplies with `Base.checked_mul`, which throws. Following wrap-around is not a semantics we want.

| Problem | Reason | Solution |
|---|---|---|
| 002 | overflow | `first(zipwithMin(scanl1Minus(scanl1Mult(_arg_1)), reverse(_arg_1)))` |
| 006 | overflow | `countNmod(scanl1Mult(mapPlus(filterNeq(mapPlus(_arg_1, -3), -3), 2)), 2)` |
| 019 | overflow | `access(_arg_1, first(scanl1Mult(scanl1Plus(mapMult(_arg_1, 3)))))` |
| 025 | overflow | `first(mapPlus(scanl1Mult(mapPow(scanl1Min(_arg_1), 3)), -1))` |
| 044 | overflow | `drop(mapMult(_arg_1, -2), first(scanl1Mult(scanl1Minus(_arg_1))))` |
| 075 | overflow | `countSt(reverse(scanl1Mult(zipwithMinus(_arg_1, sort(_arg_1)))), 1)` |
| 076 | overflow | `last(zipwithMinus(scanl1Mult(mapDiv(_arg_1, 1)), mapPlus(_arg_1, 1)))` |
| 085 | overflow | `sort(scanl1Max(take(_arg_1, first(scanl1Mult(_arg_1)))))` |
| 087 | overflow | `first(scanl1Mult(mapMult(drop(mapPlus(_arg_1, 3), _arg_2), 2)))` |
| 093 | overflow | `first(mapMult(scanl1Max(scanl1Mult(mapPow(_arg_1, 3))), 2))` |

Solution sizes of the 90 active problems (nodes, including `Start`):
7: 1, 8: 12, 9: 39, 10: 28, 11: 9, 12: 1; mean 9.39.
