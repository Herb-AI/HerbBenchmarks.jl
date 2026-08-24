"""
Visualisers for the 3D-Craft houses.

[`visualize`](@ref) is the entry point: give it a program and a house and it
renders the build, as an animated GIF -- one frame per action, so you watch the
house go up -- or as a single SVG of the result. [`compare`](@ref) renders a
build against its target, colouring the blocks that are wrong.

The upstream dataset ships pre-rendered PNGs for 73 of its 2,586 houses, made
offline with the Chunky path-tracer. Those show finished targets only, so they
cannot show what a synthesised program produced; hence this.
"""

"""
    BLOCK_COLORS

Colours for the Minecraft 1.12 numeric block ids 3D-Craft recorded, covering
the blocks the committed houses actually use plus the other common building
materials. Ids not listed fall back to [`fallback_color`](@ref).
"""
const BLOCK_COLORS = Dict{Int,NTuple{3,Int}}(
    1 => (125, 125, 125),    # stone
    2 => (95, 159, 53),      # grass
    3 => (134, 96, 67),      # dirt
    4 => (122, 122, 122),    # cobblestone
    5 => (176, 130, 82),     # oak planks
    7 => (40, 40, 40),       # bedrock
    8 => (63, 118, 228),     # flowing water
    9 => (63, 118, 228),     # water
    12 => (219, 207, 163),   # sand
    13 => (136, 126, 126),   # gravel
    17 => (102, 81, 50),     # oak log
    18 => (60, 143, 44),     # oak leaves
    20 => (206, 235, 242),   # glass
    22 => (30, 67, 140),     # lapis block
    24 => (216, 208, 158),   # sandstone
    26 => (168, 44, 44),     # bed
    31 => (105, 148, 62),    # tall grass
    32 => (140, 118, 84),    # dead bush
    35 => (222, 222, 222),   # wool
    38 => (200, 50, 60),     # red flower
    39 => (155, 122, 96),    # brown mushroom
    40 => (190, 60, 55),     # red mushroom
    41 => (241, 217, 88),    # gold block
    42 => (219, 219, 219),   # iron block
    43 => (163, 163, 163),   # double stone slab
    44 => (168, 168, 168),   # stone slab
    45 => (150, 97, 83),     # brick
    46 => (188, 61, 43),     # TNT
    47 => (110, 86, 55),     # bookshelf
    48 => (110, 130, 105),   # mossy cobblestone
    49 => (26, 20, 34),      # obsidian
    50 => (255, 200, 90),    # torch
    53 => (176, 130, 82),    # oak stairs
    54 => (146, 105, 51),    # chest
    57 => (98, 219, 214),    # diamond block
    64 => (140, 108, 65),    # oak door
    71 => (185, 185, 185),   # iron door
    79 => (160, 200, 245),   # ice
    81 => (73, 118, 43),     # cactus
    85 => (156, 122, 78),    # fence
    89 => (245, 226, 168),   # glowstone
    95 => (200, 200, 220),   # stained glass
    98 => (122, 122, 122),   # stone brick
    102 => (206, 235, 242),  # glass pane
    109 => (122, 122, 122),  # stone brick stairs
    112 => (44, 22, 26),     # nether brick
    125 => (176, 130, 82),   # double wooden slab
    126 => (176, 130, 82),   # wooden slab
    128 => (216, 208, 158),  # sandstone stairs
    135 => (196, 179, 123),  # birch stairs
    152 => (171, 26, 9),     # redstone block
    155 => (236, 233, 226),  # quartz block
    156 => (236, 233, 226),  # quartz stairs
    159 => (172, 130, 106),  # stained hardened clay
    160 => (200, 200, 220),  # stained glass pane
    162 => (86, 68, 39),     # dark oak / acacia log
    168 => (99, 156, 151),   # prismarine
    171 => (222, 222, 222),  # carpet
    175 => (105, 148, 62),   # double plant
    179 => (186, 99, 47),    # red sandstone
    180 => (186, 99, 47),    # red sandstone stairs
    190 => (156, 122, 78),   # jungle fence
    193 => (114, 84, 48),    # spruce door
    194 => (196, 179, 123),  # birch door
    196 => (168, 116, 71),   # acacia door
    197 => (66, 48, 27),     # dark oak door
    215 => (70, 20, 24),     # red nether brick
    238 => (110, 173, 205),  # light blue glazed terracotta
)

"""
    BLOCK_NAMES

Human-readable names for the block ids in [`BLOCK_COLORS`](@ref). Minecraft's
numeric ids are how 3D-Craft records a house, but `5` is far less use than
`oak planks` when you are reading a floor plan.
"""
const BLOCK_NAMES = Dict{Int,String}(
    1 => "stone",
    2 => "grass",
    3 => "dirt",
    4 => "cobblestone",
    5 => "oak planks",
    7 => "bedrock",
    8 => "flowing water",
    9 => "water",
    12 => "sand",
    13 => "gravel",
    17 => "oak log",
    18 => "oak leaves",
    20 => "glass",
    22 => "lapis block",
    24 => "sandstone",
    26 => "bed",
    31 => "tall grass",
    32 => "dead bush",
    35 => "wool",
    38 => "red flower",
    39 => "brown mushroom",
    40 => "red mushroom",
    41 => "gold block",
    42 => "iron block",
    43 => "double stone slab",
    44 => "stone slab",
    45 => "brick",
    46 => "TNT",
    47 => "bookshelf",
    48 => "mossy cobblestone",
    49 => "obsidian",
    50 => "torch",
    53 => "oak stairs",
    54 => "chest",
    57 => "diamond block",
    64 => "oak door",
    71 => "iron door",
    79 => "ice",
    81 => "cactus",
    85 => "fence",
    89 => "glowstone",
    95 => "stained glass",
    98 => "stone brick",
    102 => "glass pane",
    109 => "stone brick stairs",
    112 => "nether brick",
    125 => "double wooden slab",
    126 => "wooden slab",
    128 => "sandstone stairs",
    135 => "birch stairs",
    152 => "redstone block",
    155 => "quartz block",
    156 => "quartz stairs",
    159 => "stained hardened clay",
    160 => "stained glass pane",
    162 => "dark oak / acacia log",
    168 => "prismarine",
    171 => "carpet",
    175 => "double plant",
    179 => "red sandstone",
    180 => "red sandstone stairs",
    190 => "jungle fence",
    193 => "spruce door",
    194 => "birch door",
    196 => "acacia door",
    197 => "dark oak door",
    215 => "red nether brick",
    238 => "light blue glazed terracotta",
)

"""
    block_name(block) -> String

The name of a block id, falling back to `"block <id>"` for ids not in
[`BLOCK_NAMES`](@ref).
"""
block_name(block::Int) = get(BLOCK_NAMES, block, "block $block")

"""
    WRONG_COLOR

The colour [`compare`](@ref) paints a block that should not be there.
"""
const WRONG_COLOR = (230, 40, 40)

"""
    MISSING_COLOR

The colour [`compare`](@ref) paints a block that should be there and is not.
"""
const MISSING_COLOR = (60, 90, 200)

"""
    fallback_color(block) -> NTuple{3,Int}

A stable, distinct colour for a block id with no entry in
[`BLOCK_COLORS`](@ref).

Derived from the id rather than fixed, so two unlisted blocks still render as
two different materials instead of merging into one anonymous mass.
"""
function fallback_color(block::Int)
    hue = mod(block * 47, 360)
    # A cheap HSV-to-RGB at fixed saturation and value, kept muted so that a
    # fallback never out-shouts a real material.
    sector = hue / 60
    x = round(Int, 110 * (1 - abs(mod(sector, 2) - 1)))
    (r, g, b) = sector < 1 ? (110, x, 0) : sector < 2 ? (x, 110, 0) :
                sector < 3 ? (0, 110, x) : sector < 4 ? (0, x, 110) :
                sector < 5 ? (x, 0, 110) : (110, 0, x)
    return (r + 80, g + 80, b + 80)
end

"""
    canvas_scene(canvas) -> (scene, palette)

Convert a canvas into a `VoxelRender` scene and palette.

Block ids are remapped to a compact palette because a GIF's colour table only
holds three shades and an edge tone for at most 63 materials, while Minecraft's
ids run past 250.
"""
function canvas_scene(canvas::AbstractDict{NTuple{3,Int},Int})
    ids = sort!(unique(values(canvas)))
    palette = NTuple{3,Int}[get(BLOCK_COLORS, id, fallback_color(id)) for id in ids]
    index = Dict(id => i for (i, id) in enumerate(ids))
    scene = Dict{NTuple{3,Int},Int}(cell => index[id] for (cell, id) in canvas)
    return scene, palette
end

"""
    visualize(program, identifier; path=nothing, scale=10, delay_cs=12, hold=10) -> String

Render `program` building house `identifier`.

With a `path` ending in `.gif`, writes an animation with one frame per action
and returns the path; the final house is held for `hold` extra frames so a loop
pauses on the result. With a `.svg` path, writes the finished build. With no
`path`, returns the finished build's SVG as a string.

```julia
julia> visualize(reference_program("house_0001"), "house_0001"; path="house.gif")
```
"""
function visualize(program, identifier::AbstractString;
    path::Union{Nothing,AbstractString}=nothing, scale::Real=10,
    delay_cs::Integer=12, hold::Integer=10)
    body = program_function(program, identifier)
    if path !== nothing && endswith(lowercase(path), ".gif")
        states = execution_states(body)
        canvases = [copy(s.canvas) for s in states]
        append!(canvases, fill(last(canvases), max(0, hold)))

        # One palette for the whole animation, built over the final canvas,
        # which contains every block type any frame can show.
        ids = sort!(unique(values(last(canvases))))
        palette = NTuple{3,Int}[get(BLOCK_COLORS, id, fallback_color(id)) for id in ids]
        index = Dict(id => i for (i, id) in enumerate(ids))
        scenes = [Dict{NTuple{3,Int},Int}(cell => index[id]
                                          for (cell, id) in canvas if haskey(index, id))
                  for canvas in canvases]
        return VoxelRender.voxel_gif(path, scenes, palette; scale=scale, delay_cs=delay_cs)
    end

    (scene, palette) = canvas_scene(build_house(body, HouseState()))
    svg = VoxelRender.voxel_svg(scene, palette; scale=scale)
    path === nothing && return svg
    write(path, svg)
    return path
end

"""
    visualize(identifier; path=nothing, scale=14) -> String

Render a house's target, without running anything.
"""
function visualize(identifier::AbstractString;
    path::Union{Nothing,AbstractString}=nothing, scale::Real=14)
    (scene, palette) = canvas_scene(HOUSE_TARGETS[identifier])
    svg = VoxelRender.voxel_svg(scene, palette; scale=scale)
    path === nothing && return svg
    write(path, svg)
    return path
end

"""
    compare(built, identifier; path=nothing, scale=14) -> String

Render a build against its target, with correct blocks in their own colours,
wrong ones in red, and missing ones in blue.

This is the view you want when a program *nearly* works: an exact-match failure
tells you nothing about where the house went wrong, and this tells you at a
glance.
"""
function compare(built::AbstractDict{NTuple{3,Int},Int}, identifier::AbstractString;
    path::Union{Nothing,AbstractString}=nothing, scale::Real=14)
    target = HOUSE_TARGETS[identifier]

    ids = sort!(unique([collect(values(built)); collect(values(target))]))
    palette = NTuple{3,Int}[get(BLOCK_COLORS, id, fallback_color(id)) for id in ids]
    index = Dict(id => i for (i, id) in enumerate(ids))
    push!(palette, WRONG_COLOR)
    wrong = length(palette)
    push!(palette, MISSING_COLOR)
    missing_index = length(palette)

    scene = Dict{NTuple{3,Int},Int}()
    for (cell, id) in built
        scene[cell] = get(target, cell, nothing) == id ? index[id] : wrong
    end
    for (cell, id) in target
        haskey(built, cell) || (scene[cell] = missing_index)
    end

    svg = VoxelRender.voxel_svg(scene, palette; scale=scale)
    path === nothing && return svg
    write(path, svg)
    return path
end

"""
    compare(program::AbstractRuleNode, identifier; kwargs...)

Interpret `program` and compare what it builds against the target.
"""
compare(program, identifier::AbstractString; kwargs...) =
    compare(canvas_of(program, identifier), identifier; kwargs...)

"""
    block_glyphs(canvas) -> Dict{Int,Char}

Assign each block type in a canvas a letter, `a` onwards, in ascending id
order.

Assigned over the whole canvas rather than per layer, so a block keeps the same
letter as you read up through the storeys.
"""
block_glyphs(canvas::AbstractDict{NTuple{3,Int},Int}) =
    Dict(id => 'a' + (i - 1) for (i, id) in enumerate(sort!(unique(values(canvas)))))

"""
    house_legend(canvas) -> String

What each letter in [`house_ascii`](@ref) stands for.

```julia
julia> house_legend(HOUSE_TARGETS["house_0030"])
"a = oak planks, b = glass"
```
"""
house_legend(canvas::AbstractDict{NTuple{3,Int},Int}) =
    join(("$glyph = $(block_name(id))" for (id, glyph) in sort!(collect(block_glyphs(canvas)))), ", ")

"""
    house_ascii(canvas; y=nothing, glyphs=block_glyphs(canvas)) -> String

A top-down plan of one layer of a canvas, one letter per cell and `.` for
empty.

Defaults to the lowest layer, which for most of these houses is the floor plan.
Pass `glyphs` to keep lettering consistent across canvases -- comparing a build
against its target, say. [`house_legend`](@ref) spells the letters out.
"""
function house_ascii(canvas::AbstractDict{NTuple{3,Int},Int};
    y::Union{Nothing,Int}=nothing, glyphs::AbstractDict{Int,Char}=block_glyphs(canvas))
    isempty(canvas) && return "(empty)"
    layer = y === nothing ? minimum(cell[2] for cell in keys(canvas)) : y
    cells = [cell for cell in keys(canvas) if cell[2] == layer]
    isempty(cells) && return "(empty layer $layer)"

    xs = extrema(cell[1] for cell in cells)
    zs = extrema(cell[3] for cell in cells)
    glyph(cell) = haskey(canvas, cell) ? get(glyphs, canvas[cell], '?') : '.'
    rows = [String([glyph((x, layer, z)) for x in xs[1]:xs[2]]) for z in zs[1]:zs[2]]
    return join(rows, '\n')
end

"""
    print_house(canvas; y=nothing)

Print a top-down plan of one layer. Convenience wrapper around
[`house_ascii`](@ref).
"""
print_house(canvas::AbstractDict{NTuple{3,Int},Int}; y::Union{Nothing,Int}=nothing) =
    println(house_ascii(canvas; y=y))
