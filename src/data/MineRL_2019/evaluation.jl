"""
Ways of scoring a MineRL program beyond "did it work?".

A `Problem` in HerbBenchmarks carries `IOExample`s, and each problem here has
exactly one whose output is `true` -- that is MineRL's own task definition, a
sparse `+1` for reaching the goal or obtaining the item. But sparse reward is a
poor search signal, and MineRL itself ships a *dense* Navigate variant for
exactly that reason. So this file adds two other views of the same task:

  - [`evaluate_trace`](@ref) returns the `(observation, is_done, reward)`
    triple that `HerbSearch`'s `GuidedSearchTraceIterator` and `probe` consume,
    with the same shape as the live-environment `evaluate_trace_minerl`.
  - [`execution_trace`](@ref) and [`trace_problem`](@ref) expose the
    intermediate worlds an execution passes through, as a
    `HerbSpecification.Trace`.
  - [`metric_problem`](@ref) pairs the sparse example with a dense cost
    function, for the stochastic search iterators.

None of these replace the `problem_*` definitions; they are alternative
specifications over the same worlds.
"""

"""
    goal_distance(world) -> Int

Manhattan distance from the agent to the Navigate goal, ignoring height.

Horizontal distance is what MineRL's compass measures, and what its dense
reward is proportional to.
"""
function goal_distance(w::MineWorld)
    offset = goal_offset(w)
    return abs(offset[1]) + abs(offset[3])
end

"""
    prerequisites(item) -> Set{Symbol}

Every item that must be obtained on the way to `item`, including `item` itself.

Walks the recipes backwards: a crafted item needs its ingredients (and a
crafting table, where the recipe says so), a smelted one needs its raw form and
a furnace, and a mined one needs whatever pickaxe its tier demands. For
`:diamond` this recovers the whole chain from `:log` up, which is MineRL's item
hierarchy (Guss et al., 2019, Fig. 2) rediscovered from the recipe tables
rather than written out by hand.
"""
function prerequisites(item::Symbol, seen::Set{Symbol}=Set{Symbol}())
    item in seen && return seen
    push!(seen, item)

    if haskey(CRAFTING, item)
        recipe = CRAFTING[item]
        for (ingredient, _) in recipe.inputs
            prerequisites(ingredient, seen)
        end
        recipe.needs_table && prerequisites(:crafting_table, seen)
    elseif haskey(SMELTING, item)
        prerequisites(SMELTING[item], seen)
        prerequisites(:furnace, seen)
    else
        # A raw item: find a block that drops it, and require its tool tier.
        for (_, (drops, tier)) in BLOCK_DROPS
            any(drop -> drop.first === item, drops) || continue
            tier > 0 && prerequisites(TIER_TOOL[tier], seen)
            break
        end
    end
    return seen
end

"""
    progress(final, start) -> Float64

How far a run got, on a `0.0` to `1.0` scale, with `1.0` exactly when the
objective was met.

For Navigate this is the fraction of the starting distance closed -- MineRL's
own dense reward, "proportional to distance moved towards the goal" -- and goes
negative if a plan walks the wrong way.

For the `Obtain*` tasks it is the fraction of the target's
[`prerequisites`](@ref) the agent ever held. Scoring on the *final inventory*
would be nearly useless, and not even monotone: crafting an iron pickaxe
consumes the ingots, so an agent that got further could score lower. Scoring on
`obtained` instead turns the item hierarchy into the gradient, which is what
makes `ObtainDiamond` searchable at all.
"""
function progress(final::MineWorld, start::MineWorld)
    objective_met(final) && return 1.0
    (target, count) = final.objective

    if target === :reach_goal
        initial = goal_distance(start)
        initial == 0 && return 1.0
        return (initial - goal_distance(final)) / initial
    end

    milestones = prerequisites(target)
    reached = count_milestones(final, milestones)
    # The target itself is a milestone, so a run that collected some but not
    # enough of it still scores below a run that finished.
    partial = min(item_count(final, target) / count, 1.0)
    return (reached + partial) / (length(milestones) + 1)
end

"""
    count_milestones(world, milestones) -> Int

How many of `milestones` the agent has held at some point.
"""
count_milestones(w::MineWorld, milestones) = count(item -> item in w.obtained, milestones)

"""
    reward(program, world) -> Float64

The dense reward `program` earns on `world`.
"""
reward(program, w::MineWorld) = progress(final_world(program, w), w)

"""
    evaluate_trace(program, world) -> (observation, is_done, reward)

Run `program` and report it the way `HerbSearch`'s trace-guided search expects.

The triple matches `HerbSearch.evaluate_trace`, so a search written against the
live MineRL environment can be pointed at this benchmark unchanged. The
`observation` is the final [`MineWorld`](@ref) -- richer than the live
environment's `(x, y, z)`, and inspectable rather than opaque.
"""
function evaluate_trace(program, w::MineWorld)
    final = final_world(program, w)
    return (final, objective_met(final), progress(final, w))
end

"""
    execution_trace(program, world) -> Trace

The intermediate worlds `program` passes through, as a
`HerbSpecification.Trace`.

This is the same sequence [`visualize`](@ref) animates, so what a search sees
and what you watch are the same thing.
"""
execution_trace(program, w::MineWorld) = Trace(execution_frames(program, w))

"""
    trace_problem(identifier) -> Problem

A `Problem` whose specification is the reference solution's execution trace,
rather than a single input/output example.

Useful when a search can exploit intermediate states: the trace records where
the agent stood and what it held after every action of a solution, instead of
only that a solution exists.
"""
function trace_problem(identifier::AbstractString)
    problem = get_problem_by_identifier(identifier)
    world = problem.spec[1].in[:_arg_1]
    program = interpret(RuleNode(2, [SOLUTIONS[identifier]]), Dict{Symbol,Any}())
    return Problem(problem.name, [execution_trace(program, world)])
end

"""
    metric_problem(identifier) -> MetricProblem

The problem paired with a dense cost function, for the stochastic search
iterators.

The cost is `1 - progress`, so a plan that does nothing costs `1.0`, a solution
costs `0.0`, and walking away from a Navigate goal costs more than standing
still. `HerbSearch`'s stochastic iterators call the cost function on a vector
of `(actual, expected)` outcomes, which is the shape used here.
"""
function metric_problem(identifier::AbstractString)
    problem = get_problem_by_identifier(identifier)
    cost(outcomes) = sum(actual === expected ? 0.0 : 1.0 for (actual, expected) in outcomes)
    return MetricProblem(problem.name, cost, problem.spec)
end

"""
    get_problem_by_identifier(identifier) -> Problem

The `problem_<identifier>` defined in this module.
"""
function get_problem_by_identifier(identifier::AbstractString)
    name = Symbol("problem_", identifier)
    isdefined(MineRL_2019, name) || throw(KeyError("no problem `$name` in MineRL_2019"))
    return getfield(MineRL_2019, name)
end

"""
    Base.show(io::IO, w::MineWorld)

Summarise a world: where the agent is, what it carries, and how it is doing
against its objective.
"""
function Base.show(io::IO, w::MineWorld)
    (target, count) = w.objective
    goal = target === :reach_goal ? "reach $(w.goal), now $(goal_distance(w)) away" :
           "$target x$count, have $(item_count(w, target))"
    print(io, "MineWorld(at $(w.pos) facing $(("east", "south", "west", "north")[w.facing]), ",
        "$(length(w.blocks)) blocks, objective: $goal, ",
        "inventory: $(inventory_summary(w)), budget $(w.budget))")
end
