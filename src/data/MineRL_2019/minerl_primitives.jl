"""
The symbolic Minecraft world the MineRL tasks are played in, and the primitives
a program acts on it with.

The real MineRL environments hand an agent a 64x64 RGB frame and take
keyboard-and-mouse actions, which no Julia interpreter can reproduce. What
survives the abstraction -- and what makes the `Obtain*` family interesting --
is the *item hierarchy* (Guss et al., 2019, Fig. 2): the strict prerequisite
chain from logs to planks to sticks to pickaxes to iron to diamonds. That
hierarchy is modelled exactly here, on top of a discrete voxel world with a
gridded agent.

Every primitive is a function `MineWorld -> MineWorld` that mutates and returns
its argument, and every condition a function `MineWorld -> Bool`. Programs are
built by composing them with [`seq`](@ref); [`run_minerl`](@ref) copies the
starting world before applying one, so a program never disturbs the problem it
was run on.
"""

"""
    MAX_ACTIONS

The action budget of an episode. It stands in for MineRL's per-task time limit
and, more importantly, guarantees that [`while_op`](@ref) terminates.
"""
const MAX_ACTIONS = 512

"""
    WORLD_FLOOR

The lowest `y` an agent can fall to. Every problem's terrain is bedrock-capped
at this level, so this is a backstop rather than a rule of the world.
"""
const WORLD_FLOOR = 0

"""
    DIRECTIONS

Unit steps for the four facings, indexed by `MineWorld.facing`: east (`+x`),
south (`+z`), west (`-x`), north (`-z`).
"""
const DIRECTIONS = ((1, 0, 0), (0, 0, 1), (-1, 0, 0), (0, 0, -1))

"""
    PASSABLE

Blocks an agent can stand inside. Everything else in a world's block map is
solid, and absent coordinates are air.
"""
const PASSABLE = Set([:water, :torch])

"""
    TOOL_TIER

Mining tier of each pickaxe, following Minecraft's own progression. An agent's
tier is the best pickaxe it is carrying; see [`agent_tier`](@ref).
"""
const TOOL_TIER = Dict(:wooden_pickaxe => 1, :stone_pickaxe => 2, :iron_pickaxe => 3)

"""
    TIER_TOOL

The cheapest pickaxe satisfying each mining tier -- [`TOOL_TIER`](@ref) read
backwards, for working out what a task needs before it can mine something.
"""
const TIER_TOOL = Dict(1 => :wooden_pickaxe, 2 => :stone_pickaxe, 3 => :iron_pickaxe)

"""
    BLOCK_DROPS

What each block yields when mined, and the tool tier needed to yield anything.

Mining a block below its tier fails outright, which is what forces the
`Obtain*` tasks through the hierarchy: stone needs a wooden pickaxe, iron ore a
stone one, and diamond an iron one.
"""
const BLOCK_DROPS = Dict{Symbol,Tuple{Vector{Pair{Symbol,Int}},Int}}(
    :grass => ([:dirt => 1], 0),
    :dirt => ([:dirt => 1], 0),
    :sand => ([:sand => 1], 0),
    :log => ([:log => 1], 0),
    :leaves => (Pair{Symbol,Int}[], 0),
    :stone => ([:cobblestone => 1], 1),
    :cobblestone => ([:cobblestone => 1], 1),
    :coal_ore => ([:coal => 1], 1),
    :iron_ore => ([:iron_ore => 1], 2),
    :diamond_ore => ([:diamond => 1], 3),
    :planks => ([:planks => 1], 0),
    :torch => ([:torch => 1], 0),
    # Animals are modelled as one-off blocks: walking up and "mining" one is
    # the abstraction's stand-in for killing it.
    :cow => ([:beef => 1], 0),
    :pig => ([:porkchop => 1], 0),
    :chicken => ([:chicken => 1], 0),
    :white_sheep => ([:mutton => 1, :white_wool => 1], 0),
    :red_sheep => ([:mutton => 1, :red_wool => 1], 0),
    :blue_sheep => ([:mutton => 1, :blue_wool => 1], 0),
    # Bedrock and water are deliberately absent from the drop table, so
    # `mine_at!` refuses to break them.
)

"""
    Recipe

A crafting recipe: what it consumes, what it yields, and whether it needs a
crafting table (Minecraft's 3x3 grid) rather than the 2x2 inventory grid.
"""
struct Recipe
    inputs::Vector{Pair{Symbol,Int}}
    output::Pair{Symbol,Int}
    needs_table::Bool
end

"""
    CRAFTING

The recipes reachable in this abstraction, covering every prerequisite of the
`ObtainIronPickaxe`, `ObtainDiamond`, `ObtainCookedMeat` and `ObtainBed` tasks.
"""
const CRAFTING = Dict{Symbol,Recipe}(
    :planks => Recipe([:log => 1], :planks => 4, false),
    :stick => Recipe([:planks => 2], :stick => 4, false),
    :crafting_table => Recipe([:planks => 4], :crafting_table => 1, false),
    :furnace => Recipe([:cobblestone => 8], :furnace => 1, true),
    :torch => Recipe([:coal => 1, :stick => 1], :torch => 4, false),
    :wooden_pickaxe => Recipe([:planks => 3, :stick => 2], :wooden_pickaxe => 1, true),
    :stone_pickaxe => Recipe([:cobblestone => 3, :stick => 2], :stone_pickaxe => 1, true),
    :iron_pickaxe => Recipe([:iron_ingot => 3, :stick => 2], :iron_pickaxe => 1, true),
    :white_bed => Recipe([:white_wool => 3, :planks => 3], :white_bed => 1, true),
    :red_bed => Recipe([:red_wool => 3, :planks => 3], :red_bed => 1, true),
    :blue_bed => Recipe([:blue_wool => 3, :planks => 3], :blue_bed => 1, true),
)

"""
    SMELTING

Furnace recipes, as `output => input`. Smelting additionally consumes one unit
of fuel and needs a furnace in the inventory; see [`smelt`](@ref).
"""
const SMELTING = Dict{Symbol,Symbol}(
    :iron_ingot => :iron_ore,
    :cooked_beef => :beef,
    :cooked_porkchop => :porkchop,
    :cooked_chicken => :chicken,
    :cooked_mutton => :mutton,
)

"""
    FUELS

Items a furnace will burn, cheapest first, so that [`smelt`](@ref) spends coal
only when it has no spare planks.
"""
const FUELS = (:planks, :coal)

"""
    MineWorld

A MineRL episode in progress: the terrain, where the agent stands, what it
carries, and what it is trying to achieve.

`blocks` maps `(x, y, z)` to a block name, with `y` pointing up and absent
coordinates meaning air. The agent occupies `pos` and the cell directly above
it. `objective` is `item => count`, or `:reach_goal => 1` for the Navigate
tasks, mirroring MineRL's sparse "+1 and terminate" reward.

`obtained` records every item the agent has *ever* held, which the inventory
alone cannot tell you because crafting consumes its inputs. MineRL annotates
its trajectories with item collection events for the same reason; here it is
what lets `progress` reward climbing the item hierarchy rather than only
reaching the top of it.

This type is mutable and the primitives mutate it in place;
[`run_minerl`](@ref) copies before running, so problems stay pristine.
"""
mutable struct MineWorld
    blocks::Dict{NTuple{3,Int},Symbol}
    pos::NTuple{3,Int}
    facing::Int
    inventory::Dict{Symbol,Int}
    obtained::Set{Symbol}
    objective::Pair{Symbol,Int}
    goal::NTuple{3,Int}
    budget::Int
end

"""
    MineWorld(blocks, pos, objective; facing=1, inventory=Dict(), goal=pos, budget=MAX_ACTIONS)

Build a starting world. The keyword defaults describe MineRL's usual opening
position: a fresh agent with an empty inventory facing east.
"""
MineWorld(blocks::AbstractDict, pos::NTuple{3,Int}, objective::Pair{Symbol,Int};
    facing::Int=1, inventory::AbstractDict=Dict{Symbol,Int}(),
    goal::NTuple{3,Int}=pos, budget::Int=MAX_ACTIONS) =
    MineWorld(Dict{NTuple{3,Int},Symbol}(blocks), pos, facing,
        Dict{Symbol,Int}(inventory), Set{Symbol}(keys(inventory)),
        objective, goal, budget)

Base.copy(w::MineWorld) = MineWorld(copy(w.blocks), w.pos, w.facing,
    copy(w.inventory), copy(w.obtained), w.objective, w.goal, w.budget)

Base.:(==)(a::MineWorld, b::MineWorld) =
    a.blocks == b.blocks && a.pos == b.pos && a.facing == b.facing &&
    a.inventory == b.inventory && a.obtained == b.obtained &&
    a.objective == b.objective && a.goal == b.goal

"""
    block_at(world, cell) -> Symbol

The block at `cell`, or `:air` where nothing is recorded.
"""
block_at(w::MineWorld, cell::NTuple{3,Int}) = get(w.blocks, cell, :air)

"""
    is_solid(world, cell) -> Bool

Whether `cell` blocks movement. Air and the [`PASSABLE`](@ref) blocks do not.
"""
is_solid(w::MineWorld, cell::NTuple{3,Int}) =
    haskey(w.blocks, cell) && !(w.blocks[cell] in PASSABLE)

"""
    fits_agent(world, cell) -> Bool

Whether the agent could stand with its feet at `cell`, which needs both that
cell and the one above it clear.
"""
fits_agent(w::MineWorld, cell::NTuple{3,Int}) =
    !is_solid(w, cell) && !is_solid(w, cell .+ (0, 1, 0))

"""
    ahead(world; up=0) -> NTuple{3,Int}

The cell one step in the direction the agent faces, raised by `up`.
"""
ahead(w::MineWorld; up::Int=0) = w.pos .+ DIRECTIONS[w.facing] .+ (0, up, 0)

"""
    item_count(world, item) -> Int

How many of `item` the agent carries.
"""
item_count(w::MineWorld, item::Symbol) = get(w.inventory, item, 0)

"""
    give!(world, item, n)

Add `n` of `item` to the inventory.
"""
function give!(w::MineWorld, item::Symbol, n::Int)
    w.inventory[item] = item_count(w, item) + n
    push!(w.obtained, item)
    return w
end

"""
    consume!(world, item, n) -> Bool

Remove `n` of `item`, returning `false` and changing nothing if the agent does
not have that many.
"""
function consume!(w::MineWorld, item::Symbol, n::Int)
    item_count(w, item) < n && return false
    remaining = item_count(w, item) - n
    remaining == 0 ? delete!(w.inventory, item) : (w.inventory[item] = remaining)
    return true
end

"""
    agent_tier(world) -> Int

The best mining tier the agent's pickaxes afford, `0` for bare hands.

MineRL's simplified action space equips the best available tool automatically,
so this benchmark spends no action on equipping.
"""
agent_tier(w::MineWorld) =
    maximum((get(TOOL_TIER, item, 0) for item in keys(w.inventory)), init=0)

"""
    objective_met(world) -> Bool

Whether the episode's goal has been reached: for Navigate, standing on the goal
cell; otherwise, carrying enough of the target item.
"""
function objective_met(w::MineWorld)
    (target, count) = w.objective
    return target === :reach_goal ? w.pos == w.goal : item_count(w, target) >= count
end

"""
    active(world) -> Bool

Whether the episode is still running. Actions taken after the budget runs out,
or after the objective is met, do nothing -- MineRL terminates an episode the
moment its reward fires, and letting a program keep acting past that point
would let it *lose* an item it had already obtained.
"""
active(w::MineWorld) = w.budget > 0 && !objective_met(w)

"""
    spend!(world) -> Bool

Charge one action against the budget, returning whether the episode was still
running. Every primitive begins with this.
"""
function spend!(w::MineWorld)
    active(w) || return false
    w.budget -= 1
    return true
end

# ---------------------------------------------------------------------------
# Movement
# ---------------------------------------------------------------------------

"""
    settle!(world)

Drop the agent until it is standing on something, or has reached
[`WORLD_FLOOR`](@ref).
"""
function settle!(w::MineWorld)
    while w.pos[2] > WORLD_FLOOR && !is_solid(w, w.pos .- (0, 1, 0))
        w.pos = w.pos .- (0, 1, 0)
    end
    return w
end

"""
    step_towards!(world, delta)

Try to move one cell by `delta`, climbing a single block if the way is barred
but the ledge is clear, then falling to the ground. A blocked step is a no-op,
not an error.
"""
function step_towards!(w::MineWorld, delta::NTuple{3,Int})
    target = w.pos .+ delta
    if fits_agent(w, target)
        w.pos = target
    elseif is_solid(w, target) && fits_agent(w, target .+ (0, 1, 0))
        w.pos = target .+ (0, 1, 0)
    else
        return w
    end
    return settle!(w)
end

"""
    move_forward(world)

Step one cell in the direction the agent faces.
"""
move_forward(w::MineWorld) = spend!(w) ? step_towards!(w, DIRECTIONS[w.facing]) : w

"""
    move_back(world)

Step one cell backwards, without turning.
"""
move_back(w::MineWorld) = spend!(w) ? step_towards!(w, .-DIRECTIONS[w.facing]) : w

"""
    strafe_left(world)

Step one cell to the agent's left, without turning.
"""
strafe_left(w::MineWorld) = spend!(w) ? step_towards!(w, DIRECTIONS[mod1(w.facing + 3, 4)]) : w

"""
    strafe_right(world)

Step one cell to the agent's right, without turning.
"""
strafe_right(w::MineWorld) = spend!(w) ? step_towards!(w, DIRECTIONS[mod1(w.facing + 1, 4)]) : w

"""
    turn_left(world)

Rotate the agent 90 degrees anticlockwise. This is the discrete stand-in for
MineRL's continuous camera yaw.
"""
turn_left(w::MineWorld) = spend!(w) ? (w.facing = mod1(w.facing + 3, 4); w) : w

"""
    turn_right(world)

Rotate the agent 90 degrees clockwise.
"""
turn_right(w::MineWorld) = spend!(w) ? (w.facing = mod1(w.facing + 1, 4); w) : w

"""
    jump_forward(world)

Hop over a one-cell gap or obstacle directly ahead, landing two cells away.

Falls back to a plain step when the landing spot is occupied, so a jump is
never worse than walking.
"""
function jump_forward(w::MineWorld)
    spend!(w) || return w
    delta = DIRECTIONS[w.facing]
    landing = w.pos .+ 2 .* delta
    if fits_agent(w, landing) && is_solid(w, landing .- (0, 1, 0))
        w.pos = landing
        return settle!(w)
    end
    return step_towards!(w, delta)
end

# ---------------------------------------------------------------------------
# Mining and placing
# ---------------------------------------------------------------------------

"""
    mine_at!(world, cell)

Break the block at `cell` and collect its drops, provided the agent's tier is
high enough. Air, bedrock and water are not mineable and leave the world alone.
"""
function mine_at!(w::MineWorld, cell::NTuple{3,Int})
    block = block_at(w, cell)
    haskey(BLOCK_DROPS, block) || return w
    (drops, tier) = BLOCK_DROPS[block]
    agent_tier(w) >= tier || return w

    delete!(w.blocks, cell)
    for (item, n) in drops
        give!(w, item, n)
    end
    return settle!(w)
end

"""
    mine_forward(world)

Break the block directly ahead at foot level.
"""
mine_forward(w::MineWorld) = spend!(w) ? mine_at!(w, ahead(w)) : w

"""
    mine_forward_up(world)

Break the block directly ahead at head level. Clearing a path to walk along
takes this *and* [`mine_forward`](@ref), since the agent is two cells tall.
"""
mine_forward_up(w::MineWorld) = spend!(w) ? mine_at!(w, ahead(w; up=1)) : w

"""
    mine_down(world)

Break the block underfoot, dropping the agent into the hole.
"""
mine_down(w::MineWorld) = spend!(w) ? mine_at!(w, w.pos .- (0, 1, 0)) : w

"""
    mine_up(world)

Break the block above the agent's head.
"""
mine_up(w::MineWorld) = spend!(w) ? mine_at!(w, w.pos .+ (0, 2, 0)) : w

"""
    place_forward(block)

An operation that places one `block` from the inventory in the cell ahead.

Does nothing if the agent has none, or if the cell is already occupied.
"""
function place_forward(block::Symbol)
    return function (w::MineWorld)
        spend!(w) || return w
        cell = ahead(w)
        is_solid(w, cell) && return w
        consume!(w, block, 1) || return w
        w.blocks[cell] = block
        return w
    end
end

# ---------------------------------------------------------------------------
# Crafting
# ---------------------------------------------------------------------------

"""
    craft(item)

An operation that crafts one batch of `item`.

Does nothing unless the agent holds every ingredient, plus a crafting table
when the recipe needs one.
"""
function craft(item::Symbol)
    return function (w::MineWorld)
        spend!(w) || return w
        recipe = get(CRAFTING, item, nothing)
        recipe === nothing && return w
        recipe.needs_table && item_count(w, :crafting_table) < 1 && return w
        all(item_count(w, ingredient) >= n for (ingredient, n) in recipe.inputs) || return w

        for (ingredient, n) in recipe.inputs
            consume!(w, ingredient, n)
        end
        return give!(w, recipe.output.first, recipe.output.second)
    end
end

"""
    smelt(item)

An operation that smelts one `item` in a furnace.

Needs a furnace in the inventory, the raw input, and one unit of fuel; planks
are burned before coal, so that coal stays available for torches.
"""
function smelt(item::Symbol)
    return function (w::MineWorld)
        spend!(w) || return w
        raw = get(SMELTING, item, nothing)
        raw === nothing && return w
        item_count(w, :furnace) >= 1 || return w
        item_count(w, raw) >= 1 || return w

        fuel = findfirst(f -> item_count(w, f) >= 1, FUELS)
        fuel === nothing && return w

        consume!(w, raw, 1)
        consume!(w, FUELS[fuel], 1)
        return give!(w, item, 1)
    end
end

# ---------------------------------------------------------------------------
# Conditions
# ---------------------------------------------------------------------------

"""
    at_goal(world) -> Bool

Whether the agent is standing on the Navigate goal.
"""
at_goal(w::MineWorld) = w.pos == w.goal

"""
    goal_offset(world) -> NTuple{3,Int}

The vector from the agent to the goal. This is the benchmark's version of
MineRL's compass observation.
"""
goal_offset(w::MineWorld) = w.goal .- w.pos

"""
    goal_ahead(world) -> Bool

Whether the goal lies in front of the agent, along the axis it faces.
"""
function goal_ahead(w::MineWorld)
    delta = DIRECTIONS[w.facing]
    offset = goal_offset(w)
    return offset[1] * delta[1] + offset[3] * delta[3] > 0
end

"""
    goal_behind(world) -> Bool

Whether the goal lies behind the agent.
"""
function goal_behind(w::MineWorld)
    delta = DIRECTIONS[w.facing]
    offset = goal_offset(w)
    return offset[1] * delta[1] + offset[3] * delta[3] < 0
end

"""
    goal_left(world) -> Bool

Whether the goal lies to the agent's left.
"""
function goal_left(w::MineWorld)
    delta = DIRECTIONS[mod1(w.facing + 3, 4)]
    offset = goal_offset(w)
    return offset[1] * delta[1] + offset[3] * delta[3] > 0
end

"""
    goal_right(world) -> Bool

Whether the goal lies to the agent's right.
"""
function goal_right(w::MineWorld)
    delta = DIRECTIONS[mod1(w.facing + 1, 4)]
    offset = goal_offset(w)
    return offset[1] * delta[1] + offset[3] * delta[3] > 0
end

"""
    blocked_ahead(world) -> Bool

Whether something bars a plain step forward, at either foot or head level.
"""
blocked_ahead(w::MineWorld) = is_solid(w, ahead(w)) || is_solid(w, ahead(w; up=1))

"""
    can_step_up(world) -> Bool

Whether the way ahead is barred by exactly one block that the agent could climb.
"""
can_step_up(w::MineWorld) = is_solid(w, ahead(w)) && fits_agent(w, ahead(w; up=1))

"""
    block_ahead_is(block)

A condition testing whether the block directly ahead is `block`.
"""
block_ahead_is(block::Symbol) = (w::MineWorld) -> block_at(w, ahead(w)) === block

"""
    block_below_is(block)

A condition testing whether the block underfoot is `block`.
"""
block_below_is(block::Symbol) = (w::MineWorld) -> block_at(w, w.pos .- (0, 1, 0)) === block

"""
    has_at_least(item, count)

A condition testing whether the agent carries at least `count` of `item`.
"""
has_at_least(item::Symbol, count::Int) = (w::MineWorld) -> item_count(w, item) >= count

"""
    not_op(condition)

Negate a condition.
"""
not_op(condition) = (w::MineWorld) -> !condition(w)

# ---------------------------------------------------------------------------
# Composition
# ---------------------------------------------------------------------------

"""
    seq(operation, rest)

Run `operation`, then `rest`.
"""
seq(operation, rest) = (w::MineWorld) -> rest(operation(w))

"""
    repeat_op(count, body)

Run `body` `count` times.
"""
function repeat_op(count::Int, body)
    return function (w::MineWorld)
        for _ in 1:count
            w = body(w)
        end
        return w
    end
end

"""
    if_op(condition, then_branch, else_branch)

Run one branch or the other. Testing the condition is free; only the branch
that actually runs spends actions.
"""
if_op(condition, then_branch, else_branch) =
    (w::MineWorld) -> condition(w) ? then_branch(w) : else_branch(w)

"""
    while_op(condition, body)

Run `body` while `condition` holds.

The loop also stops once the episode does, so it always terminates: every
primitive in `body` spends from a finite budget, and a body that spends nothing
cannot change the condition either.
"""
function while_op(condition, body)
    return function (w::MineWorld)
        guard = MAX_ACTIONS
        while condition(w) && active(w) && guard > 0
            w = body(w)
            guard -= 1
        end
        return w
    end
end

"""
    run_minerl(program, world) -> Bool

Run `program` on a copy of `world` and report whether it met the objective.

The result is a `Bool` because that is what a MineRL task *is*: a sparse `+1`
for obtaining the item or reaching the goal, and no partial credit. Use
[`final_world`](@ref) when you want to see what actually happened.
"""
run_minerl(program, world::MineWorld) = objective_met(program(copy(world)))

"""
    final_world(program, world) -> MineWorld

Run `program` on a copy of `world` and return the resulting world, rather than
just whether it succeeded. This is the entry point the visualiser uses.
"""
final_world(program, world::MineWorld) = program(copy(world))
