"""
Primitives for DreamCoder's LOGO turtle-graphics domain.

A program steers a pen across a canvas; the task is to reproduce a target
picture. This ports the surface language of `parseLogo` in
`dreamcoder/domains/logo/makeLogoTasks.py` together with the turtle semantics
of `solvers/logoLib/logoInterpreter.ml`.

As in [`Tower_2021`](@ref), every operation denotes a **function from
`TurtleState` to `TurtleState`**, and programs compose those functions with
[`seq`](@ref), [`logo_loop`](@ref), [`logo_embed`](@ref) and
[`pen_toggle`](@ref). That keeps the grammar first-order while still letting a
loop run its body more than once.

Angles are measured in **whole turns**, matching DreamCoder: `unit_angle` is
`1.0` and a full circle, so an `n`-gon turns by `div_angle(unit_angle, n)` at
each corner.
"""

# Constants from `solvers/program.ml`.

"""
    unit_angle

DreamCoder's `logo_UA`: one whole turn.
"""
const unit_angle = 1.0

"""
    zero_angle

DreamCoder's `logo_ZA`: no turn.
"""
const zero_angle = 0.0

"""
    eps_angle

DreamCoder's `logo_epsA`: the small turn used to approximate curves.
"""
const eps_angle = 0.025

"""
    unit_length

DreamCoder's `logo_UL`: the unit step.
"""
const unit_length = 1.0

"""
    zero_length

DreamCoder's `logo_ZL`: no step. Moving zero distance with the pen down still
marks the canvas, exactly as in the original renderer.
"""
const zero_length = 0.0

"""
    eps_length

DreamCoder's `logo_epsL`: the small step used to approximate curves.
"""
const eps_length = 0.05

"""
    LOGO_INFINITY

DreamCoder's `logo_IFTY`, the loop count that stands in for "go round and
round": 20 iterations. Twenty `eps_angle` turns make half a circle, which is
why the `infinity` loops in the task set draw arcs.
"""
const LOGO_INFINITY = 20

"""
    LOGO_RESOLUTION

Side length of the rendered image, matching the 28x28 bitmaps DreamCoder
trains its recognition model on.
"""
const LOGO_RESOLUTION = 28

"""
    LOGO_CANVAS_HALF_EXTENT

Half-width of the canvas in turtle coordinates. From
`solvers/logoLib/VGWrapper.ml`: the drawing is centred on the origin and the
canvas spans `[-4.5, 4.5]` on both axes. Because the canvas is *not* rescaled
to fit, size is part of what a picture specifies — a large triangle and a
small one are different tasks.
"""
const LOGO_CANVAS_HALF_EXTENT = 4.5

"""
    TurtleState(x, y, heading, pen_down, segments)

Pen position, heading (in turns), whether the pen is down, and the line
segments drawn so far.
"""
struct TurtleState
    x::Float64
    y::Float64
    heading::Float64
    pen_down::Bool
    segments::Vector{NTuple{4,Float64}}
end

TurtleState() = TurtleState(0.0, 0.0, 0.0, true, NTuple{4,Float64}[])

"""
    move(length, angle)

The operation that steps `length` forward along the current heading — drawing
if the pen is down — and then turns by `angle`. DreamCoder's `logo_FWRT`.
"""
function move(length::Real, angle::Real)
    return function (s::TurtleState)
        # Grouped as `(heading * 2) * π` to match the original interpreter's
        # `s.t *. 2. *. pi`; the other grouping rounds differently and can
        # flip a pixel at a cell boundary.
        x2 = s.x + length * cos(s.heading * 2 * π)
        y2 = s.y + length * sin(s.heading * 2 * π)
        segments = s.pen_down ? vcat(s.segments, [(s.x, s.y, x2, y2)]) : s.segments
        return TurtleState(x2, y2, s.heading + angle, s.pen_down, segments)
    end
end

"""
    seq(f, g)

Run operation `f`, then operation `g`.
"""
seq(f, g) = s::TurtleState -> g(f(s))

"""
    logo_loop(n, body)

Run `body` `n` times. DreamCoder's `logo_forLoop` also passes the iteration
index to the body; a context-free grammar cannot bind that index, so this loop
is a plain repetition and the reference solutions that used the index are
stored unrolled.
"""
function logo_loop(n::Integer, body)
    return function (s::TurtleState)
        for _ in 1:n
            s = body(s)
        end
        return s
    end
end

"""
    logo_embed(body)

Run `body`, then restore the pen's position, heading and up/down state,
keeping whatever was drawn. DreamCoder's `logo_GETSET`.
"""
logo_embed(body) =
    s::TurtleState -> TurtleState(s.x, s.y, s.heading, s.pen_down, body(s).segments)

"""
    pen_toggle(body)

Run `body` with the pen flipped — up if it was down — and restore it
afterwards. DreamCoder's `logo_PT`; since the pen starts down, `pen_toggle`
is how a program moves without drawing.
"""
function pen_toggle(body)
    return function (s::TurtleState)
        lifted = TurtleState(s.x, s.y, s.heading, !s.pen_down, s.segments)
        after = body(lifted)
        return TurtleState(after.x, after.y, after.heading, s.pen_down, after.segments)
    end
end

# Arithmetic on lengths and angles: DreamCoder's DIVA/MULA/ADDA/SUBA and
# DIVL/MULL. Scaling is always by an integer.

"""
    div_angle(a, n)

`a / n`. DreamCoder's `logo_DIVA`.
"""
div_angle(a::Real, n::Integer) = a / n

"""
    mul_angle(a, n)

`a * n`. DreamCoder's `logo_MULA`.
"""
mul_angle(a::Real, n::Integer) = a * n

"""
    add_angle(a, b)

`a + b`. DreamCoder's `logo_ADDA`.
"""
add_angle(a::Real, b::Real) = a + b

"""
    sub_angle(a, b)

`a - b`. DreamCoder's `logo_SUBA`.
"""
sub_angle(a::Real, b::Real) = a - b

"""
    div_length(l, n)

`l / n`. DreamCoder's `logo_DIVL`.
"""
div_length(l::Real, n::Integer) = l / n

"""
    mul_length(l, n)

`l * n`. DreamCoder's `logo_MULL`.
"""
mul_length(l::Real, n::Integer) = l * n

"""
    center_segments(segments)

Translate a drawing so that its bounding box is centred on the origin, which
makes a picture independent of where the pen happened to start. Port of
`center_logo_list`.
"""
function center_segments(segments::AbstractVector{<:NTuple{4,Float64}})
    isempty(segments) && return NTuple{4,Float64}[]
    xs = [v for s in segments for v in (s[1], s[3])]
    ys = [v for s in segments for v in (s[2], s[4])]
    dx = (maximum(xs) - minimum(xs)) / 2 + minimum(xs)
    dy = (maximum(ys) - minimum(ys)) / 2 + minimum(ys)
    return [(x1 - dx, y1 - dy, x2 - dx, y2 - dy) for (x1, y1, x2, y2) in segments]
end

"""
    rasterize(segments) -> Matrix{Bool}

Rasterise centred segments onto a `LOGO_RESOLUTION`-square bitmap, row 1 at
the top.

Each segment is walked in steps of a third of a pixel and the pixel containing
each step is set. That draws a connected one-pixel-wide line without needing
an anti-aliasing model, so two programs drawing the same picture always
produce the same bitmap. Anything outside the canvas is clipped.
"""
function rasterize(segments::AbstractVector{<:NTuple{4,Float64}})
    grid = falses(LOGO_RESOLUTION, LOGO_RESOLUTION)
    scale = LOGO_RESOLUTION / (2 * LOGO_CANVAS_HALF_EXTENT)

    function plot(x, y)
        col = floor(Int, (x + LOGO_CANVAS_HALF_EXTENT) * scale) + 1
        row = floor(Int, (LOGO_CANVAS_HALF_EXTENT - y) * scale) + 1
        if 1 <= row <= LOGO_RESOLUTION && 1 <= col <= LOGO_RESOLUTION
            grid[row, col] = true
        end
    end

    for (x1, y1, x2, y2) in segments
        steps = max(1, ceil(Int, hypot(x2 - x1, y2 - y1) * scale * 3))
        for i in 0:steps
            u = i / steps
            plot(x1 + u * (x2 - x1), y1 + u * (y2 - y1))
        end
    end
    return Matrix(grid)
end

"""
    run_logo(program, state)

Run a LOGO `program` from `state` and return the picture it draws, as a
centred `LOGO_RESOLUTION`-square bitmap. This is the value a problem's
`IOExample` output is compared against.
"""
run_logo(program, state::TurtleState) = rasterize(center_segments(program(state).segments))
