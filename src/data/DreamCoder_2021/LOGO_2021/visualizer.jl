"""
Visualisers for the LOGO turtle-graphics domain.

A picture is a `LOGO_RESOLUTION`-square `Matrix{Bool}`, which is small enough
to read directly in a terminal. [`logo_ascii`](@ref) renders one,
[`logo_ascii_diff`](@ref) renders a candidate against a target — which is the
view you want when a program *nearly* works — and [`logo_svg`](@ref) exports
the underlying line segments as SVG for a proper look.
"""

"""
    logo_ascii(image; on='#', off='.') -> String

Render a picture as ASCII art, one character per pixel.

Two characters are emitted per pixel so that the aspect ratio survives the
terminal's tall character cells.

```julia
julia> print(logo_ascii(problem_002_5_gon_1l.spec[1].out))
```
"""
function logo_ascii(image::AbstractMatrix{Bool}; on::Char='#', off::Char='.')
    rows = [join([image[r, c] ? "$on$on" : "$off$off" for c in axes(image, 2)])
            for r in axes(image, 1)]
    return join(rows, '\n')
end

"""
    logo_ascii_diff(candidate, target) -> String

Render `candidate` against `target`, showing where they disagree:
`#` where both are set, `+` where only the candidate draws (too much),
`-` where only the target draws (missing), `.` where both are blank.
"""
function logo_ascii_diff(candidate::AbstractMatrix{Bool}, target::AbstractMatrix{Bool})
    size(candidate) == size(target) ||
        throw(DimensionMismatch("candidate is $(size(candidate)), target is $(size(target))"))
    glyph(c, t) = c && t ? "##" : c ? "++" : t ? "--" : ".."
    rows = [join([glyph(candidate[r, k], target[r, k]) for k in axes(target, 2)])
            for r in axes(target, 1)]
    return join(rows, '\n')
end

"""
    print_logo(image)

Print a picture as ASCII art. Convenience wrapper around [`logo_ascii`](@ref).
"""
print_logo(image::AbstractMatrix{Bool}) = println(logo_ascii(image))

"""
    logo_svg(program; size=256) -> String

Render a LOGO `program`'s actual line segments — not the rasterised bitmap —
as a standalone SVG document of `size` by `size` pixels.

This is the faithful view of a drawing: it keeps the smooth arcs that the
28x28 bitmap can only approximate. Write the result to a `.svg` file to look
at it.

```julia
julia> write("spiral.svg", logo_svg(reference_program("093_spiral")))
```
"""
function logo_svg(program::AbstractRuleNode; size::Integer=256)
    segments = center_segments(_segments_of(program))
    return logo_svg(segments; size)
end

"""
    logo_svg(segments; size=256) -> String

Render centred turtle segments as a standalone SVG document.
"""
function logo_svg(segments::AbstractVector{<:NTuple{4,Float64}}; size::Integer=256)
    scale = size / (2 * LOGO_CANVAS_HALF_EXTENT)
    # SVG's y axis points down, the turtle's points up.
    to_px(x, y) = ((x + LOGO_CANVAS_HALF_EXTENT) * scale,
        (LOGO_CANVAS_HALF_EXTENT - y) * scale)

    io = IOBuffer()
    println(io, """<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">""")
    println(io, """<rect width="$size" height="$size" fill="white"/>""")
    println(io, """<g stroke="black" stroke-width="$(0.225 * scale)" stroke-linecap="round" stroke-linejoin="round" fill="none">""")
    for (x1, y1, x2, y2) in segments
        (px1, py1) = to_px(x1, y1)
        (px2, py2) = to_px(x2, y2)
        println(io, """<line x1="$px1" y1="$py1" x2="$px2" y2="$py2"/>""")
    end
    println(io, "</g>\n</svg>")
    return String(take!(io))
end

"""
    _segments_of(program) -> Vector{NTuple{4,Float64}}

The raw segments a `program` draws, before centring and rasterisation.

`run_logo` deliberately returns a bitmap — that is what the specification
compares — so this interprets the program's `Sequence` child on its own,
yielding the turtle function, and runs it to recover the geometry the SVG
renderer needs.
"""
function _segments_of(program::AbstractRuleNode)
    get_rule(program) == 1 ||
        throw(ArgumentError("expected a program rooted at the grammar's `Start` rule"))
    sequence = interpret(only(get_children(program)), Dict{Symbol,Any}())
    return sequence(TurtleState()).segments
end
