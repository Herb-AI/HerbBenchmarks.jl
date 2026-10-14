# One `BenchTarget` per benchmark whose custom interpreter we want to measure.
#
# The benchmarks come in two flavours:
#
# * *expression* benchmarks (DeepCoder, PBE_BV, PBE_SLIA) carry one grammar per
#   problem and are evaluated with `make_interpreter`, on `IOExample`s;
# * *stateful* benchmarks (Robots, Pixels, String transformations) share a single
#   grammar per benchmark and are evaluated with `make_stateful_interpreter`, on
#   a state object.
#
# `Abstract_Reasoning_2019` is deliberately absent: its grammar uses an
# assignment/`begin ... end` rule (`Start = (state = Grid; returnState(state))`),
# which `HerbInterpret.build_match_cases` does not handle, so the benchmark has
# no generated interpreter to measure.

"""
    ColdProbe

How to build a *fresh* interpreter for problems the main measurement does not
use, so that the one-off cost of generating one can be reported.

The expression benchmarks carry one grammar per problem (753 of them for
PBE_BV_Track_2018), so every problem needs its own interpreter, and
`RuntimeGeneratedFunctions` only compiles the generated body on the first call.
Measuring that cold cost needs a grammar the process has not seen yet, which is
why the probe works off problem identifiers rather than off the target's own
grammar.

# Fields
- `ids`: identifiers of problems to probe, none of which is the target's own.
- `setup`: `id -> (grammar, inputs)`, run before the timer starts.
- `build`: `grammar -> interpreter`, the timed part together with the first call.
"""
struct ColdProbe
    ids::Vector{String}
    setup::Function
    build::Function
end

"""
    BenchTarget

Everything needed to measure one benchmark's custom interpreter, plus its two
"informational" comparison points.

# Fields
- `name`: benchmark name as it appears in the report.
- `mod`: the benchmark module (also the module primitives are resolved in).
- `grammar_id`: which problem's grammar is used, for the record.
- `grammar`, `start_symbol`: what programs are sampled from.
- `interpret`: the custom interpreter, called as `interpret(program, inputs)`.
- `v1_interpret`: the *same* grammar run through `HerbInterpretV1` (a frozen
  copy of the custom interpreter as it stood before the optimization pass this
  benchmark was built to drive, see `v1/HerbInterpretV1.jl`), reported as
  "custom v1". Always present (unlike the other comparison points, it has no
  not-yet-supported case): it's the same kind of interpreter as `interpret`,
  just built with older code, so it runs every program `interpret` does.
- `v2_interpret`: the *same* grammar/programs run through `HerbInterpretBatched`
  (a from-scratch interpreter design, see `v2/HerbInterpretBatched.jl`),
  reported as "custom v2 (batched)". Evaluates a program against all of its
  examples in one tree-walk instead of one per example, falling back to
  `interpret` itself (once per example) for any rule that short-circuits.
  Always present, for the same reason `v1_interpret` is. Built for exactly
  `n_examples` examples (baked into its generated code at build time, unlike
  every other interpreter here) -- call it only with bundles of that length.
- `cold`: how to measure the one-off cost of an interpreter for a fresh grammar,
  or `nothing` for the benchmarks that build a single interpreter at module load
  time and reuse it for every problem.
- `inputs`: the input bundle a program is evaluated on, one entry per example.
  It has to stay concretely typed (`Vector{IOExample}`, `Vector{RobotState}`,
  ...), because the generated interpreters dispatch on its element type. Also
  what the baselines are given, unconverted, since `prepared_inputs` (below) is
  specific to the custom interpreter's own calling convention.
- `prepared_inputs`: for the expression benchmarks, `inputs` already run through
  `HerbInterpret.prepare_input` -- what the custom interpreter is actually timed
  on. Evaluating many candidate programs against the same fixed examples (what a
  synthesis search does, and what this benchmark's sweep over many sampled
  programs does too) should convert those examples to the interpreter's internal
  form once and reuse it, not redo that conversion on every single program; this
  is that one-time conversion, computed when the target is built. `nothing` for
  the stateful benchmarks, which have no such conversion to begin with (the state
  itself is already concretely typed).
- `needs_copy`: whether the interpreter mutates its input and the bundle has to
  be rebuilt for every evaluation (only `Pixels_2020`).
- `loop_rules`: rules whose nesting the sampler restricts (see `DepthTable`).
- `interpret_baseline`: `rulenode2expr` (or, for stateful grammars,
  [`stateful_expr`](@ref)) + `HerbInterpret.interpret` — the generic,
  non-generated evaluator `HerbInterpret.jl` ships, called as
  `interpret_baseline(program, inputs)`.
- `interpret_unsupported`: predicate on a program telling whether
  `interpret_baseline` cannot even attempt it. Always `false` for the expression
  benchmarks; for the stateful ones, true exactly when the program contains a
  `WHILE`, since `HerbInterpret.interpret` has no `:while` case.
- `eval_baseline`: the same `Expr`, run through literal `Core.eval` in `mod`
  instead — real Julia semantics, including `while`, but paying full compiler
  latency on every call since each program is a structurally distinct,
  freshly-built `Expr`.
"""
struct BenchTarget
    name::String
    mod::Module
    grammar_id::String
    grammar::AbstractGrammar
    start_symbol::Symbol
    interpret::Any
    v1_interpret::Any
    v2_interpret::Any
    cold::Union{Nothing,ColdProbe}
    inputs::Any
    prepared_inputs::Any
    needs_copy::Bool
    loop_rules::Set{Int}
    interpret_baseline::Union{Nothing,Function}
    interpret_unsupported::Function
    eval_baseline::Union{Nothing,Function}
end

"""
    prepare_inputs(target, n) -> Vector

`n` input bundles, one per program to be evaluated, for the *custom
interpreter* specifically -- `prepared_inputs` when there is one (see
[`BenchTarget`](@ref)), `inputs` otherwise. When the interpreter does not
mutate its input the same bundle is shared by every program, which keeps the
preparation out of the measured region entirely. Otherwise a fresh deep copy is
made per program.
"""
function prepare_inputs(t::BenchTarget, n::Int)
    bundle = t.prepared_inputs === nothing ? t.inputs : t.prepared_inputs
    t.needs_copy || return [bundle for _ in 1:n]
    return [deepcopy(bundle) for _ in 1:n]
end

"""
    prepare_raw_inputs(target, n) -> Vector

Like [`prepare_inputs`](@ref), but always `inputs`, never `prepared_inputs` --
for the `interpret_baseline`/`eval_baseline` comparison functions, which take
`IOExample`s (or states) directly and have no equivalent of the custom
interpreter's pre-conversion.
"""
function prepare_raw_inputs(t::BenchTarget, n::Int)
    t.needs_copy || return [t.inputs for _ in 1:n]
    return [deepcopy(t.inputs) for _ in 1:n]
end

# ---------------------------------------------------------------------------
# Expression-benchmark baselines: `rulenode2expr` is already runnable as-is, no
# state-threading convention to reproduce.
# ---------------------------------------------------------------------------

"""
    expr_interpret_baseline(grammar, mod)

The generic evaluation path the custom interpreters replace: convert the
`RuleNode` to a Julia expression with `rulenode2expr`, then walk that expression
with `HerbInterpret.interpret` and a symbol table — a second tree traversal, of
the `Expr` this time, with a `Dict` lookup at every node, rather than compiled
Julia code.
"""
function expr_interpret_baseline(g::AbstractGrammar, mod::Module)
    table = grammar2symboltable(g, mod)
    return function (program, examples)
        expression = rulenode2expr(program, g)
        return [execute_on_input(table, expression, ex.in) for ex in examples]
    end
end

"""
    expr_eval_baseline(grammar, mod)

The same `rulenode2expr` output, run with literal `Core.eval` instead of the
generic interpreter: each example's inputs are bound with a `let`, and the whole
thing is evaluated as real Julia code in `mod`. Every call is a structurally
distinct `Expr` (a different sampled program), so this pays full parse-free but
lower+infer+codegen compiler latency every time — there is no method cache to
reuse across different programs the way there would be for actual Julia source
written once and called many times.
"""
function expr_eval_baseline(g::AbstractGrammar, mod::Module)
    return function (program, examples)
        expression = rulenode2expr(program, g)
        return map(examples) do ex
            bindings = [Expr(:(=), k, v) for (k, v) in pairs(ex.in)]
            Core.eval(mod, Expr(:let, Expr(:block, bindings...), expression))
        end
    end
end

"""
    take_examples(problem, n) -> Vector{<:IOExample}

The first `n` `IOExample`s of `problem`, cycling if the problem has fewer.
"""
function take_examples(problem, n::Int)
    spec = collect(problem.spec)
    return [spec[mod1(i, length(spec))] for i in 1:n]
end

"""
    collect_states(mod, key, n) -> Vector

Gather `n` input states for a stateful benchmark. These benchmarks store a single
example per problem, so the states are collected across consecutive problems. The
result is narrowed to the concrete state type the interpreter expects.
"""
function collect_states(mod::Module, key::Symbol, n::Int)
    states = Any[]
    for id in get_all_identifiers(mod)
        for ex in get_problem(mod, id).spec
            push!(states, ex.in[key])
            length(states) == n && break
        end
        length(states) == n && break
    end
    isempty(states) && error("no input states found for $mod")
    return identity.(Any[states[mod1(i, length(states))] for i in 1:n])
end

# ---------------------------------------------------------------------------
# Stateful-benchmark baselines: `rulenode2expr` alone is not runnable (it
# reproduces the grammar's zero-arg encoding, e.g. `moveRight()`, verbatim), so
# both baselines go through `stateful_expr` first (see stateful_expr.jl).
# ---------------------------------------------------------------------------

"""
    stateful_interpret_baseline(grammar, mod)

[`stateful_expr`](@ref) + `HerbInterpret.interpret`, via the same `Dict`-merge
convention `execute_on_input` already uses for `_arg_1`-style inputs — here the
dict carries `:state` instead. Programs containing a `WHILE` cannot be run this
way (`HerbInterpret.interpret` has no `:while` case); see
[`stateful_interpret_unsupported`](@ref).
"""
function stateful_interpret_baseline(g::AbstractGrammar, mod::Module)
    table = grammar2symboltable(g, mod)
    return function (program, states)
        body = stateful_expr(program, g)
        return [execute_on_input(table, body, Dict{Symbol,Any}(:state => s)) for s in states]
    end
end

"""
    stateful_interpret_unsupported(grammar)

Returns a predicate on programs: true when [`stateful_expr`](@ref) produces a
`WHILE`, which `HerbInterpret.interpret` cannot run.
"""
stateful_interpret_unsupported(g::AbstractGrammar) =
    program -> contains_while(stateful_expr(program, g))

"""
    stateful_eval_baseline(grammar, mod)

[`stateful_expr`](@ref) run with literal `Core.eval` instead: real Julia `while`,
so unlike [`stateful_interpret_baseline`](@ref) this handles every sampled
program, at the same per-call compilation cost `expr_eval_baseline` pays.
"""
function stateful_eval_baseline(g::AbstractGrammar, mod::Module)
    return function (program, states)
        body = stateful_expr(program, g)
        return map(states) do s
            Core.eval(mod, Expr(:let, Expr(:(=), :state, s), body))
        end
    end
end

# ---------------------------------------------------------------------------
# Expression benchmarks
# ---------------------------------------------------------------------------

"""
    other_ids(mod, used, n) -> Vector{String}

`n` problem identifiers of `mod` other than `used`, for the cold probe.
"""
function other_ids(mod::Module, used::AbstractString, n::Int)
    ids = filter(!=(used), get_all_identifiers(mod))
    return ids[1:min(n, length(ids))]
end

function target_deepcoder(; problem_id::String = "000", n_examples::Int = 5,
    n_cold::Int = 5)
    pair = get_problem_grammar_pair(DeepCoder_2016, problem_id)
    g = pair.grammar
    interp = DeepCoder_2016.make_deepcoder_interpreter(g)
    v1_interp = HerbInterpretV1.make_interpreter(g; target_module=DeepCoder_2016)
    examples = take_examples(pair.problem, n_examples)
    v2_interp = HerbInterpretBatched.make_batched_interpreter(g, interp;
        n_examples=n_examples, target_module=DeepCoder_2016)
    cold = ColdProbe(
        other_ids(DeepCoder_2016, problem_id, n_cold),
        function (id)
            other = get_problem_grammar_pair(DeepCoder_2016, id)
            return (other.grammar, take_examples(other.problem, n_examples))
        end,
        DeepCoder_2016.make_deepcoder_interpreter,
    )
    return BenchTarget(
        "DeepCoder_2016",
        DeepCoder_2016,
        "grammar_$problem_id",
        g,
        :Start,
        interp,
        v1_interp,
        v2_interp,
        cold,
        examples,
        HerbInterpret.prepare_input(interp, examples),
        false,
        loop_rules(g),
        expr_interpret_baseline(g, DeepCoder_2016),
        Returns(false),
        expr_eval_baseline(g, DeepCoder_2016),
    )
end

function target_bv(; problem_id::String = "PRE_100_10", n_examples::Int = 5,
    n_cold::Int = 5)
    pair = get_problem_grammar_pair(PBE_BV_Track_2018, problem_id)
    g = pair.grammar
    interp = PBE_BV_Track_2018.make_bv_interpreter(g)
    v1_interp = HerbInterpretV1.make_interpreter(g; target_module=PBE_BV_Track_2018)
    examples = take_examples(pair.problem, n_examples)
    v2_interp = HerbInterpretBatched.make_batched_interpreter(g, interp;
        n_examples=n_examples, target_module=PBE_BV_Track_2018)
    cold = ColdProbe(
        other_ids(PBE_BV_Track_2018, problem_id, n_cold),
        function (id)
            other = get_problem_grammar_pair(PBE_BV_Track_2018, id)
            return (other.grammar, take_examples(other.problem, n_examples))
        end,
        PBE_BV_Track_2018.make_bv_interpreter,
    )
    return BenchTarget(
        "PBE_BV_Track_2018",
        PBE_BV_Track_2018,
        "grammar_$problem_id",
        g,
        :Start,
        interp,
        v1_interp,
        v2_interp,
        cold,
        examples,
        HerbInterpret.prepare_input(interp, examples),
        false,
        loop_rules(g),
        expr_interpret_baseline(g, PBE_BV_Track_2018),
        Returns(false),
        expr_eval_baseline(g, PBE_BV_Track_2018),
    )
end

function target_slia(; problem_id::String = "11440431", n_examples::Int = 5,
    n_cold::Int = 5)
    pair = get_problem_grammar_pair(PBE_SLIA_Track_2019, problem_id)
    g = pair.grammar
    interp = PBE_SLIA_Track_2019.make_SLIA_interpreter(g)
    v1_interp = HerbInterpretV1.make_interpreter(g; target_module=PBE_SLIA_Track_2019)
    examples = take_examples(pair.problem, n_examples)
    v2_interp = HerbInterpretBatched.make_batched_interpreter(g, interp;
        n_examples=n_examples, target_module=PBE_SLIA_Track_2019)
    cold = ColdProbe(
        other_ids(PBE_SLIA_Track_2019, problem_id, n_cold),
        function (id)
            other = get_problem_grammar_pair(PBE_SLIA_Track_2019, id)
            return (other.grammar, take_examples(other.problem, n_examples))
        end,
        PBE_SLIA_Track_2019.make_SLIA_interpreter,
    )
    return BenchTarget(
        "PBE_SLIA_Track_2019",
        PBE_SLIA_Track_2019,
        "grammar_$problem_id",
        g,
        :Start,
        interp,
        v1_interp,
        v2_interp,
        cold,
        examples,
        HerbInterpret.prepare_input(interp, examples),
        false,
        loop_rules(g),
        expr_interpret_baseline(g, PBE_SLIA_Track_2019),
        Returns(false),
        expr_eval_baseline(g, PBE_SLIA_Track_2019),
    )
end

# ---------------------------------------------------------------------------
# Stateful benchmarks
# ---------------------------------------------------------------------------

function target_robots(; n_examples::Int = 5)
    g = Robots_2020.grammar_robots
    return BenchTarget(
        "Robots_2020",
        Robots_2020,
        "grammar_robots",
        g,
        :Start,
        Robots_2020.interpret,
        HerbInterpretV1.make_stateful_interpreter(g; target_module=Robots_2020),
        HerbInterpretBatched.make_batched_stateful_interpreter(g, Robots_2020.interpret;
            n_examples=n_examples, target_module=Robots_2020),
        nothing,  # one interpreter is generated at module load for all problems
        collect_states(Robots_2020, :_arg_1_, n_examples),
        nothing,  # no Dict/IOExample conversion for stateful interpreters
        false,
        loop_rules(g),
        stateful_interpret_baseline(g, Robots_2020),
        stateful_interpret_unsupported(g),
        stateful_eval_baseline(g, Robots_2020),
    )
end

function target_pixels(; n_examples::Int = 5)
    g = Pixels_2020.grammar_pixels
    return BenchTarget(
        "Pixels_2020",
        Pixels_2020,
        "grammar_pixels",
        g,
        :Start,
        Pixels_2020.interpret,
        HerbInterpretV1.make_stateful_interpreter(g; target_module=Pixels_2020),
        HerbInterpretBatched.make_batched_stateful_interpreter(g, Pixels_2020.interpret;
            n_examples=n_examples, target_module=Pixels_2020),
        nothing,  # one interpreter is generated at module load for all problems
        collect_states(Pixels_2020, :_arg_1, n_examples),
        nothing,  # no Dict/IOExample conversion for stateful interpreters
        true,  # PixelState is mutable and the primitives mutate it in place
        loop_rules(g),
        stateful_interpret_baseline(g, Pixels_2020),
        stateful_interpret_unsupported(g),
        stateful_eval_baseline(g, Pixels_2020),
    )
end

function target_strings(; n_examples::Int = 5)
    g = String_transformations_2020.grammar_string
    return BenchTarget(
        "String_transformations_2020",
        String_transformations_2020,
        "grammar_string",
        g,
        :Start,
        String_transformations_2020.interpret,
        HerbInterpretV1.make_stateful_interpreter(g; target_module=String_transformations_2020),
        HerbInterpretBatched.make_batched_stateful_interpreter(g, String_transformations_2020.interpret;
            n_examples=n_examples, target_module=String_transformations_2020),
        nothing,  # one interpreter is generated at module load for all problems
        collect_states(String_transformations_2020, :_arg_1, n_examples),
        nothing,  # no Dict/IOExample conversion for stateful interpreters
        false,
        loop_rules(g),
        stateful_interpret_baseline(g, String_transformations_2020),
        stateful_interpret_unsupported(g),
        stateful_eval_baseline(g, String_transformations_2020),
    )
end

const TARGET_BUILDERS = Dict{String,Function}(
    "DeepCoder_2016" => target_deepcoder,
    "PBE_BV_Track_2018" => target_bv,
    "PBE_SLIA_Track_2019" => target_slia,
    "Robots_2020" => target_robots,
    "Pixels_2020" => target_pixels,
    "String_transformations_2020" => target_strings,
)

const DEFAULT_TARGETS = [
    "DeepCoder_2016",
    "PBE_BV_Track_2018",
    "PBE_SLIA_Track_2019",
    "Robots_2020",
    "Pixels_2020",
    "String_transformations_2020",
]

"""
    build_target(name; kwargs...) -> BenchTarget
"""
function build_target(name::AbstractString; kwargs...)
    haskey(TARGET_BUILDERS, name) ||
        error("unknown benchmark \"$name\"; known: $(join(sort(collect(keys(TARGET_BUILDERS))), ", "))")
    return TARGET_BUILDERS[name](; kwargs...)
end
