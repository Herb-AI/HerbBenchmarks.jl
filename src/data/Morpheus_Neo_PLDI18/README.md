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
  searches the arguments of Neo's sketch for a program whose output has Neo's expected
  `contents`,
  evaluating programs with this benchmark's semantics (mirrored from
  `table_functions.jl`).
- `verify.jl`: re-checks the generated solutions in Julia (RuleNode round trip, size,
  and outputs computed with this module's functions and with its interpreter).
- `data.jl`: `problem_NNN`, Neo's example (`NNN` = the number in Neo's file name
  `rNNN.json`). Inputs are `:_arg_1` (and `:_arg_2`), `DataFrame`s with column types as
  Neo builds them (a column with any non-integral number is `Float64`). The output is
  stored as `contents(DataFrame(...))` (see Output, below).
- `grammars.jl`: `grammar_NNN`, Neo's grammar (below), plus `Start`, the problem's
  inputs and its constants.
- `solutions.jl`: `solution_NNN = (expr, rulenode, size, neo_sketch)`. `rulenode` uses
  `grammar_NNN`'s rule indices, including the `Start` rule.
- `table_functions.jl`: the components on DataFrames, `contents`, and `same_table`.

## Grammar

As in Neo, with 1-based column indices, plus `contents` on the start rule:

```
Start = contents(Table)
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

## Output

New columns are not named by the grammar: each component names the columns it creates
(Neo compares tables ignoring column names). So a program's output is not its final
table but that table's `contents` (the `Start` rule), a canonical form without column
names or order: the rows, each the sorted list of its cells, sorted. Numbers, and strings
that look like numbers (as in Neo's check), are rounded to 5 decimals, so `"2007"` and
`2007` are the same cell. The expected outputs are stored as `contents` too.

**Compare outputs with `==`** (HerbSearch's `evaluate` does), and equal outputs hash
equally (caching, observational equivalence). Intermediate values (`Table`) are still
`DataFrame`s.

This is slightly stricter than Neo's own check, `hasSameContents`, kept here as
`same_table`: Neo takes each row as a *set* of strings and accepts two tables if every row
of each is covered by a row of the other, with numbers within 1e-5. So in Neo repeated
cells in a row and repeated rows do not count; with `contents` they do. Neo's check is
not an equivalence (the tolerance and the covering), so no canonical form can match it
exactly. All 50 solutions pass both.

## Semantics

Everything follows Neo, except where noted:

- **Output check.** `contents` and `==` instead of Neo's `hasSameContents` (see Output).
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
`generate.py` prefers a program whose table also matches strictly (the same rows as a
multiset, once the columns are matched in some order; `contents` ignores which column a
cell is in), and all 50 do. Neo's own check is looser still: it accepted a spurious
cross join for problem 029.

Solution sizes (nodes, including the `Start` rule):
8: 1; 9: 3; 10: 2; 11: 10; 12: 4; 13: 9; 14: 12; 15: 3; 16: 5; 17: 1; mean 12.80.
Grammars have 73–120 rules (4–51 constants). Problem 042 has two input tables.
