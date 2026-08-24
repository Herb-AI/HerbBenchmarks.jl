"""
Ways of scoring a house-building program.

Each `problem_house_*` carries one `IOExample` whose output is the target
canvas, so the default specification is exact reconstruction. That is a harsh
all-or-nothing signal for a 100-block structure, so this file adds the partial
-credit views the structure-building literature actually uses:

  - [`voxel_f1`](@ref) and [`voxel_iou`](@ref) score a build against a target
    by overlap, so a house that is right except for its roof scores highly.
  - [`evaluate_trace`](@ref) returns the `(observation, is_done, reward)`
    triple `HerbSearch`'s trace-guided iterators consume.
  - [`trace_problem`](@ref) exposes the *order* blocks were laid in, which is
    what 3D-Craft is a dataset of and what its order-aware models predict.
"""

"""
    HOUSE_TARGETS

The finished canvas for every house problem, keyed by identifier.
"""
const HOUSE_TARGETS = Dict{String,Dict{NTuple{3,Int},Int}}()

"""
    HOUSE_TRACES

The ordered block placements for every house problem, keyed by identifier.
"""
const HOUSE_TRACES = Dict{String,Vector{NTuple{4,Int}}}()

"""
    HOUSE_GRAMMARS

The per-house grammar for every house problem, keyed by identifier.
"""
const HOUSE_GRAMMARS = Dict{String,AbstractGrammar}()

"""
    house_problem(identifier, trace) -> (Problem, AbstractGrammar)

Turn an ordered list of `(x, y, z, block)` placements into a problem and its
grammar, registering both so the rest of the module can find them.

The problem's input is an empty [`HouseState`](@ref) and its output is the
finished canvas; the grammar offers exactly the block types this house uses.
"""
function house_problem(identifier::AbstractString, trace::Vector{<:NTuple{4,Int}})
    target = Dict{NTuple{3,Int},Int}((x, y, z) => block for (x, y, z, block) in trace)
    grammar = house_grammar(sort!(unique(block for (_, _, _, block) in trace)))

    HOUSE_TARGETS[identifier] = target
    HOUSE_TRACES[identifier] = collect(trace)
    HOUSE_GRAMMARS[identifier] = grammar

    problem = Problem(identifier,
        [IOExample(Dict{Symbol,Any}(:_arg_1 => HouseState()), target)])
    return problem, grammar
end

"""
    voxel_f1(built, target) -> Float64

F1 score of a build against a target, counting a cell correct only when it
holds the *same block type*.

F1 rather than raw accuracy because the canvas is mostly empty: a program that
places nothing would score well on "cells that match" and must not.
"""
function voxel_f1(built::AbstractDict, target::AbstractDict)
    isempty(built) && isempty(target) && return 1.0
    correct = count(get(built, cell, nothing) == block for (cell, block) in target)
    correct == 0 && return 0.0
    precision = correct / length(built)
    recall = correct / length(target)
    return 2 * precision * recall / (precision + recall)
end

"""
    voxel_iou(built, target) -> Float64

Intersection over union of a build and a target, again matching on block type.
"""
function voxel_iou(built::AbstractDict, target::AbstractDict)
    isempty(built) && isempty(target) && return 1.0
    correct = count(get(built, cell, nothing) == block for (cell, block) in target)
    return correct / (length(built) + length(target) - correct)
end

"""
    reward(program, identifier) -> Float64

How well `program` reproduces house `identifier`, as a [`voxel_f1`](@ref) in
`0.0` to `1.0`, reaching `1.0` only on an exact reconstruction.
"""
reward(program, identifier::AbstractString) =
    voxel_f1(canvas_of(program, identifier), HOUSE_TARGETS[identifier])

"""
    evaluate_trace(program, identifier) -> (observation, is_done, reward)

Run `program` and report it the way `HerbSearch`'s trace-guided search expects.

The `observation` is the built canvas, `is_done` whether it matches the target
exactly, and the reward its F1 against the target.
"""
function evaluate_trace(program, identifier::AbstractString)
    built = canvas_of(program, identifier)
    target = HOUSE_TARGETS[identifier]
    return (built, built == target, voxel_f1(built, target))
end

"""
    canvas_of(program, identifier) -> Dict{NTuple{3,Int},Int}

The canvas `program` builds, accepting either a `RuleNode` -- interpreted
against house `identifier`'s grammar -- or an already-interpreted function.
"""
canvas_of(program::AbstractRuleNode, identifier::AbstractString) =
    interpret(program, Dict{Symbol,Any}(:_arg_1 => HouseState()), HOUSE_GRAMMARS[identifier])
canvas_of(program, ::AbstractString) = build_house(program, HouseState())

"""
    program_function(program, identifier) -> Function

The composed `HouseState -> HouseState` function a program denotes.

Interpreting a whole program runs it and hands back a finished canvas, which is
no use to anything that wants to watch it happen. Interpreting the `Sequence`
underneath the `Start` rule yields the function instead, which can then be run
under any budget -- that is how the visualiser gets its frames.

Already-interpreted functions pass through, so callers need not care which they
hold.
"""
function program_function(program::AbstractRuleNode, identifier::AbstractString)
    body = get_rule(program) == 1 ? only(get_children(program)) : program
    return interpret(body, Dict{Symbol,Any}(), HOUSE_GRAMMARS[identifier])
end
program_function(program, ::AbstractString) = program

"""
    execution_states(program, state) -> Vector{HouseState}

The canvas after each action `program` takes, starting from the empty one.

Like the MineRL visualiser, this re-runs the program under a tightened action
budget rather than instrumenting the primitives: a program allowed `k` actions
is by construction the program stopped after `k` actions.
"""
function execution_states(program, state::HouseState=HouseState())
    total = state.budget - final_state(program, state).budget
    return [final_state(program, with_budget(state, k)) for k in 0:total]
end

"""
    with_budget(state, budget) -> HouseState

A copy of `state` allowed only `budget` actions.
"""
function with_budget(s::HouseState, budget::Int)
    limited = copy(s)
    limited.budget = budget
    return limited
end

"""
    execution_trace(program) -> Trace

The intermediate canvases `program` passes through, as a
`HerbSpecification.Trace`.
"""
execution_trace(program) = Trace([copy(s.canvas) for s in execution_states(program)])

"""
    build_order(identifier) -> Trace

The order the human laid this house's blocks in, as a `Trace` of partial
canvases.

This is the supervision 3D-Craft exists to provide -- the paper's model
predicts *which block comes next* -- and it is strictly more than the finished
house the `IOExample` records.
"""
function build_order(identifier::AbstractString)
    canvas = Dict{NTuple{3,Int},Int}()
    states = [copy(canvas)]
    for (x, y, z, block) in HOUSE_TRACES[identifier]
        canvas[(x, y, z)] = block
        push!(states, copy(canvas))
    end
    return Trace(states)
end

"""
    trace_problem(identifier) -> Problem

A `Problem` whose specification is the human's build order rather than a single
input/output example.
"""
trace_problem(identifier::AbstractString) = Problem(identifier, [build_order(identifier)])

"""
    metric_problem(identifier) -> MetricProblem

The problem paired with a dense cost function, `1 - voxel_f1`, for the
stochastic search iterators.
"""
function metric_problem(identifier::AbstractString)
    problem = get_problem_by_identifier(identifier)
    cost(outcomes) = sum(1.0 - voxel_f1(actual, expected) for (actual, expected) in outcomes)
    return MetricProblem(problem.name, cost, problem.spec)
end

"""
    get_problem_by_identifier(identifier) -> Problem

The `problem_<identifier>` defined in this module.
"""
function get_problem_by_identifier(identifier::AbstractString)
    name = Symbol("problem_", identifier)
    isdefined(Minecraft_Houses_2019, name) ||
        throw(KeyError("no problem `$name` in Minecraft_Houses_2019"))
    return getfield(Minecraft_Houses_2019, name)
end

"""
    Base.show(io::IO, s::HouseState)

Summarise a build: how many blocks are down, how large the result is, and where
the cursor sits.
"""
function Base.show(io::IO, s::HouseState)
    if isempty(s.canvas)
        print(io, "HouseState(empty, cursor $(s.cursor), block $(s.block))")
        return
    end
    dims = ntuple(i -> maximum(c[i] for c in keys(s.canvas)) -
                       minimum(c[i] for c in keys(s.canvas)) + 1, 3)
    print(io, "HouseState($(length(s.canvas)) blocks in $(dims[1])x$(dims[2])x$(dims[3]), ",
        "cursor $(s.cursor), block $(s.block))")
end
