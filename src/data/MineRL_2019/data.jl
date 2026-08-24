"""
The MineRL problems, and the small terrain builders that make their worlds.

MineRL's own tasks are played on procedurally generated Minecraft maps with the
goal 64 blocks from the start. The worlds here are much smaller -- a Navigate
goal is eight to a dozen blocks away, and Treechop asks for eight logs rather
than sixty-four -- because a synthesiser has to *enumerate* the plan rather than
learn it. The structure of each task is the original's; only the scale is not.
Where a number was scaled, the docstring says so.
"""

"""
    ground_slab(xs, zs; surface=:grass, surface_y=4) -> Dict

A rectangular patch of ground: bedrock at `y = 0`, stone above it, and one
layer of `surface` on top at `surface_y`. An agent stands at `surface_y + 1`.
"""
function ground_slab(xs, zs; surface::Symbol=:grass, surface_y::Int=4)
    blocks = Dict{NTuple{3,Int},Symbol}()
    for x in xs, z in zs
        blocks[(x, 0, z)] = :bedrock
        for y in 1:(surface_y-1)
            blocks[(x, y, z)] = :stone
        end
        blocks[(x, surface_y, z)] = surface
    end
    return blocks
end

"""
    place_row!(blocks, layout; z=0, y=5)

Lay a sequence of `range => block` pairs along the `x` axis at height `y`.

The `Obtain*` worlds are built this way: the resources sit in contiguous runs
directly in front of the agent, so tunnelling through one is a `repeat_op` of
mine-then-step and the task's difficulty stays where MineRL puts it -- in the
order the items have to be made, not in the navigation.
"""
function place_row!(blocks::Dict{NTuple{3,Int},Symbol}, layout; z::Int=0, y::Int=5)
    for (xs, block) in layout, x in xs
        blocks[(x, y, z)] = block
    end
    return blocks
end

"""
    obtain_world(objective, layout; span=32) -> MineWorld

A flat corridor with `layout` laid out ahead of the agent, who starts at the
origin facing east with nothing in hand -- MineRL's `Obtain*` starting
condition.
"""
function obtain_world(objective::Pair{Symbol,Int}, layout; span::Int=32)
    blocks = ground_slab(-1:span, -1:1)
    place_row!(blocks, layout)
    return MineWorld(blocks, (0, 5, 0), objective)
end

# ---------------------------------------------------------------------------
# Navigate: reach a goal over awkward terrain. Movement grammar only.
# ---------------------------------------------------------------------------

"""
    problem_navigate_01_plain

Walk to a goal on open flat ground. The simplest form of MineRL's `Navigate`,
with the compass pointing straight down the `+x` axis.
"""
const world_navigate_01_plain = let blocks = ground_slab(-1:10, -2:2)
    MineWorld(blocks, (0, 5, 0), :reach_goal => 1; goal=(8, 5, 0))
end
problem_navigate_01_plain = Problem("navigate_01_plain",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_navigate_01_plain), true)])
grammar_navigate_01_plain = grammar_minerl_navigate

"""
    problem_navigate_02_ledge

Walk to a goal behind a one-block ledge, which the agent climbs by walking into
it. MineRL's terrain is "non-convex with variable geometry"; this is the
smallest instance of that.
"""
const world_navigate_02_ledge = let blocks = ground_slab(-1:10, -2:2)
    for z in -2:2, x in 4:10
        blocks[(x, 5, z)] = :grass
    end
    MineWorld(blocks, (0, 5, 0), :reach_goal => 1; goal=(8, 6, 0))
end
problem_navigate_02_ledge = Problem("navigate_02_ledge",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_navigate_02_ledge), true)])
grammar_navigate_02_ledge = grammar_minerl_navigate

"""
    problem_navigate_03_trench

Cross a one-block trench to reach the goal. Walking in is fatal to the plan:
the agent falls to the trench floor and cannot climb a two-block wall back out,
so the only way across is [`jump_forward`](@ref).
"""
const world_navigate_03_trench = let blocks = ground_slab(-1:10, -2:2)
    for z in -2:2
        delete!(blocks, (5, 4, z))
        delete!(blocks, (5, 3, z))
        delete!(blocks, (5, 2, z))
        delete!(blocks, (5, 1, z))
    end
    MineWorld(blocks, (0, 5, 0), :reach_goal => 1; goal=(8, 5, 0))
end
problem_navigate_03_trench = Problem("navigate_03_trench",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_navigate_03_trench), true)])
grammar_navigate_03_trench = grammar_minerl_navigate

"""
    problem_navigate_04_corridor

Follow an L-shaped corridor walled in on both sides. The goal is off the
agent's starting axis, so the plan has to turn -- which is what the compass
conditions (`goal_left`, `goal_right`) are for.
"""
const world_navigate_04_corridor = let blocks = ground_slab(-1:8, -1:8)
    # Wall everything in except an L from (0,0) east to (5,0) then south to (5,6).
    for x in -1:8, z in -1:8
        on_path = (z == 0 && 0 <= x <= 5) || (x == 5 && 0 <= z <= 6)
        on_path && continue
        blocks[(x, 5, z)] = :stone
        blocks[(x, 6, z)] = :stone
    end
    MineWorld(blocks, (0, 5, 0), :reach_goal => 1; goal=(5, 5, 6))
end
problem_navigate_04_corridor = Problem("navigate_04_corridor",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_navigate_04_corridor), true)])
grammar_navigate_04_corridor = grammar_minerl_navigate

"""
    problem_navigate_05_staircase

Climb a four-step staircase to a raised goal, one block of ascent per step.
"""
const world_navigate_05_staircase = let blocks = ground_slab(-1:10, -2:2)
    for step in 1:4, z in -2:2, x in (4+step):10
        blocks[(x, 4 + step, z)] = :grass
    end
    MineWorld(blocks, (0, 5, 0), :reach_goal => 1; goal=(9, 9, 0))
end
problem_navigate_05_staircase = Problem("navigate_05_staircase",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_navigate_05_staircase), true)])
grammar_navigate_05_staircase = grammar_minerl_navigate

# ---------------------------------------------------------------------------
# Treechop and the Obtain* family. Full grammar.
# ---------------------------------------------------------------------------

"""
    problem_treechop

Gather logs from a stand of trees, MineRL's `Treechop`.

The original terminates at 64 logs; this asks for 8, which is the same task at
a size a synthesiser can enumerate. Leaves sit at head height above the logs,
so a plan has to clear both levels to walk the row -- chopping a tree is not
just repeated `mine_forward`.
"""
const world_treechop = let blocks = ground_slab(-1:12, -1:1)
    place_row!(blocks, [1:8 => :log])
    for x in 1:8
        blocks[(x, 6, 0)] = :leaves
    end
    MineWorld(blocks, (0, 5, 0), :log => 8)
end
problem_treechop = Problem("treechop",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_treechop), true)])

"""
    problem_obtain_wooden_pickaxe

Make a wooden pickaxe from scratch: chop logs, craft planks and sticks, build a
crafting table, then the pickaxe. The first rung of MineRL's item hierarchy.
"""
const world_obtain_wooden_pickaxe = obtain_world(:wooden_pickaxe => 1, [1:5 => :log])
problem_obtain_wooden_pickaxe = Problem("obtain_wooden_pickaxe",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_obtain_wooden_pickaxe), true)])

"""
    problem_obtain_stone_pickaxe

Make a stone pickaxe, which needs a wooden one first: stone cannot be mined by
hand.
"""
const world_obtain_stone_pickaxe = obtain_world(:stone_pickaxe => 1,
    [1:5 => :log, 7:12 => :stone])
problem_obtain_stone_pickaxe = Problem("obtain_stone_pickaxe",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_obtain_stone_pickaxe), true)])

"""
    problem_obtain_iron_pickaxe

MineRL's `ObtainIronPickaxe`: wood, then stone, then a furnace, then smelt
three iron ingots and craft the pickaxe. Coal is on the way because smelting
needs fuel.
"""
const world_obtain_iron_pickaxe = obtain_world(:iron_pickaxe => 1,
    [1:5 => :log, 7:17 => :stone, 18:20 => :coal_ore, 22:24 => :iron_ore])
problem_obtain_iron_pickaxe = Problem("obtain_iron_pickaxe",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_obtain_iron_pickaxe), true)])

"""
    problem_obtain_diamond

MineRL's `ObtainDiamond`, the benchmark's hardest task: the whole hierarchy
from bare hands to an iron pickaxe, and only then the diamond.
"""
const world_obtain_diamond = obtain_world(:diamond => 1,
    [1:5 => :log, 7:17 => :stone, 18:20 => :coal_ore, 22:24 => :iron_ore,
        26:26 => :diamond_ore])
problem_obtain_diamond = Problem("obtain_diamond",
    [IOExample(Dict{Symbol,Any}(:_arg_1 => world_obtain_diamond), true)])

"""
    OBTAIN_COOKED_MEAT

The animal and cooked item behind each `ObtainCookedMeat` variant. MineRL has
"four variants, one per animal source"; these are they.
"""
const OBTAIN_COOKED_MEAT = [
    (:beef, :cow, :cooked_beef),
    (:porkchop, :pig, :cooked_porkchop),
    (:chicken, :chicken, :cooked_chicken),
    (:mutton, :white_sheep, :cooked_mutton),
]

"""
    OBTAIN_BED

The wool colour behind each `ObtainBed` variant -- MineRL's "three variants,
one per dye colour".
"""
const OBTAIN_BED = [
    (:white, :white_sheep, :white_wool, :white_bed),
    (:red, :red_sheep, :red_wool, :red_bed),
    (:blue, :blue_sheep, :blue_wool, :blue_bed),
]

# `ObtainCookedMeat` needs a furnace, so every variant's world carries wood for
# the pickaxe, stone for the furnace, coal for fuel, and one animal to hunt.
for (_, animal, cooked) in OBTAIN_COOKED_MEAT
    world = obtain_world(cooked => 1,
        [1:5 => :log, 7:15 => :stone, 16:17 => :coal_ore, 19:19 => animal])
    name = "obtain_$(cooked)"
    @eval const $(Symbol("world_obtain_", cooked)) = $world
    @eval $(Symbol("problem_obtain_", cooked)) = Problem($name,
        [IOExample(Dict{Symbol,Any}(:_arg_1 => $world), true)])
end

# `ObtainBed` needs three wool of one colour and three planks, so each world
# holds a small flock alongside the trees.
for (colour, animal, _, bed) in OBTAIN_BED
    world = obtain_world(bed => 1, [1:3 => :log, 5:7 => animal])
    name = "obtain_$(bed)"
    @eval const $(Symbol("world_obtain_", bed)) = $world
    @eval $(Symbol("problem_obtain_", bed)) = Problem($name,
        [IOExample(Dict{Symbol,Any}(:_arg_1 => $world), true)])
end
