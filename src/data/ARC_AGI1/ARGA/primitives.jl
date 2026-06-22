#=
    ARGA / OBJECT-ARC primitives

    Implements the object-centric DSL described in Qiu et al., "ARGA"
    (https://github.com/khalil-research/ARGA-AAAI23), as reported in the
    paper's grammar figure ("Rule -> if Filter then Transforms", etc).
    Operator semantics (move, move_max, extend, rotate, mirror, flip,
    add_border, fill_rectangle, hollow_rectangle) are cross-checked against
    the reference Python implementation in ARCGraph.py's "nbccg" abstraction
    -- the only one of ARGA's object-abstraction methods that supports every
    transform in the paper's grammar.

    Framework constraint that shapes this file's design: HerbInterpret's
    `make_interpreter` evaluates a RuleNode's children *eagerly*, before the
    parent rule's own body runs (see `build_match_cases` in
    HerbInterpret/src/make_interpret.jl: `c = [self(self, child, input) for
    child in get_children(prog)]` happens unconditionally before dispatching
    on the rule). This means a nonterminal cannot be "recursed into" from
    inside a `(x, y) -> ...` lambda's body and still see `x`/`y` -- the
    recursive call happens *outside* the lambda, at eager-evaluation time,
    where `x`/`y` are not yet bound. Concretely: `Filt = (obj, grid) ->
    eq(Val, Val)` with a separate rule `Val = myattr(obj)` raises
    `UndefVarError: obj not defined`, because `Val`'s rule is evaluated
    before the lambda is even constructed.

    The fix used throughout this file: `Filter`/`Transform`/`Atom` are never
    represented as closures over `obj`/`grid`. They are plain first-order
    data (the `ARGAAtom`/`ARGAFilterExpr`/`ARGATransform` types below),
    built by ordinary eager constructor calls -- exactly the same pattern
    Hodel's ARC grammar already uses for `Object`/`Indices`/etc. The actual
    per-object evaluation (`eval_filter`, `apply_transforms`) is a plain
    Julia function (`apply_rule`) invoked once per `Grid` production, with
    full, ordinary access to the grid and its extracted objects -- no
    grammar-level lambda scoping involved at all.
=#

using HerbGrammar: AbstractGrammar

const ARGAGrid = Matrix{Int}

"""
    ARGAObject

A connected, single-colored group of grid cells (ARGA's "nbccg" object
abstraction): `pixels` are `(row, col)` coordinates (1-indexed), `color` is
shared by all of them.
"""
struct ARGAObject
    pixels::Vector{Tuple{Int,Int}}
    color::Int
end

Base.:(==)(a::ARGAObject, b::ARGAObject) = a.color == b.color && Set(a.pixels) == Set(b.pixels)

# ------------------------------------------------------------------
# Color / direction / axis constants
# ------------------------------------------------------------------

# Standard ARC palette (0-9), matching ARCGraph.py's `colors` list.
const BLACK = 0
const BLUE = 1
const RED = 2
const GREEN = 3
const YELLOW = 4
const GREY = 5
const FUCHSIA = 6
const ORANGE = 7
const CYAN = 8
const MAROON = 9

const UP = :UP
const DOWN = :DOWN
const LEFT = :LEFT
const RIGHT = :RIGHT
const UPLEFT = :UPLEFT
const DOWNLEFT = :DOWNLEFT
const UPRIGHT = :UPRIGHT
const DOWNRIGHT = :DOWNRIGHT

const VERTICAL = :VERTICAL
const HORIZONTAL = :HORIZONTAL
const LEFTDIAGONAL = :LEFTDIAGONAL
const RIGHTDIAGONAL = :RIGHTDIAGONAL

const ARGA_MIN = :min
const ARGA_MAX = :max

const DIRECTION_DELTA = Dict(
    UP => (-1, 0), DOWN => (1, 0), LEFT => (0, -1), RIGHT => (0, 1),
    UPLEFT => (-1, -1), DOWNLEFT => (1, -1), UPRIGHT => (-1, 1), DOWNRIGHT => (1, 1),
)

# ------------------------------------------------------------------
# Grid <-> objects
# ------------------------------------------------------------------

"""
    background_color(grid)

`0` if present in `grid` (the conventional ARC background), else the most
frequent color -- matches ARCGraph.py's `Image.__init__` background-color
rule.
"""
function background_color(grid::ARGAGrid)::Int
    any(==(0), grid) && return 0
    counts = Dict{Int,Int}()
    for c in grid
        counts[c] = get(counts, c, 0) + 1
    end
    return argmax(counts)
end

"""
    extract_objects(grid)

The grid's "nbccg" object decomposition: 4-connected, single-colored
components, excluding the background color. Mirrors
`Image.get_non_black_components_graph` (ARCGraph.py), generalized from a
hardcoded background of `0` to [`background_color`](@ref).
"""
function extract_objects(grid::ARGAGrid)::Vector{ARGAObject}
    bg = background_color(grid)
    h, w = size(grid)
    visited = falses(h, w)
    objects = ARGAObject[]
    for r in 1:h, c in 1:w
        (visited[r, c] || grid[r, c] == bg) && continue
        color = grid[r, c]
        stack = [(r, c)]
        visited[r, c] = true
        pixels = Tuple{Int,Int}[]
        while !isempty(stack)
            (cr, cc) = pop!(stack)
            push!(pixels, (cr, cc))
            for (dr, dc) in ((-1, 0), (1, 0), (0, -1), (0, 1))
                nr, nc = cr + dr, cc + dc
                if 1 <= nr <= h && 1 <= nc <= w && !visited[nr, nc] && grid[nr, nc] == color
                    visited[nr, nc] = true
                    push!(stack, (nr, nc))
                end
            end
        end
        push!(objects, ARGAObject(pixels, color))
    end
    return objects
end

"""
    render(height, width, bg, objects)

Reconstruct a grid: start from a `bg`-filled canvas, then paint each
object's pixels with its color, in list order (later objects in `objects`
take precedence on overlap -- relevant since `add_border`/`fill_rectangle`
append new objects after the ones already in the list). Pixels outside
`[1,height] x [1,width]` are dropped.
"""
function render(height::Int, width::Int, bg::Int, objects::Vector{ARGAObject})::ARGAGrid
    grid = fill(bg, height, width)
    for obj in objects
        for (r, c) in obj.pixels
            if 1 <= r <= height && 1 <= c <= width
                grid[r, c] = obj.color
            end
        end
    end
    return grid
end

inbounds(p::Tuple{Int,Int}, height::Int, width::Int) = 1 <= p[1] <= height && 1 <= p[2] <= width

occupied_set(others::Vector{ARGAObject}) = Set(p for o in others for p in o.pixels)

chebyshev_adjacent(p::Tuple{Int,Int}, q::Tuple{Int,Int}) = max(abs(p[1] - q[1]), abs(p[2] - q[2])) == 1

"""
    neighbors_of(obj, ctx)

The other objects in `ctx.objects` that touch `obj` (including diagonally)
-- i.e. some pixel of `obj` is within Chebyshev distance 1 of some pixel of
the other object. Simpler than ARCGraph.py's exact "unobstructed
horizontal/vertical line of sight" edge definition, used here as a
straightforward, documented stand-in.
"""
function neighbors_of(obj::ARGAObject, ctx)::Vector{ARGAObject}
    result = ARGAObject[]
    for o in ctx.objects
        o === obj && continue
        if any(chebyshev_adjacent(p, q) for p in obj.pixels for q in o.pixels)
            push!(result, o)
        end
    end
    return result
end

# ------------------------------------------------------------------
# Scalar attribute accessors
# ------------------------------------------------------------------

obj_size(obj::ARGAObject)::Int = length(obj.pixels)
obj_width(obj::ARGAObject)::Int = maximum(c for (r, c) in obj.pixels) - minimum(c for (r, c) in obj.pixels) + 1
obj_height(obj::ARGAObject)::Int = maximum(r for (r, c) in obj.pixels) - minimum(r for (r, c) in obj.pixels) + 1
obj_row(obj::ARGAObject)::Int = minimum(r for (r, c) in obj.pixels)
obj_column(obj::ARGAObject)::Int = minimum(c for (r, c) in obj.pixels)
obj_degree(obj::ARGAObject, ctx)::Int = length(neighbors_of(obj, ctx))

"""
    is_square(obj)

`true` iff `obj`'s bounding box is a square (width == height) -- mirrors
Hodel's ARC grammar's `square`, ignoring whether the box is fully filled.
"""
is_square(obj::ARGAObject)::Bool = obj_width(obj) == obj_height(obj)

"""
    is_enclosed(obj, ctx)

`true` iff `obj`'s bounding box contains at least one background pixel that
cannot reach the box's border by 4-connected background-colored steps
without crossing `obj` -- i.e. `obj` encloses a "hole".
"""
function is_enclosed(obj::ARGAObject, ctx)::Bool
    rows = first.(obj.pixels)
    cols = last.(obj.pixels)
    min_r, max_r = extrema(rows)
    min_c, max_c = extrema(cols)
    (max_r - min_r < 2 || max_c - min_c < 2) && return false  # no room for an interior cell

    own = Set(obj.pixels)
    h = max_r - min_r + 1
    w = max_c - min_c + 1
    to_local(r, c) = (r - min_r + 1, c - min_c + 1)

    reachable = falses(h, w)
    queue = Tuple{Int,Int}[]
    for r in min_r:max_r, c in (min_c, max_c)
        (r, c) in own && continue
        lr, lc = to_local(r, c)
        if !reachable[lr, lc]
            reachable[lr, lc] = true
            push!(queue, (lr, lc))
        end
    end
    for c in min_c:max_c, r in (min_r, max_r)
        (r, c) in own && continue
        lr, lc = to_local(r, c)
        if !reachable[lr, lc]
            reachable[lr, lc] = true
            push!(queue, (lr, lc))
        end
    end
    while !isempty(queue)
        (lr, lc) = pop!(queue)
        for (dr, dc) in ((-1, 0), (1, 0), (0, -1), (0, 1))
            nr, nc = lr + dr, lc + dc
            (1 <= nr <= h && 1 <= nc <= w) || continue
            reachable[nr, nc] && continue
            (nr + min_r - 1, nc + min_c - 1) in own && continue
            reachable[nr, nc] = true
            push!(queue, (nr, nc))
        end
    end
    for r in 1:h, c in 1:w
        (r + min_r - 1, c + min_c - 1) in own && continue
        reachable[r, c] || return true
    end
    return false
end

# ------------------------------------------------------------------
# Aggregates (MIN/MAX over the current grid's objects)
# ------------------------------------------------------------------

function attr_value(kind::Symbol, obj::ARGAObject, ctx)::Int
    kind == :size && return obj_size(obj)
    kind == :width && return obj_width(obj)
    kind == :height && return obj_height(obj)
    kind == :row && return obj_row(obj)
    kind == :column && return obj_column(obj)
    kind == :degree && return obj_degree(obj, ctx)
    error("ARGA: no scalar attribute $kind")
end

attr_min(kind::Symbol, ctx)::Int = isempty(ctx.objects) ? 0 : minimum(attr_value(kind, o, ctx) for o in ctx.objects)
attr_max(kind::Symbol, ctx)::Int = isempty(ctx.objects) ? 0 : maximum(attr_value(kind, o, ctx) for o in ctx.objects)

"""
    resolve_attr(kind, value, ctx)

`value` itself if it's a literal `Int`, or the `:min`/`:max` aggregate of
attribute `kind` over `ctx.objects` if `value` is [`ARGA_MIN`](@ref)/
[`ARGA_MAX`](@ref).
"""
function resolve_attr(kind::Symbol, value, ctx)::Int
    value === ARGA_MIN && return attr_min(kind, ctx)
    value === ARGA_MAX && return attr_max(kind, ctx)
    return value
end

# ------------------------------------------------------------------
# Atom / Filter (plain data -- see file docstring for why)
# ------------------------------------------------------------------

"""
    ARGAAtom

One primitive test on the object currently being filtered ("self"):
`kind` selects which property, `value` is what it's compared against
(a literal, or [`ARGA_MIN`](@ref)/[`ARGA_MAX`](@ref) for the size-like
attributes). `value` is unused (`nothing`) for the parameterless atoms
(`:square`, `:enclosed`, `:any_neighbor`).
"""
struct ARGAAtom
    kind::Symbol
    value::Any
end

atom_color(c::Int) = ARGAAtom(:color, c)
atom_size(s) = ARGAAtom(:size, s)
atom_degree(d) = ARGAAtom(:degree, d)
atom_width(w) = ARGAAtom(:width, w)
atom_height(h) = ARGAAtom(:height, h)
atom_row(r) = ARGAAtom(:row, r)
atom_column(c) = ARGAAtom(:column, c)
atom_square() = ARGAAtom(:square, nothing)
atom_enclosed() = ARGAAtom(:enclosed, nothing)
atom_any_neighbor() = ARGAAtom(:any_neighbor, nothing)
atom_neighbor_color(c::Int) = ARGAAtom(:neighbor_color, c)
atom_neighbor_size(s) = ARGAAtom(:neighbor_size, s)
atom_neighbor_degree(d) = ARGAAtom(:neighbor_degree, d)

"""
    eval_atom(atom, obj, ctx)

Evaluate a single [`ARGAAtom`](@ref) against `obj`. `ctx` is a
`(objects, height, width, background)` NamedTuple built once per
[`apply_rule`](@ref) call.
"""
function eval_atom(a::ARGAAtom, obj::ARGAObject, ctx)::Bool
    k = a.kind
    k == :color && return obj.color == a.value
    k == :size && return obj_size(obj) == resolve_attr(:size, a.value, ctx)
    k == :degree && return obj_degree(obj, ctx) == resolve_attr(:degree, a.value, ctx)
    k == :width && return obj_width(obj) == resolve_attr(:width, a.value, ctx)
    k == :height && return obj_height(obj) == resolve_attr(:height, a.value, ctx)
    k == :row && return obj_row(obj) == resolve_attr(:row, a.value, ctx)
    k == :column && return obj_column(obj) == resolve_attr(:column, a.value, ctx)
    k == :square && return is_square(obj)
    k == :enclosed && return is_enclosed(obj, ctx)
    k == :any_neighbor && return !isempty(neighbors_of(obj, ctx))
    k == :neighbor_color && return any(o.color == a.value for o in neighbors_of(obj, ctx))
    if k == :neighbor_size
        target = resolve_attr(:size, a.value, ctx)
        return any(obj_size(o) == target for o in neighbors_of(obj, ctx))
    end
    if k == :neighbor_degree
        target = resolve_attr(:degree, a.value, ctx)
        return any(obj_degree(o, ctx) == target for o in neighbors_of(obj, ctx))
    end
    error("ARGA: unknown atom kind $k")
end

"""
    ARGAFilterExpr

`Filter -> Atom | not Atom | Atom and Filter | Atom or Filter` (paper's
Figure 16) as a small closed type hierarchy instead of closures, for the
same reason as [`ARGAAtom`](@ref) (see file docstring).
"""
abstract type ARGAFilterExpr end
struct FAtom <: ARGAFilterExpr
    atom::ARGAAtom
end
struct FNot <: ARGAFilterExpr
    atom::ARGAAtom
end
struct FAnd <: ARGAFilterExpr
    atom::ARGAAtom
    rest::ARGAFilterExpr
end
struct FOr <: ARGAFilterExpr
    atom::ARGAAtom
    rest::ARGAFilterExpr
end

f_atom(a::ARGAAtom) = FAtom(a)
f_not(a::ARGAAtom) = FNot(a)
f_and(a::ARGAAtom, r::ARGAFilterExpr) = FAnd(a, r)
f_or(a::ARGAAtom, r::ARGAFilterExpr) = FOr(a, r)

function eval_filter(f::ARGAFilterExpr, obj::ARGAObject, ctx)::Bool
    f isa FAtom && return eval_atom(f.atom, obj, ctx)
    f isa FNot && return !eval_atom(f.atom, obj, ctx)
    f isa FAnd && return eval_atom(f.atom, obj, ctx) && eval_filter(f.rest, obj, ctx)
    f isa FOr && return eval_atom(f.atom, obj, ctx) || eval_filter(f.rest, obj, ctx)
    error("ARGA: unknown filter expr $f")
end

# ------------------------------------------------------------------
# Transform primitives (pixel-level), cross-checked against ARCGraph.py
# ------------------------------------------------------------------

"""
    move_pixels(obj, dir)

Shift every pixel of `obj` by one step in `dir`, unconditionally -- mirrors
`ARCGraph.move_node` (no collision checking at all).
"""
function move_pixels(obj::ARGAObject, dir::Symbol)::ARGAObject
    dr, dc = DIRECTION_DELTA[dir]
    ARGAObject([(r + dr, c + dc) for (r, c) in obj.pixels], obj.color)
end

"""
    move_max_pixels(obj, dir, others, ctx)

Repeatedly [`move_pixels`](@ref) by one step in `dir` while the next step
would stay in-bounds and not collide with any pixel in `others` -- mirrors
`ARCGraph.move_node_max`.
"""
function move_max_pixels(obj::ARGAObject, dir::Symbol, others::Vector{ARGAObject}, ctx)::ARGAObject
    dr, dc = DIRECTION_DELTA[dir]
    occ = occupied_set(others)
    current = obj.pixels
    while true
        nxt = [(r + dr, c + dc) for (r, c) in current]
        (any(!inbounds(p, ctx.height, ctx.width) for p in nxt) || any(p in occ for p in nxt)) && break
        current = nxt
    end
    ARGAObject(current, obj.color)
end

"""
    extend_pixels(obj, dir, overlap, others, ctx)

For every pixel of `obj`, lay down copies stepping in `dir` until going
out of bounds (if `overlap`), or until going out of bounds or hitting a
pixel in `others` (if `!overlap`) -- mirrors `ARCGraph.extend_node`.
"""
function extend_pixels(obj::ARGAObject, dir::Symbol, overlap::Bool, others::Vector{ARGAObject}, ctx)::ARGAObject
    dr, dc = DIRECTION_DELTA[dir]
    occ = occupied_set(others)
    new_pixels = Set{Tuple{Int,Int}}()
    for (r, c) in obj.pixels
        cr, cc = r, c
        while true
            push!(new_pixels, (cr, cc))
            cr += dr
            cc += dc
            !inbounds((cr, cc), ctx.height, ctx.width) && break
            (!overlap && (cr, cc) in occ) && break
        end
    end
    ARGAObject(collect(new_pixels), obj.color)
end

"""
    rotate_pixels(obj, angle)

Rotate `obj` clockwise by `angle` degrees (90/180/270), one 90-degree step
at a time, recomputing the (integer/floor-divided) centroid from scratch
before *each* step -- matches `ARCGraph.rotate_node` exactly, including
its rounding behavior: recomputing per-step (rather than once upfront)
can matter for 180/270 when the object's pixel count doesn't evenly
divide its coordinate sum, since each step's floor-divided centroid can
drift slightly from the previous one.
"""
function rotate_pixels(obj::ARGAObject, angle::Int)::ARGAObject
    times = angle == 90 ? 1 : angle == 180 ? 2 : angle == 270 ? 3 : error("ARGA: invalid angle $angle")
    pixels = obj.pixels
    for _ in 1:times
        n = length(pixels)
        cy = sum(r for (r, c) in pixels) ÷ n
        cx = sum(c for (r, c) in pixels) ÷ n
        pixels = [(cy + (c - cx), cx - (r - cy)) for (r, c) in pixels]
    end
    ARGAObject(pixels, obj.color)
end

"""
    reflect_pixels(pixels, axis, min_r, max_r, min_c, max_c)

Reflect `pixels` about `axis`, relative to the box `[min_r,max_r] x
[min_c,max_c]`. Used by both [`flip_pixels`](@ref) (box = `obj`'s own
bounding box) and [`mirror_pixels`](@ref) (box = the whole grid) -- see
those docstrings for why they use different boxes. Formulas match
`ARCGraph.flip`'s VERTICAL/HORIZONTAL/DIAGONAL_LEFT/DIAGONAL_RIGHT cases
exactly (cross-checked against the reference implementation).
"""
function reflect_pixels(pixels, axis::Symbol, min_r::Int, max_r::Int, min_c::Int, max_c::Int)
    axis == VERTICAL && return [(max_r - (r - min_r), c) for (r, c) in pixels]
    axis == HORIZONTAL && return [(r, max_c - (c - min_c)) for (r, c) in pixels]
    axis == LEFTDIAGONAL && return [(c - min_c + min_r, r - min_r + min_c) for (r, c) in pixels]
    axis == RIGHTDIAGONAL && return [(min_r + max_c - c, max_c + min_r - r) for (r, c) in pixels]
    error("ARGA: unknown axis $axis")
end

"""
    flip_pixels(obj, axis)

Reflect `obj` about `axis`, within its own bounding box -- mirrors
`ARCGraph.flip` exactly.
"""
function flip_pixels(obj::ARGAObject, axis::Symbol)::ARGAObject
    rows = first.(obj.pixels)
    cols = last.(obj.pixels)
    ARGAObject(reflect_pixels(obj.pixels, axis, minimum(rows), maximum(rows), minimum(cols), maximum(cols)), obj.color)
end

"""
    mirror_pixels(obj, axis, ctx)

Reflect `obj` about `axis`, relative to the *whole grid* instead of its own
bounding box. The lark grammar's `mirror` actually takes another object
(reflects relative to that object's position) rather than a named axis,
which doesn't fit the paper's `mirror(Axis)` signature -- this is a
deliberate, documented adaptation: `mirror` = grid-relative reflection,
[`flip_pixels`](@ref) = object-relative reflection, giving the two paper
transforms genuinely different (and still well-defined, testable)
behavior.
"""
function mirror_pixels(obj::ARGAObject, axis::Symbol, ctx)::ARGAObject
    ARGAObject(reflect_pixels(obj.pixels, axis, 1, ctx.height, 1, ctx.width), obj.color)
end

"""
    add_border_pixels(obj, color, others)

A new `color`-colored object covering the 8-connected ring of pixels
immediately around `obj`, excluding any pixel already in `obj` or
`others` -- mirrors `ARCGraph.add_border`.
"""
function add_border_pixels(obj::ARGAObject, color::Int, others::Vector{ARGAObject})::ARGAObject
    own = Set(obj.pixels)
    occ = occupied_set(others)
    border = Set{Tuple{Int,Int}}()
    for (r, c) in obj.pixels, dr in -1:1, dc in -1:1
        (dr, dc) == (0, 0) && continue
        p = (r + dr, c + dc)
        (p in own || p in occ) && continue
        push!(border, p)
    end
    ARGAObject(collect(border), color)
end

"""
    fill_rectangle_pixels(obj, color, overlap, others)

A new `color`-colored object covering the cells of `obj`'s bounding box
not already in `obj`, and (unless `overlap`) not in `others` either --
mirrors `ARCGraph.fill_rectangle`. Returns `nothing` if there are no such
cells.
"""
function fill_rectangle_pixels(obj::ARGAObject, color::Int, overlap::Bool, others::Vector{ARGAObject})::Union{Nothing,ARGAObject}
    own = Set(obj.pixels)
    occ = occupied_set(others)
    rows = first.(obj.pixels)
    cols = last.(obj.pixels)
    min_r, max_r = extrema(rows)
    min_c, max_c = extrema(cols)
    unfilled = Tuple{Int,Int}[]
    for r in min_r:max_r, c in min_c:max_c
        p = (r, c)
        p in own && continue
        (!overlap && p in occ) && continue
        push!(unfilled, p)
    end
    isempty(unfilled) && return nothing
    ARGAObject(unfilled, color)
end

"""
    hollow_rectangle_pixels(obj, color)

Shrink `obj` down to just its bounding-box border pixels; the removed
interior becomes a new `color`-colored object (or is dropped if `color ==
0`, the background) -- mirrors `ARCGraph.hollow_rectangle`. Returns
`(border_obj, extras)`.
"""
function hollow_rectangle_pixels(obj::ARGAObject, color::Int)
    rows = first.(obj.pixels)
    cols = last.(obj.pixels)
    min_r, max_r = extrema(rows)
    min_c, max_c = extrema(cols)
    border = Tuple{Int,Int}[]
    interior = Tuple{Int,Int}[]
    for (r, c) in obj.pixels
        if r == min_r || r == max_r || c == min_c || c == max_c
            push!(border, (r, c))
        else
            push!(interior, (r, c))
        end
    end
    border_obj = ARGAObject(border, obj.color)
    extras = color == BLACK || isempty(interior) ? ARGAObject[] : [ARGAObject(interior, color)]
    return (border_obj, extras)
end

# ------------------------------------------------------------------
# ARGATransform (plain data) + Transforms sequencing
# ------------------------------------------------------------------

"""
    ARGATransform

One `Transform` production from the paper's grammar, as plain data (see
file docstring for why).
"""
struct ARGATransform
    kind::Symbol
    params::Tuple
end

t_update_color(c::Int) = ARGATransform(:update_color, (c,))
t_move(d::Symbol) = ARGATransform(:move, (d,))
t_move_max(d::Symbol) = ARGATransform(:move_max, (d,))
t_extend(d::Symbol, overlap::Bool) = ARGATransform(:extend, (d, overlap))
t_rotate(a::Int) = ARGATransform(:rotate, (a,))
t_fill_rectangle(c::Int, overlap::Bool) = ARGATransform(:fill_rectangle, (c, overlap))
t_hollow_rectangle(c::Int) = ARGATransform(:hollow_rectangle, (c,))
t_mirror(axis::Symbol) = ARGATransform(:mirror, (axis,))
t_add_border(c::Int) = ARGATransform(:add_border, (c,))
t_flip(axis::Symbol) = ARGATransform(:flip, (axis,))
t_noop() = ARGATransform(:noop, ())

mk_single(t::ARGATransform)::Vector{ARGATransform} = [t]
mk_seq(t::ARGATransform, ts::Vector{ARGATransform})::Vector{ARGATransform} = vcat([t], ts)

"""
    apply_transform(t, obj, others, ctx)

Apply a single [`ARGATransform`](@ref) to `obj`. `others` is `ctx.objects`
minus the *original* self for this whole `Transforms` sequence (see
[`apply_transforms`](@ref) for why it's fixed per-sequence, not
per-step). Returns `(continuing_self, extra_objects)`: for `add_border`/
`fill_rectangle`, `obj` itself is unchanged and an extra sibling object is
produced; for `hollow_rectangle`, `obj` itself shrinks and may also
produce an extra (interior) object; every other transform just replaces
`obj`.
"""
function apply_transform(t::ARGATransform, obj::ARGAObject, others::Vector{ARGAObject}, ctx)
    k = t.kind
    k == :noop && return (obj, ARGAObject[])
    k == :update_color && return (ARGAObject(obj.pixels, t.params[1]), ARGAObject[])
    k == :move && return (move_pixels(obj, t.params[1]), ARGAObject[])
    k == :move_max && return (move_max_pixels(obj, t.params[1], others, ctx), ARGAObject[])
    k == :extend && return (extend_pixels(obj, t.params[1], t.params[2], others, ctx), ARGAObject[])
    k == :rotate && return (rotate_pixels(obj, t.params[1]), ARGAObject[])
    k == :flip && return (flip_pixels(obj, t.params[1]), ARGAObject[])
    k == :mirror && return (mirror_pixels(obj, t.params[1], ctx), ARGAObject[])
    if k == :add_border
        return (obj, [add_border_pixels(obj, t.params[1], others)])
    end
    if k == :fill_rectangle
        extra = fill_rectangle_pixels(obj, t.params[1], t.params[2], others)
        return (obj, extra === nothing ? ARGAObject[] : [extra])
    end
    k == :hollow_rectangle && return hollow_rectangle_pixels(obj, t.params[1])
    error("ARGA: unknown transform kind $k")
end

"""
    apply_transforms(ts, obj, others, ctx)

Apply the `Transform ; Transform ; ...` sequence `ts` to `obj`, threading
the "continuing self" through each step while accumulating side objects
(from `add_border`/`fill_rectangle`/`hollow_rectangle`) separately -- a
side object created partway through the sequence is *not* itself subject
to later transforms in the same sequence. `others` is fixed for the whole
sequence (collision checks see the rest of the grid as it stood when this
object's turn came up in [`apply_rule`](@ref)'s loop, not as it's further
modified mid-sequence by `obj`'s own later steps).
"""
function apply_transforms(ts::Vector{ARGATransform}, obj::ARGAObject, others::Vector{ARGAObject}, ctx)
    extras = ARGAObject[]
    current = obj
    for t in ts
        (current, e) = apply_transform(t, current, others, ctx)
        append!(extras, e)
    end
    return (current, extras)
end

# ------------------------------------------------------------------
# Rule = if Filter then Transforms
# ------------------------------------------------------------------

"""
    apply_rule(grid, filt, transforms)

Decompose `grid` into objects ([`extract_objects`](@ref)); for each
(in [`extract_objects`](@ref)'s raster-scan order) that satisfies `filt`
(`eval_filter`, evaluated against the *original*, pre-transform object set
-- so e.g. MIN/MAX aggregates reflect the untouched grid), apply
`transforms`; then [`render`](@ref) the result back to a grid.

Matched objects are transformed in sequence, each one's collision checks
(`move_max`/`extend`/`add_border`/`fill_rectangle`) seeing every other
object *as it currently stands* -- already-moved earlier objects free up
the space they vacated for later ones in the same rule application, and
not-yet-reached later objects still block at their original position.
This mirrors `ARCGraph.py`'s shared-graph, sequential-mutation semantics,
modulo exactly matching its node-iteration order (this implementation
visits objects in raster-scan order; `ARCGraph.py` groups by color first).

This is `Start`'s sole production -- the grammar currently supports
exactly one `Rule`, not the lark grammar's `(do rule*)` sequences (a
documented scope cut: every example solution in this benchmark's
`solutions/correct/` uses a single rule).
"""
function apply_rule(grid::ARGAGrid, filt::ARGAFilterExpr, transforms::Vector{ARGATransform})::ARGAGrid
    h, w = size(grid)
    bg = background_color(grid)
    objects = extract_objects(grid)
    ctx = (objects = objects, height = h, width = w, background = bg)
    world = copy(objects)
    extras_all = ARGAObject[]
    for (i, obj) in enumerate(objects)
        if eval_filter(filt, obj, ctx)
            others = [world[j] for j in eachindex(world) if j != i]
            (final_self, extras) = apply_transforms(transforms, obj, others, ctx)
            world[i] = final_self
            append!(extras_all, extras)
        end
    end
    return render(h, w, bg, vcat(world, extras_all))
end
