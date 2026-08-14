"""
Visualisers for the block-tower domain.

A tower is a list of settled blocks `(x, y, w, h)`, where `x`/`y` are the block
*centre* and `w`/`h` are doubled dimensions (so every edge falls on an integer
coordinate). [`tower_grid`](@ref) rasterises that into a matrix and
[`tower_ascii`](@ref) renders the matrix as text, which is enough to eyeball a
target or a candidate program's output in a terminal or a test failure.
"""

"""
    tower_grid(blocks) -> Matrix{Int}

Rasterise a settled tower into a matrix of block indices, `0` for empty space.

Row `1` is the top of the tower and the last row sits on the ground, so the
matrix reads the same way up as the tower does. Blocks are numbered by their
position in `blocks`, which lets a renderer colour them individually; later
blocks overwrite earlier ones where they overlap.
"""
function tower_grid(blocks::AbstractVector{<:NTuple{4,Int}})
    isempty(blocks) && return zeros(Int, 0, 0)

    x_lo = minimum(x - w ÷ 2 for (x, _, w, _) in blocks)
    x_hi = maximum(x + w ÷ 2 for (x, _, w, _) in blocks)
    y_hi = maximum(y + h ÷ 2 for (_, y, _, h) in blocks)

    grid = zeros(Int, y_hi, x_hi - x_lo)
    for (i, (x, y, w, h)) in enumerate(blocks)
        for gx in (x-w÷2):(x+w÷2-1), gy in (y-h÷2):(y+h÷2-1)
            # Column 1 is x_lo; row 1 is the top, so flip y.
            grid[y_hi-gy, gx-x_lo+1] = i
        end
    end
    return grid
end

"""
    tower_ascii(blocks; empty=' ', ground='=') -> String

Render a settled tower as ASCII art, one character per grid cell, with a
ground line underneath.

Blocks are drawn with `#`, except that adjacent blocks alternate between `#`
and `%` so that the seams between them stay visible.

```julia
julia> print(tower_ascii(problem_000_arch_leg_1.spec[1].out))
```
"""
function tower_ascii(blocks::AbstractVector{<:NTuple{4,Int}}; empty::Char=' ', ground::Char='=')
    grid = tower_grid(blocks)
    isempty(grid) && return string(ground)^3

    glyph(i) = i == 0 ? empty : (isodd(i) ? '#' : '%')
    rows = [String([glyph(grid[r, c]) for c in axes(grid, 2)]) for r in axes(grid, 1)]
    push!(rows, string(ground)^size(grid, 2))
    return join(rows, '\n')
end

"""
    print_tower(blocks)

Print a settled tower as ASCII art. Convenience wrapper around
[`tower_ascii`](@ref).
"""
print_tower(blocks::AbstractVector{<:NTuple{4,Int}}) = println(tower_ascii(blocks))
