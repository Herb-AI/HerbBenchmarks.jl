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
| `v2 us` | "custom v2 (batched)" — the same programs run through a from-scratch interpreter design (`v2/HerbInterpretBatched.jl`) that evaluates all examples in one tree-walk instead of one per example |
| `v2 speed-up` | `v2 us / median us` — how much faster the current custom interpreter is than v2 (below 1x where v2 is actually faster — see the "custom v2 (batched)" section) |

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
| DeepCoder_2016 | 164650 / 41090 | 554477 / 204479 | 3.4x / 5.0x |
| PBE_BV_Track_2018 | 268374 / 68808 | 1309158 / 399659 | 4.9x / 5.8x |
| PBE_SLIA_Track_2019 | 186696 / 114406 | 759465 / 482234 | 4.1x / 4.2x |
| Robots_2020 | 244083 / 409 | 2039914 / 6120 | 8.4x / 15.0x |
| Pixels_2020 | 227465 / 422 | 1956881 / 9416 | 8.6x / 22.3x |
| String_transformations_2020 | 203100 / 637 | 1150064 / 5899 | 5.7x / 9.3x |

All six also now **beat** the `HerbInterpret.interpret` comparison baseline at
every depth (previously they lost to it almost everywhere) — e.g. PBE_BV runs
5.5x faster than `interpret` at depth 5, up from parity (1.0x) before.

(These numbers moved more than usual from the previous recording of this
table, from re-running `run.jl` to add the "custom v2 (batched)" fixes below —
same `interpret`/`v1_interpret` code both times, so this is run-to-run noise,
not a regression; DeepCoder_2016's `rep±` was 25.4% on this run, well past the
~10%-is-noisy threshold this README already names, confirming it.)

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
| DeepCoder_2016 | 3.5x / 5.1x |
| PBE_BV_Track_2018 | 5.2x / 5.9x |
| PBE_SLIA_Track_2019 | 3.5x / 3.3x |
| Robots_2020 | 7.7x / 5.4x |
| Pixels_2020 | 6.0x / 5.9x |
| String_transformations_2020 | 4.4x / 3.8x |

These track the "after vs. before" numbers in the summary table above (same
code on both sides of the comparison), with one difference worth noting:
`v1 speed-up` compares same-subset, per-program medians directly (`v1 us /
median us` on the exact same sampled programs), while the summary table above
compares `progs/s` across two separate `run.jl` invocations (`before-` and
`after-optimization.json`), which also differ in error policy's effect on which
programs survive sampling. Both describe the same underlying change.

## "custom v2 (batched)": a from-scratch interpreter design

Every target above also reports "custom v2 (batched)": a different interpreter
architecture entirely (`v2/HerbInterpretBatched.jl`), not a further tweak of
`HerbInterpret.jl`'s design. The idea: every program here is evaluated against
several examples at once (`n_examples`, 5 by default), and the existing
interpreter re-walks the whole tree once per example -- paying the
branch-dispatch decision at each node (which of a nonterminal's rules this node
uses) `n_examples` times instead of once. A batched interpreter walks the tree
once, threading an `NTuple{n_examples}` through the recursion instead of a
single value, so dispatch is paid once per node and only the actual primitive
work scales with the example count.

### Two dead ends, ruled out before writing any of this

**Compile each program to a tree of closures, once, then call it once per
example.** The obvious way to "pay dispatch once": build a closure per node
(capturing its already-built children), then invoke the top closure
`n_examples` times. Measured directly (not in this codebase, a standalone
prototype), this was *slower*, not faster: constructing a closure per node
allocates, and -- the important part -- invoking a closure whose concrete type
varies per program (as it must, since every distinct tree shape produces a
distinct nested closure type) either costs a real per-call dispatch/allocation
of its own (plain `Function`-typed storage) or, with `FunctionWrappers.jl`'s
type-erased calling convention specifically built to avoid that, costs *more*
per call than the dispatch it replaces (~440ns/node against the existing
interpreter's ~15-20ns/node floor), because the call can never be inlined once
the wrapper erases the closure's real type. A seemingly-promising
`BenchmarkTools`-measured "8ns" result for this approach turned out to be an
artifact of benchmark-macro interpolation baking one specific program's exact
closure type into the benchmark function as a compile-time constant -- which
is only possible by letting Julia JIT-compile a bespoke specialization for
*that one program*, the same per-distinct-program compilation cost `eval`
already pays and loses badly to (300-1000x slower than `interpret`, see above).
Forcing a genuinely generic call (the same code path handling many distinct
programs, as any real use requires) made the allocation and slowdown show up
directly: 73MB and ~24ns/call across 50 distinct programs, called through a
`Base.Any`-typed boundary.

**Batch with `ntuple(k -> ..., N)` instead of writing out `N` literal copies.**
The natural-looking way to combine `N` per-position values. Measured directly,
this was *55x slower* and allocated per node (267KB / 9598 allocations for 50
trees that take 0 bytes in the scalar version) -- `ntuple`'s compile-time
unrolling optimization needs the surrounding call to be fully inlined and
monomorphic to kick in, which it is not here: nonterminal functions are
runtime-branching, generically handling any tree shape via `prog`'s rule index,
exactly like `HerbInterpret.jl`'s. The `k -> ...` closure gets boxed instead.
Writing out `N` literal copies of the combining expression (`N` is fixed per
interpreter, known at code-generation time) avoids this entirely: no closure
ever exists in the generated code, so there is nothing to box.

### The short-circuit problem, and the fallback

Hoisting a rule's children once and reusing them across all `N` positions is
only safe for rules that always evaluate every child -- which plain function
calls always do (Julia evaluates every argument before a call, no matter what
the function does with them; PBE_BV's `im_cvc(Start, Start, Start)`, a plain
3-argument function despite reading as "if", is exactly this case and batches
with no special handling at all). A genuine Julia `if`/ternary
(`Expr(:if, ...)`, e.g. PBE_SLIA's `ntBool ? ntString : ntString`) and the
stateful `IF`/`WHILE` forms do not: only the taken branch runs in the scalar
interpreter, and `WHILE` in particular runs a *different* number of iterations
per example (most sampled loops exit almost immediately, a minority run the
full 1000-iteration bound -- see above). Hoisting-and-reusing these would
evaluate every branch for every example regardless of which one each example
actually takes, which can raise an exception the scalar interpreter would
never have hit for that example, or force every example to iterate up to
whichever one happens to be slowest.

Rules containing one of these are not batched at all: they delegate to the
*scalar* interpreter (`BenchTarget.interpret` itself), once per example,
exactly reproducing today's short-circuit behaviour by reusing the code that
already implements it, rather than re-deriving it. `benchmark/selftest.jl`
checks "custom v2 (batched)" agrees with the current interpreter on every
sampled program across all six benchmarks, including through this fallback
path, with no unsupported case.

### Two more allocations found after the first measurement, both fixed

The first working version of this design still allocated noticeably more than
the scalar interpreter on every call, for two separate reasons -- worth
recording since both are instances of patterns already seen (and fixed) in
`HerbInterpret.jl` itself, not new ones:

1. **Converting raw examples/states to the batched representation used
   `ntuple(k -> ..., N)`, the same closure-allocates-when-not-fully-inlined
   trap documented above**, just one level up (once per top-level call,
   building `batched_input`/`batched_state` itself, rather than once per
   node). Measured, this cost a fixed ~100-800 bytes on *every* call
   regardless of program size -- for a shallow, cheap program (a few thousand
   bytes total), a large fraction of the whole cost. Fixed the same way:
   `@generated` functions ([`_as_batched_namedtuple`](@ref),
   [`_as_batched_states`](@ref)) that write out `N` (and, for the
   struct-of-arrays case, `N * length(names)`) literal element accesses
   instead of calling `ntuple` with a closure.
2. **The fused-dispatch `@generated` function
   ([`_dispatch_batched`](@ref)) was parameterized on only part of its own
   struct's type** (`GeneratedBatchedInterpreter{Selves}` /
   `GeneratedBatchedStatefulInterpreter{Selves}`, leaving `Fallback`/`Names`/`N`
   unconstrained) -- valid Julia, and exactly what `HerbInterpret._dispatch`
   can get away with, since *its* struct has only one type parameter to begin
   with. For this module's structs, which have more, leaving the rest
   unconstrained was enough to make the whole dispatch infer as `Any` instead
   of the small, union-split-friendly `Union{NTuple{N,T1}, NTuple{N,T2}}` it
   should be -- confirmed with `@code_warntype`, where every individual
   branch's own call already inferred perfectly concretely, but the
   surrounding `@generated` function's own `Body` showed `ANY`. Naming every
   type parameter in `where` fixed it immediately.
3. **(Stateful grammars only.)** Even after (2), a `ControlStatement` rule's
   delegated call (`fallback(prog, state)`) still infers as
   `Union{Bool, StateT}` on its own -- `fallback`'s call signature handles
   *any* nonterminal generically, so without more information Julia can't
   know that *this* call, to a node that is always a `ControlStatement`,
   always returns `StateT` specifically (never the `Bool` a `Condition` node
   would). Asserting `::state_type` on the delegated call fixed this --
   exactly the same kind of fix as `HerbCore.get_children`'s `::RuleNode`
   assertion on child nodes (see `_child`'s docstring), just one layer
   further out. `state_type` has no way to be recovered from the grammar or
   from `fallback` (neither carries it as a type parameter), so
   `make_batched_stateful_interpreter` takes it as an explicit keyword,
   supplied by the one caller that already has a concrete state value in
   hand (`targets.jl`, as `eltype(states)`).

   The equivalent fix for the *expression* grammars' delegated (ternary)
   calls -- asserting the result to that nonterminal's own concrete type --
   was attempted via reflection (`Base.return_types` on the fallback's own
   per-nonterminal function) rather than a caller-supplied type, since
   expression grammars can have several nonterminals with genuinely
   different types (no single `state_type` to ask for). It did not work:
   PBE_SLIA's `IOExample`s are `Any`-typed internally (`IOExample{Any,
   String}`), so the fallback's own per-nonterminal functions are
   legitimately uninferrable from argument types alone -- not a narrowing
   failure to fix, but a real consequence of the underlying data's own
   typing. This is why PBE_SLIA alone, among the three expression
   benchmarks, still does not benefit from batching (see below).

### Results: a modest win on five benchmarks, a modest loss on one

| benchmark | v2 speed-up range across d5-d15 (`results/after-optimization.md`) |
|---|---|
| DeepCoder_2016 | 0.85x-1.02x (roughly parity; noisy, `rep±` up to 25% at some depths) |
| PBE_BV_Track_2018 | 0.71x-0.88x (1.1x-1.4x faster, consistent across every depth) |
| PBE_SLIA_Track_2019 | 1.00x-1.12x (**slower**, low noise -- `rep±` under 10% almost everywhere, so this is real) |
| Robots_2020 | 0.59x-0.91x (1.1x-1.7x faster, best at shallow/loop-free depths) |
| Pixels_2020 | 0.73x-0.97x (1.03x-1.4x faster) |
| String_transformations_2020 | 0.62x-0.90x (1.1x-1.6x faster) |

These are `v2 speed-up` straight from the main per-depth tables (`v2 us /
median us`; below 1 means v2 is faster), i.e. `run.jl`'s own sweep over 500
different sampled programs per depth, not a separate measurement -- see
`results/after-optimization.md` for the full per-depth breakdown and `rep±`
column.

**An earlier version of this section reported much larger wins -- up to
3.7x on Robots -- and that was wrong.** Those numbers came from a separate,
ad hoc same-process `BenchmarkTools` script that benchmarked *the same single
program*, repeated many times, and took the minimum across repetitions. That
is not a measurement error in the `@benchmark` sense (the numbers it reported
were real), it is the wrong *workload*: repeatedly calling the interpreter on
one unchanging program lets the branch predictor and caches warm up to that
one program's specific control flow, a condition a real search never has,
since it evaluates a stream of structurally *different* candidate programs.
Reproducing the script with the harness's actual protocol (`collect_programs`
+ `timed_pass!`, 500 different programs, no single one repeated) reproduced
`after-optimization.md`'s numbers almost exactly and *not* the original
script's, confirming the original script's workload, not its precision, was
the problem. The lesson this adds to "A note on measuring sub-microsecond
changes" above: a same-process `BenchmarkTools` comparison is the right tool
when `run.jl`'s own numbers are too *noisy* to trust (that note's own case),
but it must still exercise the real workload (many different programs) --
benchmarking one fixed program repeatedly, however precisely, answers a
different question and can be badly misleading, in either direction.

The corrected pattern is still consistent with the design's actual mechanism,
just smaller than first reported: batching only removes *dispatch* cost, not
the cost of the primitive work itself, so it helps in proportion to how much
of a node's cost was dispatch to begin with. The stateful benchmarks'
primitives are cheap (immutable-struct field reads/writes, no allocation --
see "Per-node dispatch cost looks to be near its floor" above) and show the
clearest, most consistent wins, shrinking as `WHILE` loops (handled by the
unbatched fallback) come to dominate depth-for-depth. PBE_BV's primitives are
equally cheap (bitwise ops on `UInt64`, no allocation, no conditionals to
delegate at all) and show the same pattern, consistently, at every depth.
DeepCoder does real allocating work per primitive (array operations:
filter/map/sort/zipwith) that dispatch amortization does not touch, landing
at close to parity. PBE_SLIA pays its ternary rules' fallback overhead
(reconstructing a per-example `NamedTuple` from the struct-of-arrays one, see
above) without the type-assertion fix that made the stateful delegate path
free, and is the one benchmark where that overhead is not won back --
genuinely, consistently slower, not a measurement artifact.

**Conclusion:** batching is a real but modest win on five of the six
benchmarks and a modest loss on the sixth (PBE_SLIA) -- worth having as a
comparison point, not a clearly-better replacement for
`HerbInterpret.jl`'s current design, which is why it is reported as its own
column here (`v2/HerbInterpretBatched.jl`) rather than proposed as one.

## Not covered

`Abstract_Reasoning_2019` has no custom interpreter to measure. Its grammar's
start rule is `Start = (state = Grid; returnState(state))`, an assignment inside
a block, which `HerbInterpret.build_match_cases` does not handle, so the module
never calls `make_interpreter`.

For the expression benchmarks a single problem's grammar is used per benchmark
(`grammar_000`, `grammar_PRE_100_10`, `grammar_11440431`), chosen so that depth
sweeps are comparable across runs; the grammars within one of these benchmarks
differ mainly in which operators and input arguments they include.
