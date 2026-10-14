# Custom interpreter performance benchmark

Evaluating candidate programs is the dominant cost of program synthesis with
Herb. Each benchmark in this package therefore ships a *custom interpreter*,
generated from its grammar by `HerbInterpret.make_interpreter` (expression
benchmarks) or `HerbInterpret.make_stateful_interpreter` (stateful benchmarks),
instead of going through `rulenode2expr` and then interpreting the resulting
Julia expression.

This directory measures what those interpreters cost, so that changes to them
can be judged against numbers rather than impressions.

## Running it

```bash
julia --project=benchmark benchmark/run.jl                       # defaults: depths 5-15
julia --project=benchmark benchmark/run.jl --targets=Robots_2020 --depths=5:10
julia --project=benchmark benchmark/run.jl --baselines           # also time the eval and interpret comparison baselines
julia --project=benchmark benchmark/compare.jl before.json after.json
```

`setup.jl` runs first and `develop`s this package and the sibling
`../HerbInterpret.jl` checkout, so edits to either are picked up without
reinstalling anything, and a fresh clone never silently measures the registered
releases instead. If `HerbInterpret.jl` is not checked out next to this
repository it warns and falls back to the registered release.

`run.jl` prints a markdown report and writes both it and a JSON record to
`benchmark/results/`. `compare.jl` diffs two such records, which is the intended
workflow for interpreter changes: record a run before, record one after, compare.

```bash
julia --project=benchmark benchmark/selftest.jl
```

checks the harness itself: that sampled programs have exactly the requested
depth, that the loop-nesting cap holds, that every target's interpreter runs,
that the custom interpreter and the baselines (including "custom v1") agree on
every program both can evaluate. Run it after changing an interpreter or the
sampler.

Options: `--depths`, `--programs`, `--examples`, `--reps`, `--seed`,
`--side-slack`, `--max-nodes`, `--nesting-limit`, `--error-policy`, `--targets`,
`--baselines`, `--baseline-programs`, `--label`, `--out`, `--no-save`.

## What is measured

Per benchmark and per depth in 5-15:

| column | meaning |
|---|---|
| `progs` | programs timed in this cell |
| `nodes` | mean `RuleNode` count per program |
| `median us` / `mean us` / `p95 us` | wall time to evaluate one program on all its examples |
| `progs/s` | program evaluations per second |
| `evals/s` | program-example pairs per second |
| `ns/node` | time per `RuleNode` per example — the size-normalised cost, and the number to compare across depths and benchmarks |
| `KiB/prog` | bytes allocated per program evaluation |
| `GC%` | share of measured time spent in GC |
| `rep±` | spread between repetitions; above ~10%, treat the cell as noisy |
| `err%` | share of *sampled* programs that raised an exception |
| `loop%` | share of timed programs containing a `WHILE` |
| `v1 us` | "custom v1" — the same programs run through the pre-optimization interpreter (`v1/HerbInterpretV1.jl`), a frozen copy of `make_interpreter`/`make_stateful_interpreter` as they stood before the optimization pass below |
| `v1 speed-up` | `v1 us / median us` — how much faster the current custom interpreter is than v1, on the same programs |

Plus, per benchmark, the *cold* cost of an interpreter: generating one for a
grammar the process has not seen yet and running its first program through it.
That cost is paid once per problem for DeepCoder, PBE_BV and PBE_SLIA, which
carry one grammar per problem (753 of them for PBE_BV), and once per session for
the stateful benchmarks, which share a single interpreter.

## Methodology

**Programs are sampled at an exact depth.** A `max_depth`-bounded sampler would
return overwhelmingly shallow programs, which is the opposite of what we want to
measure. `program_sampler.jl` instead precomputes, by dynamic programming, which
depths each nonterminal can reach, and then builds a tree of exactly the
requested depth: one child of every internal node is grown to `depth - 1`, the
others to a shallow depth set by `--side-slack`. Without that spine construction
the node count explodes doubly exponentially in the depth and the programs stop
resembling anything a search would enumerate.

The same seed always produces the same programs, so two runs compare like for
like.

**Loop nesting is capped.** The generated stateful interpreters bound `WHILE` at
1000 iterations. A `WHILE` nested inside another `WHILE` therefore costs up to
`10^6` steps, and a depth-15 program with four of them `10^12` — one program
would dominate the whole suite. `--nesting-limit` (default 1) restricts how many
loop rules may occur on a root-to-leaf path. Sequential, non-nested loops are
unaffected.

**Failing programs are excluded by default, and counted.** Random programs
routinely raise `BoundsError`, `OverflowError`, `DomainError`, ...; on PBE_SLIA
at depth 15 roughly 80% of them do. Throwing and unwinding costs far more than
interpreting, so by default (`--error-policy=filter`) only programs that
evaluate cleanly are timed, and the discard rate is reported as `err%`. Use
`--error-policy=allow` for the view a real search sees, exceptions included.

Note what high `err%` implies for the cells above it: the survivors at depth 15
are a biased sample, and on PBE_SLIA they are biased towards programs whose
`ite` short-circuits past most of their nodes, which is why `ns/node` *falls*
with depth there.

**Validation, warm-up and timing are separate.** Every candidate is evaluated
once outside the measured region. That run filters failures, discards programs
slower than `max_program_seconds`, and forces the specialisations of the
runtime-generated interpreter, so no compilation lands inside a measurement.

**Mutable state is rebuilt outside the timer.** `Pixels_2020`'s primitives mutate
their `PixelState` in place. Each repetition gets freshly deep-copied inputs,
prepared before the timer starts, so no program ever sees a state another program
has already modified and the copying is not charged to the interpreter.

**Each program is timed individually** with `time_ns`, which costs ~20ns against
per-program times in the microsecond range and yields a distribution rather than
a single aggregate. Repetitions reuse the same programs, so `rep±` measures
machine noise, not sampling noise; change `--seed` to see sampling noise.

**The expression benchmarks' examples are pre-converted once per target, not per
program.** `HerbInterpret.prepare_input` turns the `IOExample`s the custom
interpreter reads into its internal `NamedTuple` form once; `BenchTarget.prepared_inputs`
holds the result, and the harness's `prepare_inputs` hands it to the custom
interpreter for every sampled program in a depth cell (the stateful benchmarks
have no such conversion to begin with, so `prepared_inputs` is `nothing` for
them and `prepare_inputs` just passes `inputs` through unchanged). This is also
exactly the realistic access pattern this benchmark represents: a search
evaluating many candidate programs against the same fixed examples, which should
never redo that conversion per candidate -- so the main sweep measures the
interpreter at its best available calling convention. The `interpret_baseline`/
`eval_baseline` comparison functions still receive raw, unconverted `IOExample`s
(`prepare_raw_inputs`), since they have no equivalent fast path.

## Interpreting median vs. mean on the stateful benchmarks

From depth 7 on, `Robots_2020`, `Pixels_2020` and `String_transformations_2020`
show a median around 1-2µs and a mean in the hundreds of µs. The cause is not
noise: most sampled `WHILE`s have a condition that is already false on entry and
exit immediately, while a few run the full 1000-iteration bound. The
"loop-free vs. loop" table under each benchmark quantifies it — typically the
loop-containing programs are a majority of the programs and over 99% of the time.

Both numbers are legitimate. The median is the cost of interpreter dispatch; the
mean (and hence `progs/s`) is the cost a search actually pays. A change to
dispatch speed moves both, since a loop body is itself run through the
interpreter.

## Findings, and the optimization that followed

`results/before-optimization.{json,md}` / `results/before-optimization-errors-included.{json,md}`
record the interpreters as they were before any of this; `results/after-optimization.*`
record the result (Apple M5, julia 1.12.6). Summary first, diagnosis and fixes below.

| benchmark | before (progs/s @ d5 / d15) | after | speed-up @ d5 / d15 |
|---|---|---|---|
| DeepCoder_2016 | 164650 / 41090 | 696872 / 215781 | 4.2x / 5.3x |
| PBE_BV_Track_2018 | 268374 / 68808 | 1294080 / 444487 | 4.8x / 6.5x |
| PBE_SLIA_Track_2019 | 186696 / 114406 | 785464 / 505314 | 4.2x / 4.4x |
| Robots_2020 | 244083 / 409 | 2181421 / 6186 | 8.9x / 15.1x |
| Pixels_2020 | 227465 / 422 | 2024496 / 9101 | 8.9x / 21.5x |
| String_transformations_2020 | 203100 / 637 | 1147710 / 5931 | 5.7x / 9.3x |

All six also now **beat** the `HerbInterpret.interpret` comparison baseline at
every depth (previously they lost to it almost everywhere) — e.g. PBE_BV runs
5.0x faster than `interpret` at depth 5, up from parity (1.0x) before.

(These numbers moved slightly from the previous recording of this table, from
re-running `run.jl` to add the "custom v1" column below — same code both times,
run-to-run noise only; `rep±` in `results/after-optimization.md` stays under
the ~10%-is-noisy threshold almost everywhere.)

### Diagnosis

`@code_warntype` on the generated interpreter (reached through
`RuntimeGeneratedFunctions.generated_callfunc`, since the callable wrapper
itself doesn't show the real body) showed `Body::ANY` everywhere, on every
benchmark including the stateful ones that carry no `Dict` at all. Two
independent causes, confirmed with minimal reproductions outside the real
grammars before touching `HerbInterpret.jl`:

1. `HerbCore.get_children` returns `Vector{AbstractRuleNode}` (so `Hole`s can
   share a tree with `RuleNode`s during search), and the recursive call used
   that element untyped: `self(self, c[i], input)`. An abstract argument type
   on a self-recursive call is enough, by itself, to make the whole function's
   inferred return type -- and so every recursive call's -- widen to `Any`.
2. `input::Dict{Symbol,Any}`, read via `input[:_arg_1]` inside the recursive
   function: every such read is `Any`, and that poisons the same return-type
   inference the same way.
3. A third, structural cause specific to this design: one function serving
   *every* nonterminal can only be inferred as narrowly as the union of all
   their return types put together (`Union{Int, Vector{Int}, Bool, String, ...}`
   for a grammar like DeepCoder's or PBE_SLIA's), which Julia gives up on past a
   handful of members and widens to `Any` -- *even once (1) and (2) are fixed*.

### Fixes, in the order they were applied and measured

1. **Assert `c[i]::RuleNode`** at every recursive call site, in both
   `build_match_cases` and `build_match_cases_stateful`. This is a real,
   documented constraint now (`make_interpreter`/`make_stateful_interpreter`'s
   docstrings): a `Hole` reaching the interpreter raises a `TypeError` rather
   than being misinterpreted, since evaluating an incomplete choice has no
   defined meaning anyway and nothing in the Herb ecosystem passes one to these
   functions today.
2. **Convert the input `Dict` to a concretely-typed `NamedTuple` once per call**,
   outside the recursion, with field access (`input.x`) replacing `Dict`
   lookups inside it. The field names are discovered once, from the grammar,
   by `build_match_cases` itself, and carried as a type parameter on
   `GeneratedInterpreter` so the conversion (`_as_namedtuple`) can use them
   directly instead of reading them off the dict via `keys`/`values` (measured
   ~60ns/2 allocations against ~300ns/10 for a 2-entry dict).
3. **Generate one function per nonterminal instead of one for the whole
   grammar**, each handling only its own nonterminal's rules and so inferred no
   wider than what those rules actually produce -- typically a single concrete
   type, since a well-formed grammar is "sorted" this way already. The
   functions are mutually recursive through a shared `selves::NamedTuple` (the
   generalisation of the old single-function's `self` self-reference), and a
   `prog`'s own nonterminal is looked up once per top-level call, not per node,
   to pick which member of `selves` to start at.

   This step also surfaced a real, independent bug while fixing (3): DeepCoder's
   `drop` (`list_functions.jl`) returned a bare `[]` (`Vector{Any}`) when it
   dropped everything, instead of the `Vector{Int}` every other branch and every
   other list primitive produces. That one `Any`-typed return widened `ExprArr`'s
   whole inferred type, which then widened everything that calls into it
   (`maximum`, `minimum`, ...). Fixed by simplifying to `xs[n+1:end]`, which is
   already correctly typed and empty in that case -- no behaviour change, since
   that was already what the non-empty branch returned.
4. **`HerbInterpret.prepare_input`**: a program-synthesis search evaluates many
   candidate programs against the *same fixed examples* every time, which means
   step (2)'s `Dict` -> `NamedTuple` conversion was being redone, unchanged, on
   every single candidate. `prepare_input(interp, examples)` does it once;
   `GeneratedInterpreter` gained matching overloads for already-`NamedTuple`
   inputs (single and vector) that skip the conversion entirely. This benchmark
   itself is exactly that access pattern (many sampled programs, one fixed
   example set per depth cell), so the three expression-benchmark targets now
   build their `prepared_inputs` once; the comparison baselines still receive
   raw `IOExample`s, since they have no equivalent fast path.
5. **Fuse the top-level nonterminal lookup with the call it leads to.** After
   (1)-(4), `@allocated` on a single top-level `interp(prog, input)` call still
   showed 128-272 bytes (scaling with the grammar's nonterminal count, zero
   only for the single-nonterminal benchmarks), despite every *node* being
   allocation-free. The cause: picking which of `selves`'s members handles
   `prog` is a `Symbol`-keyed lookup on a `NamedTuple` whose members are
   distinct concrete callable types; `getfield(selves, nt::Symbol)` with a
   runtime `nt` does not union-split that result (even though every possible
   field name and type is known statically), so the selected function gets
   boxed -- and, measured directly, *calling* a selected-but-still-union-typed
   function allocates the same whether it was just selected or is an
   already-selected local reused across several calls, which rules out the
   obvious fix of hoisting the selection out of a per-example loop. What does
   work: never let "some nonterminal's function" exist as a value at all --
   `_dispatch` is one `@generated` function whose every branch both selects
   *and calls* its own nonterminal's function directly
   (`selves.Start(selves, prog, input)`, `selves.Sequence(...)`, ...), so every
   actual function call in the generated code is to one statically-known
   concrete callable. Measured 1.8-3x fewer bytes per top-level call than
   selecting once and reusing across 5 example calls, the pattern every call
   operator now uses (`_dispatch`'s docstring in `HerbInterpret.jl` has the
   full chain of measurements).

Each step was checked against `@code_warntype` (until `Body::<concrete type>`
in place of `Body::ANY`), then `HerbInterpret.jl`'s own test suite, then
`benchmark/selftest.jl` (which cross-checks the custom interpreter's output
against both the `eval` and `interpret` baselines on hundreds of sampled
programs per benchmark), then `HerbBenchmarks.jl`'s own test suite, before
moving to the next. Step (1) broke three hand-written test fixtures
(`test/{robots,pixels,string_transformations}_2020_test.jl`) that built
`RuleNode`s skipping the grammar's own alias chain (`Sequence = Operation =
Transformation`) -- a shortcut the old flat, type-oblivious dispatch happened to
tolerate, but not a well-typed tree by the grammar's own rules, and not
something any real search would ever produce (`HerbGrammar`'s own sampling only
ever picks rules of the requested type). Those fixtures were fixed to build
well-typed trees instead of being made to pass some other way.

### One thing that was tried and made things worse

Replacing each nonterminal's flat dispatch cascade (`r == i1 && return e1; r ==
i2 && return e2; ...`) with a balanced binary search (`O(log n)` comparisons
instead of up to `O(n)`) was a reasonable-looking next step given some
nonterminals have 20+ rules (DeepCoder's `ExprArr`). Measured, it was a
regression across every benchmark at every depth -- the flat cascade's cheap,
uniform, well-predicted compares were already about as fast as this rule count
allows, and the tree's extra per-level comparison and worse control flow never
paid back what it saved. Reverted; see `build_dispatch`'s docstring in
`HerbInterpret.jl` for the specifics, so this doesn't get re-tried blind.

### A note on measuring sub-microsecond changes

Fix (5) above (`_dispatch`) is a few hundred bytes per call on programs that,
by then, already ran in under a microsecond -- small enough that this
benchmark's own wall-clock numbers became unreliable evidence for it: one
`run.jl` pass showed a clear *regression* on the expression benchmarks, with
`rep±` as high as 377%, far past the ~10% this README already says to distrust.
Re-running did not resolve it (still up to 243% on a quieter machine moment).
The fix was confirmed instead with `@allocated` (machine-noise-immune, and the
basis for the docstring's numbers) and with a same-process `BenchmarkTools`
comparison -- the old and new dispatch built side by side and run on the
identical sampled programs in one process, minimum-of-many-samples reported,
which is what finally showed fix (5) winning or tying on every benchmark
tested, matching the allocation evidence. The lesson for next time: once a
change's expected effect is on the order of a few dozen nanoseconds per call,
`run.jl`'s per-depth wall-clock numbers are the wrong tool to confirm it with;
`@allocated` and an in-process `BenchmarkTools` comparison are.

### What's left

**The stateful benchmarks' loop bound, not dispatch, is now their dominant
cost**, more so than before since dispatch itself got much cheaper: from depth 7
on, programs containing a `WHILE` are a minority of the sample but still over
98% of the measured time (see each benchmark's loop-free/loop split table). The
1000-iteration bound in `build_match_cases_stateful` is doing that; it is a
deliberate safety bound, not a dispatch inefficiency, so not something this pass
touched.

**Exceptions still cost real throughput on two benchmarks.** Comparing
`results/after-optimization.md` with `results/after-optimization-errors-included.md`
(`--error-policy=allow`): PBE_SLIA and, to a lesser extent now that `drop` is
fixed, DeepCoder still lose a meaningful fraction of throughput to programs that
raise (`OverflowError`, `DomainError`, `BoundsError`, ...) when those are
included rather than filtered out of the measurement. Nothing in this pass
changed those remaining error sources; see `err%` in each benchmark's table.

**Per-node dispatch cost looks to be near its floor.** PBE_BV_Track_2018 and
Robots_2020 -- the two benchmarks whose primitives allocate nothing at all
(bitwise ops on `UInt64`; immutable structs of `Int`s) -- both land at ~16-20
`ns/node` regardless of depth, with `KiB/prog` near zero (0.12 / ~0.6). The
other benchmarks' higher `ns/node` tracks their primitives' own allocation
(new arrays for DeepCoder's filter/map/sort/zipwith, new strings for
String_transformations' slicing/concatenation, both inherent to what those
programs actually compute), not interpreter overhead -- changing that would
mean rewriting the benchmarks' domain primitives, a different task from
optimizing the interpreter that evaluates them.

## "custom v1": benchmarking the pre-optimization interpreter

Every target above also reports "custom v1": the exact same grammar and
programs run through `v1/HerbInterpretV1.jl`, a frozen copy of
`make_interpreter`/`make_stateful_interpreter` as they stood before the
optimization pass this README documents (commit `b5a6c5c`, the tip of
`HerbInterpret.jl`'s `master` when that branch started). It is not a dependency
of anything else and can be deleted along with the `v1 us`/`v1 speed-up`
columns once the comparison is no longer wanted; `benchmark/selftest.jl` checks
that it agrees with the current custom interpreter on every sampled program
(it has no unsupported case, unlike the `interpret`/`eval` baselines).

It appears twice in the per-depth report: as `v1 us`/`v1 speed-up` in the main
table (over the full `n_programs` sample, same subset as `median us`), and as
its own `v1 us`/`v1 speed-up` columns in the `--baselines` three-/four-way
comparison table alongside `eval`/`interpret` (over the smaller `cmp_n_programs`
subset those use, for a like-for-like comparison with them).

**Gotcha: `RuntimeGeneratedFunctions` breaks two modules deep.** `HerbInterpretV1`
is included from `InterpreterBenchmarks.jl`, but *not* from inside
`module InterpreterBenchmarks` — it is included one level above, so that it
lands as `Main.HerbInterpretV1` (a sibling of `Main.InterpreterBenchmarks`)
rather than `Main.InterpreterBenchmarks.HerbInterpretV1`. Nested the second way,
every call into it raised `UndefVarError: #_RuntimeGeneratedFunctions_cache not
defined`, even though `RuntimeGeneratedFunctions.init(@__MODULE__)` runs at the
top of `make_interpret_v1.jl` and the same pattern works one level shallower.
The real `HerbInterpret.jl` never hits this because it is loaded as a genuine
package (`using HerbInterpret`), with its own precompilation, not as a plain
`module` block nested inside another module via `include`.

Speed-up over v1 at depth 5 / depth 15, from `results/after-optimization.md`:

| benchmark | v1 speed-up @ d5 / d15 |
|---|---|
| DeepCoder_2016 | 4.1x / 5.3x |
| PBE_BV_Track_2018 | 5.0x / 6.6x |
| PBE_SLIA_Track_2019 | 3.6x / 3.4x |
| Robots_2020 | 8.5x / 5.9x |
| Pixels_2020 | 6.6x / 5.8x |
| String_transformations_2020 | 4.5x / 4.0x |

These track the "after vs. before" numbers in the summary table above (same
code on both sides of the comparison), with one difference worth noting:
`v1 speed-up` compares same-subset, per-program medians directly (`v1 us /
median us` on the exact same sampled programs), while the summary table above
compares `progs/s` across two separate `run.jl` invocations (`before-` and
`after-optimization.json`), which also differ in error policy's effect on which
programs survive sampling. Both describe the same underlying change.

## Not covered

`Abstract_Reasoning_2019` has no custom interpreter to measure. Its grammar's
start rule is `Start = (state = Grid; returnState(state))`, an assignment inside
a block, which `HerbInterpret.build_match_cases` does not handle, so the module
never calls `make_interpreter`.

For the expression benchmarks a single problem's grammar is used per benchmark
(`grammar_000`, `grammar_PRE_100_10`, `grammar_11440431`), chosen so that depth
sweeps are comparable across runs; the grammars within one of these benchmarks
differ mainly in which operators and input arguments they include.
