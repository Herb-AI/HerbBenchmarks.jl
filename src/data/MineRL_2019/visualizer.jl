"""
Visualisers for the MineRL domain.

[`visualize`](@ref) is the entry point: give it a program and a problem and it
renders the agent carrying that program out, as an animated GIF -- one frame
per action -- or as a single SVG of the final world. [`world_ascii`](@ref)
prints a layer-by-layer text view when a file is more ceremony than the
question deserves.
"""

"""
    BLOCK_COLORS

The colour each block renders in, loosely Minecraft's own palette. Blocks not
listed here fall back to magenta, which makes an omission obvious rather than
invisible.
"""
const BLOCK_COLORS = Dict{Symbol,NTuple{3,Int}}(
    :bedrock => (60, 60, 60),
    :stone => (128, 128, 128),
    :cobblestone => (110, 110, 110),
    :dirt => (134, 96, 67),
    :grass => (95, 159, 53),
    :sand => (219, 207, 163),
    :log => (102, 81, 50),
    :leaves => (60, 143, 44),
    :planks => (176, 130, 82),
    :water => (63, 118, 228),
    :torch => (255, 200, 90),
    :coal_ore => (54, 54, 54),
    :iron_ore => (197, 152, 118),
    :diamond_ore => (95, 219, 213),
    :cow => (89, 62, 46),
    :pig => (232, 152, 158),
    :chicken => (233, 233, 233),
    :white_sheep => (240, 240, 240),
    :red_sheep => (176, 60, 52),
    :blue_sheep => (60, 90, 176),
)

"""
    AGENT_COLOR

The colour of the agent's two body cells, chosen to stand out against terrain.
"""
const AGENT_COLOR = (222, 60, 120)

"""
    GOAL_COLOR

The colour of the Navigate goal marker.
"""
const GOAL_COLOR = (250, 220, 40)

"""
    MISSING_COLOR

Fallback for a block with no entry in [`BLOCK_COLORS`](@ref).
"""
const MISSING_COLOR = (255, 0, 255)

"""
    ScenePalette

A fixed assignment of colours to block names, plus the two indices reserved for
the agent and the Navigate goal.

An animation's frames must share one palette, and a world's block set is *not*
stable across a run -- mining removes block types and `place_forward` can
introduce ones the terrain never had. So the palette is built once, over every
frame, and every frame is then indexed against it.
"""
struct ScenePalette
    index::Dict{Symbol,Int}
    colors::Vector{NTuple{3,Int}}
    goal::Int
    agent::Int
end

"""
    ScenePalette(worlds) -> ScenePalette

Build a palette covering every block appearing in any of `worlds`.
"""
function ScenePalette(worlds)
    names = Symbol[]
    for w in worlds, name in values(w.blocks)
        name in names || push!(names, name)
    end
    sort!(names)

    colors = NTuple{3,Int}[get(BLOCK_COLORS, name, MISSING_COLOR) for name in names]
    index = Dict(name => i for (i, name) in enumerate(names))
    push!(colors, GOAL_COLOR)
    push!(colors, AGENT_COLOR)
    return ScenePalette(index, colors, length(colors) - 1, length(colors))
end

"""
    world_scene(world, palette; show_agent=true, show_goal=true) -> Dict

Convert a [`MineWorld`](@ref) into a `VoxelRender` scene indexed against
`palette`.

The agent occupies two cells and is drawn over whatever is there, so it stays
visible inside a tunnel or standing in water. The goal marker is drawn only
where it would not hide the agent.
"""
function world_scene(w::MineWorld, palette::ScenePalette;
    show_agent::Bool=true, show_goal::Bool=true)
    scene = Dict{NTuple{3,Int},Int}(cell => palette.index[name] for (cell, name) in w.blocks)
    if show_goal && w.objective.first === :reach_goal && !(show_agent && w.pos == w.goal)
        scene[w.goal] = palette.goal
    end
    if show_agent
        scene[w.pos] = palette.agent
        scene[w.pos.+(0, 1, 0)] = palette.agent
    end
    return scene
end

"""
    world_scene(world) -> (scene, colors)

Convert a single world, building a palette just for it.
"""
function world_scene(w::MineWorld; kwargs...)
    palette = ScenePalette((w,))
    return world_scene(w, palette; kwargs...), palette.colors
end

"""
    program_function(program) -> Function

The composed `MineWorld -> MineWorld` function a program denotes.

Interpreting a whole program runs it and hands back a `Bool`, which is no use
to anything that wants to watch it happen. Interpreting the `Sequence`
underneath the `Start` rule yields the function instead, which can then be run
under any budget. Already-interpreted functions pass through.
"""
program_function(program::AbstractRuleNode) =
    interpret(get_rule(program) == 1 ? only(get_children(program)) : program,
        Dict{Symbol,Any}())
program_function(program) = program

"""
    with_budget(world, budget) -> MineWorld

A copy of `world` allowed only `budget` actions.
"""
function with_budget(w::MineWorld, budget::Int)
    limited = copy(w)
    limited.budget = budget
    return limited
end

"""
    actions_used(program, world) -> Int

How many actions `program` actually spends on `world`.
"""
actions_used(program, w::MineWorld) = w.budget - final_world(program, w).budget

"""
    execution_frames(program, world) -> Vector{MineWorld}

The world after each action `program` takes, starting from the untouched world.

Rather than instrument the primitives, this re-runs the program under a
tightened action budget: a program allowed `k` actions is by construction the
program stopped after `k` actions. It costs a handful of extra runs of a very
cheap interpreter and keeps the world model free of any tracing machinery.
"""
function execution_frames(program, w::MineWorld)
    total = actions_used(program, w)
    return [final_world(program, with_budget(w, k)) for k in 0:total]
end

"""
    visualize(program, problem; path=nothing, scale=8, delay_cs=18, hold=8) -> String

Render `program` running on `problem`'s world.

With a `path` ending in `.gif`, writes an animation with one frame per action
and returns the path; the last frame is held for `hold` extra frames so a loop
pauses on the result. With a `.svg` path, writes the final world instead. With
no `path`, returns the final world's SVG as a string.

```julia
julia> visualize(reference_program("obtain_diamond"),
                 get_problem(MineRL_2019, "obtain_diamond"); path="diamond.gif")
```
"""
function visualize(program, problem::Problem; path::Union{Nothing,AbstractString}=nothing,
    scale::Real=8, delay_cs::Integer=18, hold::Integer=8)
    return visualize(program, problem.spec[1].in[:_arg_1];
        path=path, scale=scale, delay_cs=delay_cs, hold=hold)
end

function visualize(program, world::MineWorld; path::Union{Nothing,AbstractString}=nothing,
    scale::Real=8, delay_cs::Integer=18, hold::Integer=8)
    body = program_function(program)
    if path !== nothing && endswith(lowercase(path), ".gif")
        frames = execution_frames(body, world)
        append!(frames, fill(last(frames), max(0, hold)))
        palette = ScenePalette(frames)
        scenes = [world_scene(frame, palette) for frame in frames]
        return VoxelRender.voxel_gif(path, scenes, palette.colors; scale=scale, delay_cs=delay_cs)
    end

    (scene, palette) = world_scene(final_world(body, world))
    svg = VoxelRender.voxel_svg(scene, palette; scale=scale)
    path === nothing && return svg
    write(path, svg)
    return path
end

"""
    visualize(world; path=nothing, scale=16) -> String

Render a world as it stands, without running anything.
"""
function visualize(world::MineWorld; path::Union{Nothing,AbstractString}=nothing, scale::Real=16)
    (scene, palette) = world_scene(world)
    svg = VoxelRender.voxel_svg(scene, palette; scale=scale)
    path === nothing && return svg
    write(path, svg)
    return path
end

"""
    world_ascii(world; z=0) -> String

A side-on slice of the world at depth `z`, one character per cell, with the
agent shown as `A` and the Navigate goal as `G`.

Useful in a terminal or a failing test, where writing a file is overkill.
"""
function world_ascii(w::MineWorld; z::Int=0)
    cells = [cell for cell in keys(w.blocks) if cell[3] == z]
    isempty(cells) && return "(empty slice)"
    xs = extrema(cell[1] for cell in cells)
    ys = extrema(cell[2] for cell in cells)
    top = max(ys[2], w.pos[2] + 1)

    glyph(cell) =
        cell == w.pos || cell == w.pos .+ (0, 1, 0) ? 'A' :
        (w.objective.first === :reach_goal && cell == w.goal) ? 'G' :
        haskey(w.blocks, cell) ? first(uppercase(string(w.blocks[cell]))) : '.'

    rows = [String([glyph((x, y, z)) for x in xs[1]:xs[2]]) for y in top:-1:ys[1]]
    return join(rows, '\n')
end

"""
    print_world(world; z=0)

Print a side-on slice of the world. Convenience wrapper around
[`world_ascii`](@ref).
"""
print_world(w::MineWorld; z::Int=0) = println(world_ascii(w; z=z))

"""
    inventory_summary(world) -> String

The agent's inventory as a single readable line, sorted by item name.
"""
function inventory_summary(w::MineWorld)
    isempty(w.inventory) && return "(empty)"
    return join(("$item x$(count)" for (item, count) in sort!(collect(w.inventory), by=first)), ", ")
end
