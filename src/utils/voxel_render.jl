"""
    VoxelRender

Isometric rendering for voxel worlds, shared by the Minecraft benchmarks.

Neither upstream project offers anything reusable here: MineRL's frames come
out of the Minecraft simulator itself, and CraftAssist's `plot_voxels.py` is a
torch/matplotlib/visdom scatter plot. So this module draws voxels directly, in
plain Julia, with no dependencies -- [`voxel_svg`](@ref) for a crisp still and
[`voxel_gif`](@ref) for a build animation.

A *scene* is a `Dict{NTuple{3,Int},Int}` mapping an integer `(x, y, z)` cell to
a palette index, with `y` pointing up, matching Minecraft's own convention. A
*palette* is a `Vector{NTuple{3,Int}}` of RGB triples indexed by those values.
"""
module VoxelRender

include("gif.jl")

export voxel_svg, voxel_gif, voxel_raster, raster_canvas, write_gif,
    paint_order, scene_bounds, iso_project, shade

# Screen offsets of one step along each world axis, in units of the tile size.
# Together they give the standard 2:1-ish isometric view: +x goes down-right,
# +z goes down-left, +y goes straight up.
const ISO_DX = (0.866, 0.5)
const ISO_DZ = (-0.866, 0.5)
const ISO_DY = (0.0, -1.0)

# Relative brightness of the three visible faces, plus the darker tone used to
# outline them. Without the outline, neighbouring voxels of one colour merge
# into a single silhouette and the model stops reading as blocks.
const FACE_SHADES = (top=1.0, right=0.78, left=0.58, edge=0.34)

"""
    iso_project(x, y, z, scale) -> (px, py)

Project a world-space corner onto the screen. `scale` is the on-screen size of
one voxel in pixels; the result is unshifted, so callers add their own origin.
"""
iso_project(x::Real, y::Real, z::Real, scale::Real) =
    (scale * (ISO_DX[1] * x + ISO_DY[1] * y + ISO_DZ[1] * z),
        scale * (ISO_DX[2] * x + ISO_DY[2] * y + ISO_DZ[2] * z))

"""
    visible_faces(x, y, z, scale) -> NamedTuple

The three faces of the voxel at `(x, y, z)` that the isometric camera can see,
each as a four-corner polygon in screen space.

The camera looks down the `(-1, -1, -1)` direction, so the top, `+x` and `+z`
faces are the visible ones.
"""
function visible_faces(x::Int, y::Int, z::Int, scale::Real)
    P(dx, dy, dz) = iso_project(x + dx, y + dy, z + dz, scale)
    return (
        top=(P(0, 1, 0), P(1, 1, 0), P(1, 1, 1), P(0, 1, 1)),
        right=(P(1, 0, 0), P(1, 1, 0), P(1, 1, 1), P(1, 0, 1)),
        left=(P(0, 0, 1), P(0, 1, 1), P(1, 1, 1), P(1, 0, 1)),
    )
end

"""
    paint_order(scene) -> Vector{NTuple{3,Int}}

The cells of `scene` sorted back-to-front for the painter's algorithm.

Under this projection a cell is occluded only by cells with a larger `x + y + z`,
so drawing in ascending order of that sum lets nearer voxels overwrite farther
ones. Ties are broken on the raw coordinates to keep rendering deterministic.
"""
paint_order(scene::AbstractDict{NTuple{3,Int},Int}) =
    sort!(collect(keys(scene)), by=c -> (c[1] + c[2] + c[3], c[1], c[2], c[3]))

"""
    scene_bounds(scene, scale) -> (min_px, min_py, max_px, max_py)

The screen-space bounding box of every drawn face in `scene`.
"""
function scene_bounds(scene::AbstractDict{NTuple{3,Int},Int}, scale::Real)
    isempty(scene) && return (0.0, 0.0, 0.0, 0.0)
    lo_x = lo_y = Inf
    hi_x = hi_y = -Inf
    for (x, y, z) in keys(scene)
        faces = visible_faces(x, y, z, scale)
        for face in (faces.top, faces.right, faces.left), (px, py) in face
            lo_x = min(lo_x, px); hi_x = max(hi_x, px)
            lo_y = min(lo_y, py); hi_y = max(hi_y, py)
        end
    end
    return (lo_x, lo_y, hi_x, hi_y)
end

"""
    shade(rgb, factor) -> NTuple{3,Int}

Scale an RGB triple's brightness, clamped to a valid byte range.
"""
shade(rgb::NTuple{3,Integer}, factor::Real) =
    ntuple(i -> clamp(round(Int, rgb[i] * factor), 0, 255), 3)

"""
    voxel_svg(scene, palette; scale=16, margin=8, background="#ffffff") -> String

Render `scene` as a standalone SVG document.

The viewBox is fitted to the model, so the output is the same size whatever
corner of the world the voxels sit in. Write the result to a `.svg` file to
look at it.

```julia
julia> write("house.svg", voxel_svg(scene, palette))
```
"""
function voxel_svg(scene::AbstractDict{NTuple{3,Int},Int},
    palette::AbstractVector{<:NTuple{3,Integer}};
    scale::Real=16, margin::Real=8, background::AbstractString="#ffffff")
    (lo_x, lo_y, hi_x, hi_y) = scene_bounds(scene, scale)
    width = max(1.0, hi_x - lo_x) + 2margin
    height = max(1.0, hi_y - lo_y) + 2margin

    io = IOBuffer()
    print(io, """<svg xmlns="http://www.w3.org/2000/svg" width="$(round(width, digits=2))" """)
    println(io, """height="$(round(height, digits=2))" viewBox="0 0 $(round(width, digits=2)) $(round(height, digits=2))">""")
    println(io, """<rect width="100%" height="100%" fill="$background"/>""")

    hex(rgb) = "#" * join(lpad(string(c, base=16), 2, '0') for c in rgb)
    points(face) = join(("$(round(px - lo_x + margin, digits=2)),$(round(py - lo_y + margin, digits=2))"
                         for (px, py) in face), ' ')

    for cell in paint_order(scene)
        rgb = palette[scene[cell]]
        faces = visible_faces(cell..., scale)
        stroke = hex(shade(rgb, FACE_SHADES.edge))
        for name in (:left, :right, :top)
            fill = hex(shade(rgb, getfield(FACE_SHADES, name)))
            println(io, """<polygon points="$(points(getfield(faces, name)))" fill="$fill" stroke="$stroke" stroke-width="0.5"/>""")
        end
    end

    println(io, "</svg>")
    return String(take!(io))
end

"""
    voxel_raster(scene, palette; scale=8, margin=4, canvas=nothing) -> (indices, gif_palette)

Rasterise `scene` into a `Matrix{UInt8}` of indices into the returned GIF
palette, which holds a background colour followed by three shades of every
`palette` entry.

Pass `canvas` -- a `(lo_x, lo_y, width, height)` tuple from
[`raster_canvas`](@ref) -- to pin the framing, which is what keeps an
animation's frames registered against each other instead of drifting as the
model grows.
"""
function voxel_raster(scene::AbstractDict{NTuple{3,Int},Int},
    palette::AbstractVector{<:NTuple{3,Integer}};
    scale::Real=8, margin::Real=4, canvas=nothing,
    background::NTuple{3,Integer}=(255, 255, 255))
    4 * length(palette) + 1 <= 256 ||
        throw(ArgumentError("a GIF palette holds 256 colours, and each block colour needs " *
                            "three face shades plus an edge, so at most 63 block colours; " *
                            "got $(length(palette))"))

    (lo_x, lo_y, width, height) = canvas === nothing ?
                                  raster_canvas(scene, palette; scale=scale, margin=margin) : canvas

    gif_palette = NTuple{3,Int}[background]
    for rgb in palette, name in (:top, :right, :left, :edge)
        push!(gif_palette, shade(rgb, getfield(FACE_SHADES, name)))
    end

    (origin_x, origin_y) = (lo_x - margin, lo_y - margin)
    pixels = fill(UInt8(1), height, width)
    for cell in paint_order(scene)
        faces = visible_faces(cell..., scale)
        base = 1 + 4 * (scene[cell] - 1)
        edge = UInt8(base + 4)
        for (offset, name) in enumerate((:top, :right, :left))
            quad = getfield(faces, name)
            _fill_quad!(pixels, quad, UInt8(base + offset), origin_x, origin_y)
            _stroke_quad!(pixels, quad, edge, origin_x, origin_y)
        end
    end
    return pixels, gif_palette
end

"""
    raster_canvas(scene, palette; scale=8, margin=4) -> (lo_x, lo_y, width, height)

The framing [`voxel_raster`](@ref) would choose for `scene`, so that a caller
can compute it once over a final model and reuse it for every frame.
"""
function raster_canvas(scene::AbstractDict{NTuple{3,Int},Int},
    ::AbstractVector{<:NTuple{3,Integer}}; scale::Real=8, margin::Real=4)
    (lo_x, lo_y, hi_x, hi_y) = scene_bounds(scene, scale)
    return (lo_x, lo_y,
        max(1, ceil(Int, hi_x - lo_x + 2margin)),
        max(1, ceil(Int, hi_y - lo_y + 2margin)))
end

"""
    _fill_quad!(pixels, quad, value, origin_x, origin_y)

Scanline-fill a convex quadrilateral given in screen space.

Each raster row is filled between the leftmost and rightmost intersections of
the row's centre line with the quad's edges, which for a convex polygon is
exactly its interior.
"""
function _fill_quad!(pixels::Matrix{UInt8}, quad::NTuple{4,Tuple{Float64,Float64}},
    value::UInt8, origin_x::Real, origin_y::Real)
    height, width = size(pixels)
    xs = ntuple(i -> quad[i][1] - origin_x, 4)
    ys = ntuple(i -> quad[i][2] - origin_y, 4)

    row_lo = max(1, ceil(Int, minimum(ys) + 0.5))
    row_hi = min(height, floor(Int, maximum(ys) + 0.5))

    for row in row_lo:row_hi
        # Sample at the pixel centre; rows are 1-based, so row `r` covers
        # [r-1, r) in continuous coordinates and its centre is r - 0.5.
        y = row - 0.5
        left = Inf
        right = -Inf
        for i in 1:4
            j = i == 4 ? 1 : i + 1
            (y1, y2) = (ys[i], ys[j])
            (y1 == y2) && continue
            ((y < min(y1, y2)) || (y >= max(y1, y2))) && continue
            x = xs[i] + (y - y1) * (xs[j] - xs[i]) / (y2 - y1)
            left = min(left, x)
            right = max(right, x)
        end
        left > right && continue

        col_lo = max(1, ceil(Int, left + 0.5))
        col_hi = min(width, floor(Int, right + 0.5))
        for col in col_lo:col_hi
            pixels[row, col] = value
        end
    end
    return pixels
end

"""
    _stroke_quad!(pixels, quad, value, origin_x, origin_y)

Outline a quadrilateral by drawing its four edges with Bresenham's algorithm.
"""
function _stroke_quad!(pixels::Matrix{UInt8}, quad::NTuple{4,Tuple{Float64,Float64}},
    value::UInt8, origin_x::Real, origin_y::Real)
    for i in 1:4
        j = i == 4 ? 1 : i + 1
        _draw_line!(pixels,
            round(Int, quad[i][1] - origin_x + 0.5), round(Int, quad[i][2] - origin_y + 0.5),
            round(Int, quad[j][1] - origin_x + 0.5), round(Int, quad[j][2] - origin_y + 0.5),
            value)
    end
    return pixels
end

"""
    _draw_line!(pixels, col1, row1, col2, row2, value)

Bresenham line, clipped to the raster.
"""
function _draw_line!(pixels::Matrix{UInt8}, col1::Int, row1::Int, col2::Int, row2::Int, value::UInt8)
    (height, width) = size(pixels)
    dcol = abs(col2 - col1)
    drow = -abs(row2 - row1)
    step_col = col1 < col2 ? 1 : -1
    step_row = row1 < row2 ? 1 : -1
    err = dcol + drow
    (col, row) = (col1, row1)
    while true
        (1 <= row <= height && 1 <= col <= width) && (pixels[row, col] = value)
        (col == col2 && row == row2) && break
        twice = 2err
        if twice >= drow
            err += drow
            col += step_col
        end
        if twice <= dcol
            err += dcol
            row += step_row
        end
    end
    return pixels
end

"""
    voxel_gif(path, scenes, palette; scale=8, margin=4, delay_cs=20) -> path

Write a sequence of voxel `scenes` to `path` as an animated GIF.

Every frame is drawn in the framing of the *largest* scene, so a build
animation grows in place rather than jittering as its bounding box expands.

```julia
julia> voxel_gif("build.gif", build_frames(program), palette)
```
"""
function voxel_gif(path::AbstractString,
    scenes::AbstractVector{<:AbstractDict{NTuple{3,Int},Int}},
    palette::AbstractVector{<:NTuple{3,Integer}};
    scale::Real=8, margin::Real=4, delay_cs::Integer=20,
    background::NTuple{3,Integer}=(255, 255, 255))
    isempty(scenes) && throw(ArgumentError("a GIF needs at least one scene"))

    # Union of every frame, purely to fix a canvas that contains them all.
    extent = Dict{NTuple{3,Int},Int}()
    for scene in scenes, (cell, value) in scene
        extent[cell] = value
    end
    canvas = raster_canvas(extent, palette; scale=scale, margin=margin)

    frames = Matrix{UInt8}[]
    gif_palette = NTuple{3,Int}[]
    for scene in scenes
        (pixels, gif_palette) = voxel_raster(scene, palette;
            scale=scale, margin=margin, canvas=canvas, background=background)
        push!(frames, pixels)
    end
    return write_gif(path, frames, gif_palette; delay_cs=delay_cs)
end

end # module VoxelRender
