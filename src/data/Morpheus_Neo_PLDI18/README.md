# Neo PLDI'18 Morpheus benchmark

The 50 Morpheus table-transformation problems used to evaluate Neo:

> Feng, Y., Martins, R., Bastani, O., & Dillig, I. (2018). Program synthesis using
> conflict-driven learning. PLDI 2018, 420–435.

taken from Neo's repository, https://github.com/utopia-group/neo (commit `1d3572f`):
the problems from `problem/Morpheus-PLDI` (one input-output example each, from
StackOverflow posts, originally collected for Morpheus, PLDI 2017) and Neo's sketch of
each solution from `sketches/morpheus_pldi` (the sequence of components, without
arguments). The grammar follows Neo's
`src/org/genesys/language/MorpheusGrammar.java` (terminals in the constructor, components
in `getProductions()`). The semantics follow Neo's interpreter,
`src/org/genesys/interpreter/MorpheusInterpreter.java` and
`src/org/genesys/interpreter/morpheus/*.java`, which runs on Neo's fork of krangl
(https://github.com/fredfeng/krangl, `src/main/kotlin/krangl/Reshape.kt` for the
reshaping components and `hasSameContents`, `src/main/kotlin/krangl/Columns.kt` for
comparisons and aggregators). Tables are plain `DataFrame`s.

## Files

- `generate.py`: generates `data.jl`, `grammars.jl`, `solutions.jl` (and
  `status.json`) from Neo's files: `python3 generate.py <neo>`. For every problem it
  searches the arguments of Neo's sketch for a program whose output matches Neo's,
  evaluating programs with this benchmark's semantics (mirrored from
  `table_functions.jl`).
- `verify.jl`: re-checks the generated solutions in Julia (RuleNode round trip, size,
  and outputs computed with this module's functions and with its interpreter).
- `data.jl`: `problem_NNN`, Neo's example (`NNN` = the number in Neo's file name
  `rNNN.json`). Inputs are `:_arg_1` (and `:_arg_2`); input and output are `DataFrame`s,
  with column types as Neo builds them (a column with any non-integral number is
  `Float64`).
- `grammars.jl`: `grammar_NNN`, Neo's grammar (below), plus `Start`, the problem's
  inputs and its constants.
- `solutions.jl`: `solution_NNN = (expr, rulenode, size, neo_sketch)`. `rulenode` uses
  `grammar_NNN`'s rule indices, including the `Start` rule.
- `table_functions.jl`: the components on DataFrames, and `same_table`.

## Grammar

As in Neo, with 1-based column indices:

```
Table = select(Table, ColList)      Table = group_by(Table, ColList)
Table = inner_join(Table, Table)    Table = gather(Table, ColList)
Table = spread(Table, Col, Col)     Table = unite(Table, Col, Col)
Table = summarise(Table, Aggr, Col) Table = separate(Table, Col)
Table = filter(Table, BinopBool, Col, Const)
Table = mutate(Table, BinopInt, Col, Col)
BinopInt = (/)        BinopBool = (>) | (<) | (==) | (!=)
Aggr = mean | minimum | sum | length          (Neo: mean, min, sum, count)
Col = 1 | ... | 6                             (Neo: maxCol = 6)
ColList = [i] | [i, j] | Not([i]) | Not([i, j])   (i < j ≤ 6; Neo: lists of 1 or 2)
Const = every value in the input tables
```

New columns are not named by the grammar: each component names the columns it creates.
So the output of a solution is compared with `same_table`, not `==`.

## Semantics

Everything follows Neo, except where noted:

- **Output check.** `same_table` is Neo's `hasSameContents`: same number of rows and
  columns, and every row of each table, taken as a set of strings, is covered by a row of
  the other (numbers within 1e-5). Column names, column order and row order are ignored.
- **New column names.** Neo takes them from a global counter (`MORPHEUS1`, ...). Here a
  name is derived from the operation, its arguments and its input table, so evaluation is
  deterministic. Two columns share a name only if the same computation made them, which
  matters for `inner_join` (it joins on the shared columns).
- **Grouping.** `group_by` returns a `GroupedDataFrame`; `summarise` aggregates per group,
  every other component sees the ungrouped table (in Neo, some keep the grouping). Every
  Neo sketch uses `group_by` right before `summarise`.
- **Failures.** Where Neo returns an empty table (e.g. `spread` with a missing
  combination, `separate` into other than two parts), the component throws.
- Kept from Neo: `<` is "not `>`" (it keeps values equal to the constant); `>` and `<`
  need a numeric column and an integer constant; `==` and `!=` compare as Java's
  `equals` (values of different types are never equal); `gather` keeps numbers if all
  gathered columns are numeric and makes strings otherwise; `mean`, `minimum` and `sum`
  give a `Float64`; `group_by` cannot take a `Not`.

## Solutions

All 50 problems have a solution with the components of Neo's sketch. For each,
`generate.py` prefers a program whose output also matches strictly (the same rows as a
multiset, once the columns are matched in some order), and all 50 do; Neo's own check
is looser (see `same_table`), and accepted a spurious cross join for problem 029.

Solution sizes (nodes, including `Start`):
8: 1; 9: 3; 10: 2; 11: 10; 12: 4; 13: 9; 14: 12; 15: 3; 16: 5; 17: 1; mean 12.80.
Grammars have 73–120 rules (4–51 constants). Problem 042 has two input tables.
