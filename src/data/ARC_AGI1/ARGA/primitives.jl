#=
    ARGA / OBJECT-ARC primitives

    Implements the object-centric DSL given by hysynth's `dsl/v0_3/dsl.lark`
    (the grammar the paper, Qiu et al. "ARGA", https://github.com/khalil-research/ARGA-AAAI23,
    actually specifies: `rule -> (vars (this other?)) (filter ...) (apply xform+)`,
    with generic `*_of(VAR)` accessors and `*_equals(expr, expr)` filter
    primitives rather than a fixed self-only atom per attribute). Operator
    semantics (move, move_max, extend, rotate, mirror, flip, add_border,
    fill_rectangle, hollow_rectangle, insert) are cross-checked against the
    reference Python implementation in ARCGraph.py's "nbccg" abstraction.

    Adaptations from the lark grammar/reference, documented here rather than
    scattered:

    - `fcolor_expr`/`color_expr` are merged into one `ColorExpr` -- the lark
      grammar gives them identical token sets (`FCOLOR`/`COLOR` are the same
      10 letters) and only splits them for parser-technical reasons, so
      merging is pure deduplication, not a semantic change.
    - `Row`/`row_equals`/`row_of` are dropped entirely -- the lark grammar's
      `filter_prim`/`*_expr` list (the one actually given) has no row
      primitive at all, only `column_equals`/`column_of`.
    - `decl`'s `(vars (this))` vs `(vars (this other))` distinction is
      mirrored as `ARGADecl.use_other`, but -- like the lark grammar itself,
      which never grammatically forbids `other` from appearing under a
      `this`-only decl -- it isn't used to *restrict* which `Var`s a rule can
      reference, only whether [`apply_rule`](@ref) bothers searching for an
      `other` binding at all.
    - `other`, when declared, is bound *existentially*: for a given `this`,
      [`apply_rule`](@ref) tries every other object (in raster-scan order)
      against the filter and keeps the first one that satisfies it as the
      witness, then threads that same witness through the transform step.
      This is what the reference's per-neighbor existential filters
      (`Neighbor_Size`/`Neighbor_Degree`/...) reduce to once `neighbor_of`
      and the generic `other`-binding are composed via `and`.
    - `insert`'s `OBJECT_ID` indexes into *this rule's own* extracted-object
      list (0-based, raster-scan order) instead of
      `task.static_objects_for_insertion` -- a task-specific object library
      built from training-pair bookkeeping this benchmark harness has no
      access to. Out-of-range ids are a no-op.
    - `img_pts_of(VAR)` (no reference definition exists for it -- the
      reference's `Insert` only ever takes a literal `ImagePoints`) resolves
      to whichever of the 8 named image points is nearest `VAR`'s centroid.
    - `direction_of(VAR)` mirrors `ARCGraph.get_relative_pos`'s *intent*
      (the direction from `this` towards `VAR`) via a straightforward
      centroid-delta snap to the 8 directions, rather than its considerably
      more case-laden (and in places inconsistent) pixel-extent logic.
    - `mirror`'s axis is exactly `ARCGraph.get_mirror_axis`: reflect across
      a horizontal line through `other`'s centroid if `this`/`other` are
      "vertical" (unobstructed line-of-sight, stacked) neighbors, otherwise
      across a vertical line through `other`'s centroid.
    - Two bugs were found and fixed relative to the *previous* version of
      this file (cross-checked again against ARCGraph.py while rewriting):
      `rotate_pixels`'s 90/270 cases were swapped (its single-step formula
      always matched `RotateNode`'s `mul=-1` case, i.e. its own "90" behaved
      like the reference's "270" and vice versa -- "180" was unaffected
      since two applications of either direction agree); and
      `hollow_rectangle_pixels` compared the fill color against the
      hardcoded constant `BLACK` instead of the grid's actual (dynamic)
      background color.
    - `flip`/`mirror` now revert to the pre-transform object (a no-op) if
      the reflected pixels would collide with another object -- matching
      `ARCGraph.Flip`/`Mirror`'s `if not check_collision(...): apply` guard,
      which the previous version of this file omitted.
    - The neighbor relation is now the reference's actual one: two objects
      are neighbors iff they have an unobstructed line of sight along a
      shared row or column (`ARCGraph`'s nbccg edge construction), not mere
      Chebyshev (8-connected) adjacency -- needed now that `mirror` depends
      on classifying that relation as "vertical" vs "horizontal".

    Framework constraint that shapes this file's design (unchanged from
    before): HerbInterpret's `make_interpreter` evaluates a RuleNode's
    children *eagerly*, before the parent rule's own body runs, so
    `Filter`/`Xform`/expr values are never closures over `this`/`other`/the
    grid -- they're plain first-order data, interpreted once per
    [`apply_rule`](@ref) call by ordinary Julia functions with full access
    to the grid and its objects.
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
# Color / direction / axis / tag constants
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
const ARGA_EVEN = :even
const ARGA_ODD = :odd
const ARGA_CENTER = :center

const SQUARE = :square
const ENCLOSED = :enclosed

const THIS_VAR = :this
const OTHER_VAR = :other

const IMG_TOP = :top
const IMG_BOTTOM = :bottom
const IMG_LEFT = :left
const IMG_RIGHT = :right
const IMG_TOPLEFT = :topleft
const IMG_TOPRIGHT = :topright
const IMG_BOTTOMLEFT = :bottomleft
const IMG_BOTTOMRIGHT = :bottomright

const REL_SOURCE = :source
const REL_TARGET = :target
const REL_MIDDLE = :middle

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
take precedence on overlap -- relevant since `add_border`/`fill_rectangle`/
`insert` append new objects after the ones already in the list). Pixels
outside `[1,height] x [1,width]` are dropped.
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

collides_with(obj::ARGAObject, others::Vector{ARGAObject})::Bool = any(p in occupied_set(others) for p in obj.pixels)

"""
    unobstructed_relation(obj, other, grid, bg)

`:horizontal` if some pixel of `obj` shares a row with some pixel of
`other` with only `bg`-colored cells strictly between them, `:vertical` for
the same along a shared column, else `nothing` -- ARCGraph.py's nbccg
neighbor-edge definition (`Image.get_non_black_components_graph`), examined
against the *original* `grid` (so a third object sitting between `obj` and
`other` blocks the line of sight, exactly as in the reference).
"""
function unobstructed_relation(obj::ARGAObject, other::ARGAObject, grid::ARGAGrid, bg::Int)
    for p in obj.pixels, q in other.pixels
        if p[1] == q[1]
            lo, hi = minmax(p[2], q[2])
            if all(grid[p[1], c] == bg for c in (lo + 1):(hi - 1))
                return :horizontal
            end
        elseif p[2] == q[2]
            lo, hi = minmax(p[1], q[1])
            if all(grid[r, p[2]] == bg for r in (lo + 1):(hi - 1))
                return :vertical
            end
        end
    end
    return nothing
end

are_neighbors(obj::ARGAObject, other::ARGAObject, ctx)::Bool =
    unobstructed_relation(obj, other, ctx.grid, ctx.background) !== nothing

"""
    neighbors_of(obj, ctx)

The other objects in `ctx.objects` that are [`unobstructed_relation`](@ref)
neighbors of `obj`.
"""
function neighbors_of(obj::ARGAObject, ctx)::Vector{ARGAObject}
    result = ARGAObject[]
    for o in ctx.objects
        o === obj && continue
        are_neighbors(obj, o, ctx) && push!(result, o)
    end
    return result
end

# ------------------------------------------------------------------
# Scalar attribute accessors
# ------------------------------------------------------------------

obj_size(obj::ARGAObject)::Int = length(obj.pixels)
obj_width(obj::ARGAObject)::Int = maximum(c for (r, c) in obj.pixels) - minimum(c for (r, c) in obj.pixels) + 1
obj_height(obj::ARGAObject)::Int = maximum(r for (r, c) in obj.pixels) - minimum(r for (r, c) in obj.pixels) + 1
obj_column(obj::ARGAObject)::Int = minimum(c for (r, c) in obj.pixels)
obj_degree(obj::ARGAObject, ctx)::Int = length(neighbors_of(obj, ctx))

"""
    obj_centroid(obj)

`(row, col)`, each `(sum + n÷2) ÷ n` -- matches `ARCGraph.get_centroid`.
"""
function obj_centroid(obj::ARGAObject)::Tuple{Int,Int}
    n = length(obj.pixels)
    cy = (sum(r for (r, c) in obj.pixels) + n ÷ 2) ÷ n
    cx = (sum(c for (r, c) in obj.pixels) + n ÷ 2) ÷ n
    return (cy, cx)
end

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
# Aggregates (MIN/MAX/CENTER over the current grid)
# ------------------------------------------------------------------

function attr_value(kind::Symbol, obj::ARGAObject, ctx)::Int
    kind == :size && return obj_size(obj)
    kind == :width && return obj_width(obj)
    kind == :height && return obj_height(obj)
    kind == :column && return obj_column(obj)
    kind == :degree && return obj_degree(obj, ctx)
    error("ARGA: no scalar attribute $kind")
end

attr_min(kind::Symbol, ctx)::Int = isempty(ctx.objects) ? 0 : minimum(attr_value(kind, o, ctx) for o in ctx.objects)
attr_max(kind::Symbol, ctx)::Int = isempty(ctx.objects) ? 0 : maximum(attr_value(kind, o, ctx) for o in ctx.objects)

"""
    center_columns(width)

The 1 (odd `width`) or 2 (even `width`) middle column indices of a
`width`-wide grid -- matches `ARCGraph.get_center("column")`.
"""
center_columns(width::Int)::Vector{Int} = isodd(width) ? [(width + 1) ÷ 2] : [width ÷ 2, width ÷ 2 + 1]

# ------------------------------------------------------------------
# Var binding (`this`/`other`) and generic `*_of(Var)` accessors
# ------------------------------------------------------------------

"""
    AttrOf

`*_of(VAR)` from the lark grammar (`color_of`, `size_of`, `height_of`,
`width_of`, `degree_of`, `shape_of`, `column_of`, `direction_of`,
`img_pts_of`): `kind` selects the attribute, `var` is [`THIS_VAR`](@ref) or
[`OTHER_VAR`](@ref).
"""
struct AttrOf
    kind::Symbol
    var::Symbol
end

color_of(v::Symbol) = AttrOf(:color, v)
size_of(v::Symbol) = AttrOf(:size, v)
height_of(v::Symbol) = AttrOf(:height, v)
width_of(v::Symbol) = AttrOf(:width, v)
degree_of(v::Symbol) = AttrOf(:degree, v)
shape_of(v::Symbol) = AttrOf(:shape, v)
column_of(v::Symbol) = AttrOf(:column, v)
direction_of(v::Symbol) = AttrOf(:direction, v)
img_pts_of(v::Symbol) = AttrOf(:img_pts, v)

resolve_var_obj(var::Symbol, this_obj, other) = var === THIS_VAR ? this_obj : other

"""
    resolve_numeric(kind, val, this, other, ctx)

`val`'s value as a plain `Int`, or one of [`ARGA_EVEN`](@ref)/
[`ARGA_ODD`](@ref)/[`ARGA_CENTER`](@ref) passed through unresolved (handled
by [`tagged_eq`](@ref)), or `nothing` if `val` is an [`AttrOf`](@ref) whose
var isn't bound (no `other` available).
"""
function resolve_numeric(kind::Symbol, val, this_obj, other, ctx)
    if val isa AttrOf
        obj = resolve_var_obj(val.var, this_obj, other)
        obj === nothing && return nothing
        return attr_value(kind, obj, ctx)
    elseif val === ARGA_MIN
        return attr_min(kind, ctx)
    elseif val === ARGA_MAX
        return attr_max(kind, ctx)
    else
        return val
    end
end

"""
    tagged_eq(kind, ra, rb, ctx)

Equality between two [`resolve_numeric`](@ref) results, where a bare
[`ARGA_EVEN`](@ref)/[`ARGA_ODD`](@ref)/[`ARGA_CENTER`](@ref) tag acts as a
predicate on the other (numeric) side rather than a literal value to
compare against.
"""
function tagged_eq(kind::Symbol, ra, rb, ctx)::Bool
    if ra isa Symbol || rb isa Symbol
        tag, num = ra isa Symbol ? (ra, rb) : (rb, ra)
        num isa Symbol && return ra === rb
        tag === ARGA_EVEN && return iseven(num)
        tag === ARGA_ODD && return isodd(num)
        if tag === ARGA_CENTER
            return kind === :column && num in center_columns(ctx.width)
        end
        return false
    end
    return ra == rb
end

function attr_equals(kind::Symbol, a, b, this_obj, other, ctx)::Bool
    ra = resolve_numeric(kind, a, this_obj, other, ctx)
    rb = resolve_numeric(kind, b, this_obj, other, ctx)
    (ra === nothing || rb === nothing) && return false
    return tagged_eq(kind, ra, rb, ctx)
end

function resolve_color_value(e, this_obj, other)
    e isa AttrOf || return e
    obj = resolve_var_obj(e.var, this_obj, other)
    return obj === nothing ? nothing : obj.color
end

function eval_color_equals(a, b, this_obj, other, ctx)::Bool
    ra = resolve_color_value(a, this_obj, other)
    rb = resolve_color_value(b, this_obj, other)
    (ra === nothing || rb === nothing) && return false
    return ra == rb
end

"""
    eval_shape_equals(a, b, this, other, ctx)

`shape_equals`: a literal [`SQUARE`](@ref)/[`ENCLOSED`](@ref) tag acts as a
predicate on the other side if it's `shape_of(VAR)`; if both sides are
`shape_of(VAR)`, compares whether the two bound objects' square-ness and
enclosed-ness signatures match.
"""
function eval_shape_equals(a, b, this_obj, other, ctx)::Bool
    pred(tag, obj) = tag === SQUARE ? is_square(obj) : is_enclosed(obj)
    ra = a isa AttrOf ? resolve_var_obj(a.var, this_obj, other) : a
    rb = b isa AttrOf ? resolve_var_obj(b.var, this_obj, other) : b
    if ra isa Symbol && rb isa Symbol
        return ra === rb
    elseif ra isa Symbol
        rb === nothing && return false
        return pred(ra, rb)
    elseif rb isa Symbol
        ra === nothing && return false
        return pred(rb, ra)
    else
        (ra === nothing || rb === nothing) && return false
        return is_square(ra) == is_square(rb) && is_enclosed(ra) == is_enclosed(rb)
    end
end

# ------------------------------------------------------------------
# Filter primitives / expressions / decl (plain data)
# ------------------------------------------------------------------

"""
    FilterPrim

One `filter_prim` production: `kind` selects which primitive, `a`/`b` are
its two operands (each a literal, an [`AttrOf`](@ref), or -- for
`neighbor_of` -- a plain `Var` symbol).
"""
struct FilterPrim
    kind::Symbol
    a::Any
    b::Any
end

color_equals(a, b) = FilterPrim(:color, a, b)
size_equals(a, b) = FilterPrim(:size, a, b)
height_equals(a, b) = FilterPrim(:height, a, b)
width_equals(a, b) = FilterPrim(:width, a, b)
degree_equals(a, b) = FilterPrim(:degree, a, b)
shape_equals(a, b) = FilterPrim(:shape, a, b)
column_equals(a, b) = FilterPrim(:column, a, b)
neighbor_of(v1::Symbol, v2::Symbol) = FilterPrim(:neighbor, v1, v2)

function eval_filter_prim(p::FilterPrim, this_obj, other, ctx)::Bool
    k = p.kind
    k === :color && return eval_color_equals(p.a, p.b, this_obj, other, ctx)
    k === :shape && return eval_shape_equals(p.a, p.b, this_obj, other, ctx)
    if k === :neighbor
        o1 = resolve_var_obj(p.a, this_obj, other)
        o2 = resolve_var_obj(p.b, this_obj, other)
        (o1 === nothing || o2 === nothing || o1 === o2) && return false
        return are_neighbors(o1, o2, ctx)
    end
    return attr_equals(k, p.a, p.b, this_obj, other, ctx)
end

"""
    ARGAFilterExpr

`filter_expr -> filter_prim | (and e e) | (or e e) | (not e)` -- a general
binary tree (unlike the previous version's atom-on-the-left-only chains),
matching the lark grammar exactly.
"""
abstract type ARGAFilterExpr end
struct FPrim <: ARGAFilterExpr
    prim::FilterPrim
end
struct FAnd <: ARGAFilterExpr
    l::ARGAFilterExpr
    r::ARGAFilterExpr
end
struct FOr <: ARGAFilterExpr
    l::ARGAFilterExpr
    r::ARGAFilterExpr
end
struct FNot <: ARGAFilterExpr
    e::ARGAFilterExpr
end

f_prim(p::FilterPrim) = FPrim(p)
f_and(l::ARGAFilterExpr, r::ARGAFilterExpr) = FAnd(l, r)
f_or(l::ARGAFilterExpr, r::ARGAFilterExpr) = FOr(l, r)
f_not(e::ARGAFilterExpr) = FNot(e)

eval_filter(f::FPrim, this_obj, other, ctx)::Bool = eval_filter_prim(f.prim, this_obj, other, ctx)
eval_filter(f::FAnd, this_obj, other, ctx)::Bool = eval_filter(f.l, this_obj, other, ctx) && eval_filter(f.r, this_obj, other, ctx)
eval_filter(f::FOr, this_obj, other, ctx)::Bool = eval_filter(f.l, this_obj, other, ctx) || eval_filter(f.r, this_obj, other, ctx)
eval_filter(f::FNot, this_obj, other, ctx)::Bool = !eval_filter(f.e, this_obj, other, ctx)

"""
    ARGAFilter

`filter -> "(" "filter" filter_expr? ")"`: `expr === nothing` selects every
object.
"""
struct ARGAFilter
    expr::Union{Nothing,ARGAFilterExpr}
end
no_filter() = ARGAFilter(nothing)
has_filter(e::ARGAFilterExpr) = ARGAFilter(e)
eval_filter(f::ARGAFilter, this_obj, other, ctx)::Bool = f.expr === nothing ? true : eval_filter(f.expr, this_obj, other, ctx)

"""
    ARGADecl

`decl -> "(" "vars" "(" this other? ")" ")"`: whether [`apply_rule`](@ref)
should search for an `other` binding at all (see file docstring).
"""
struct ARGADecl
    use_other::Bool
end
decl_this() = ARGADecl(false)
decl_this_other() = ARGADecl(true)

# ------------------------------------------------------------------
# Transform primitives (pixel-level), cross-checked against ARCGraph.py
# ------------------------------------------------------------------

"""
    move_pixels(obj, dir)

Shift every pixel of `obj` by one step in `dir`, unconditionally -- mirrors
`ARCGraph.move_node` (no collision checking at all; out-of-bounds results
are dropped later by [`render`](@ref), same end result as the reference's
own bounds handling).
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

Rotate `obj` clockwise by `angle` degrees (90/180/270), recomputing the
(integer/floor-divided) centroid from scratch before *each* 90-degree step
-- matches `ARCGraph.rotate_node` exactly: `90` is one step with `mul=+1`,
`270` is one step with `mul=-1`, `180` is two steps with `mul=-1` (the
choice of `mul` for `180` doesn't matter -- two applications of either
single-step direction give the same result). Out-of-bounds pixels are not
pruned between steps of a multi-step rotation, unlike the reference --
a deliberate, low-impact simplification ([`render`](@ref) drops them from
the final grid regardless).
"""
function rotate_pixels(obj::ARGAObject, angle::Int)::ARGAObject
    mul, times = angle == 90 ? (1, 1) : angle == 270 ? (-1, 1) : angle == 180 ? (-1, 2) : error("ARGA: invalid angle $angle")
    pixels = obj.pixels
    for _ in 1:times
        n = length(pixels)
        cy = sum(r for (r, c) in pixels) ÷ n
        cx = sum(c for (r, c) in pixels) ÷ n
        pixels = [(cy - mul * (c - cx), cx + mul * (r - cy)) for (r, c) in pixels]
    end
    ARGAObject(pixels, obj.color)
end

"""
    reflect_pixels(pixels, axis, min_r, max_r, min_c, max_c)

Reflect `pixels` about `axis`, relative to the box `[min_r,max_r] x
[min_c,max_c]`. Used by [`flip_pixels`](@ref) (box = `obj`'s own bounding
box). Formulas match `ARCGraph.flip`'s VERTICAL/HORIZONTAL/
DIAGONAL_LEFT/DIAGONAL_RIGHT cases exactly.
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
`ARCGraph.flip`'s reflection formula (the collision-revert guard lives in
[`apply_transform`](@ref), matching `ARCGraph.Flip`'s
`if not check_collision(...): apply`).
"""
function flip_pixels(obj::ARGAObject, axis::Symbol)::ARGAObject
    rows = first.(obj.pixels)
    cols = last.(obj.pixels)
    ARGAObject(reflect_pixels(obj.pixels, axis, minimum(rows), maximum(rows), minimum(cols), maximum(cols)), obj.color)
end

"""
    mirror_axis(this, other, ctx)

The `(row, nothing)` or `(nothing, col)` axis to [`mirror_pixels`](@ref)
`this` about, given `other` -- mirrors `ARCGraph.get_mirror_axis`: reflect
across a horizontal line through `other`'s centroid row if `this`/`other`
are "vertical" neighbors, otherwise across a vertical line through
`other`'s centroid column (regardless of whether they're neighbors at all,
matching the reference's unconditional `else` branch).
"""
function mirror_axis(this_obj::ARGAObject, other::ARGAObject, ctx)
    rel = unobstructed_relation(this_obj, other, ctx.grid, ctx.background)
    oc = obj_centroid(other)
    return rel === :vertical ? (oc[1], nothing) : (nothing, oc[2])
end

"""
    mirror_pixels(obj, axis)

Reflect `obj` about an absolute grid axis (`axis` from [`mirror_axis`](@ref),
or `nothing` if no `other` was available, in which case this is a no-op) --
mirrors `ARCGraph.Mirror`'s reflection formula.
"""
function mirror_pixels(obj::ARGAObject, axis)::ARGAObject
    axis === nothing && return obj
    (ay, ax) = axis
    if ay !== nothing
        return ARGAObject([(2 * ay - r, c) for (r, c) in obj.pixels], obj.color)
    else
        return ARGAObject([(r, 2 * ax - c) for (r, c) in obj.pixels], obj.color)
    end
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
    hollow_rectangle_pixels(obj, color, ctx)

Shrink `obj` down to just its bounding-box border pixels; the removed
interior becomes a new `color`-colored object, unless `color` is the
grid's actual background color (`ctx.background`, not a hardcoded `0` --
matches `ARCGraph.hollow_rectangle`'s `color != self.image.background_color`
check), in which case it's dropped. Returns `(border_obj, extras)`.
"""
function hollow_rectangle_pixels(obj::ARGAObject, color::Int, ctx)
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
    extras = color == ctx.background || isempty(interior) ? ARGAObject[] : [ARGAObject(interior, color)]
    return (border_obj, extras)
end

"""
    anchor_point(point, centroid, h, w)

The `(row, col)` named by `point` (one of the 8 [`IMG_TOP`](@ref)-style
symbols), relative to a `h`x`w` grid and (for the edge-midpoint points)
`centroid` -- mirrors `ARCGraph.Insert`'s `ImagePoints` resolution.
"""
function anchor_point(point::Symbol, centroid::Tuple{Int,Int}, h::Int, w::Int)::Tuple{Int,Int}
    point === IMG_TOP && return (1, centroid[2])
    point === IMG_BOTTOM && return (h, centroid[2])
    point === IMG_LEFT && return (centroid[1], 1)
    point === IMG_RIGHT && return (centroid[1], w)
    point === IMG_TOPLEFT && return (1, 1)
    point === IMG_TOPRIGHT && return (1, w)
    point === IMG_BOTTOMLEFT && return (h, 1)
    point === IMG_BOTTOMRIGHT && return (h, w)
    error("ARGA: unknown image point $point")
end

"""
    nearest_image_point(obj, ctx)

Whichever of the 8 [`anchor_point`](@ref)s is (Manhattan-)closest to
`obj`'s centroid -- this file's documented stand-in for `img_pts_of`, which
has no reference definition (see file docstring).
"""
function nearest_image_point(obj::ARGAObject, ctx)::Symbol
    c = obj_centroid(obj)
    points = (IMG_TOP, IMG_BOTTOM, IMG_LEFT, IMG_RIGHT, IMG_TOPLEFT, IMG_TOPRIGHT, IMG_BOTTOMLEFT, IMG_BOTTOMRIGHT)
    dist(p) = (a = anchor_point(p, c, ctx.height, ctx.width); abs(a[1] - c[1]) + abs(a[2] - c[2]))
    return points[argmin(map(dist, points))]
end

"""
    point_from_relative_pos(rel, source, target)

`source` (`this`'s centroid) for [`REL_SOURCE`](@ref), `target` (the
resolved anchor point) for [`REL_TARGET`](@ref), or their midpoint for
[`REL_MIDDLE`](@ref) -- mirrors `ARCGraph.get_point_from_relative_pos`.
"""
function point_from_relative_pos(rel::Symbol, source::Tuple{Int,Int}, target::Tuple{Int,Int})::Tuple{Int,Int}
    rel === REL_SOURCE && return source
    rel === REL_TARGET && return target
    rel === REL_MIDDLE && return ((source[1] + target[1]) ÷ 2, (source[2] + target[2]) ÷ 2)
    error("ARGA: unknown relative position $rel")
end

"""
    insert_pixels(this, src, point, rel, ctx)

A copy of `src`'s pixels (re-centered on the [`point_from_relative_pos`](@ref)
target point, clipped to the grid), in `src`'s color -- mirrors
`ARCGraph.Insert`.
"""
function insert_pixels(this_obj::ARGAObject, src_obj::ARGAObject, point::Symbol, rel::Symbol, ctx)::ARGAObject
    this_centroid = obj_centroid(this_obj)
    anchor = anchor_point(point, this_centroid, ctx.height, ctx.width)
    target = point_from_relative_pos(rel, this_centroid, anchor)
    src_centroid = obj_centroid(src_obj)
    new_pixels = Tuple{Int,Int}[]
    for (r, c) in src_obj.pixels
        p = (target[1] + r - src_centroid[1], target[2] + c - src_centroid[2])
        inbounds(p, ctx.height, ctx.width) && push!(new_pixels, p)
    end
    ARGAObject(new_pixels, src_obj.color)
end

"""
    relative_direction(this, other)

The one of the 8 [`UP`](@ref)-style directions pointing from `this`'s
centroid towards `other`'s, snapping to a diagonal when the row/column
deltas are equal -- this file's documented simplification of
`ARCGraph.get_relative_pos` (see file docstring). `nothing` if the two
centroids coincide.
"""
function relative_direction(this_obj::ARGAObject, other::ARGAObject)
    (ty, tx) = obj_centroid(this_obj)
    (oy, ox) = obj_centroid(other)
    dy, dx = oy - ty, ox - tx
    dy == 0 && dx == 0 && return nothing
    dy == 0 && return dx > 0 ? RIGHT : LEFT
    dx == 0 && return dy > 0 ? DOWN : UP
    abs(dy) == abs(dx) && return dy > 0 ? (dx > 0 ? DOWNRIGHT : DOWNLEFT) : (dx > 0 ? UPRIGHT : UPLEFT)
    return abs(dy) > abs(dx) ? (dy > 0 ? DOWN : UP) : (dx > 0 ? RIGHT : LEFT)
end

# ------------------------------------------------------------------
# ARGATransform (plain data) + Transforms sequencing
# ------------------------------------------------------------------

"""
    ARGATransform

One `xform` production from the lark grammar, as plain data.
"""
struct ARGATransform
    kind::Symbol
    params::Tuple
end

t_update_color(c) = ARGATransform(:update_color, (c,))
t_move(d) = ARGATransform(:move, (d,))
t_extend(d, overlap::Bool) = ARGATransform(:extend, (d, overlap))
t_move_max(d) = ARGATransform(:move_max, (d,))
t_rotate(a::Int) = ARGATransform(:rotate, (a,))
t_add_border(c) = ARGATransform(:add_border, (c,))
t_fill_rectangle(c, overlap::Bool) = ARGATransform(:fill_rectangle, (c, overlap))
t_hollow_rectangle(c) = ARGATransform(:hollow_rectangle, (c,))
t_mirror(v::Symbol) = ARGATransform(:mirror, (v,))
t_flip(axis::Symbol) = ARGATransform(:flip, (axis,))
t_insert(obj_id::Int, point, rel::Symbol) = ARGATransform(:insert, (obj_id, point, rel))
t_noop() = ARGATransform(:noop, ())

mk_single(t::ARGATransform)::Vector{ARGATransform} = [t]
mk_seq(t::ARGATransform, ts::Vector{ARGATransform})::Vector{ARGATransform} = vcat([t], ts)

function resolve_color(e, this_obj::ARGAObject, other)
    e isa AttrOf || return e
    obj = resolve_var_obj(e.var, this_obj, other)
    return obj === nothing ? this_obj.color : obj.color
end

function resolve_direction(e, this_obj::ARGAObject, other)
    e isa AttrOf || return e
    obj = resolve_var_obj(e.var, this_obj, other)
    obj === nothing && return nothing
    return relative_direction(this_obj, obj)
end

function resolve_imgpt(e, this_obj::ARGAObject, other, ctx)
    e isa AttrOf || return e
    obj = resolve_var_obj(e.var, this_obj, other)
    obj === nothing && return IMG_TOP
    return nearest_image_point(obj, ctx)
end

"""
    apply_transform(t, this, other, others, ctx)

Apply a single [`ARGATransform`](@ref) to `this`, with `other` the witness
object bound by [`apply_rule`](@ref)'s filter step (or `nothing`).
`others` is `ctx.objects` minus the *original* self for this whole
`Transforms` sequence. Returns `(continuing_self, extra_objects)`.
"""
function apply_transform(t::ARGATransform, this_obj::ARGAObject, other, others::Vector{ARGAObject}, ctx)
    k = t.kind
    k === :noop && return (this_obj, ARGAObject[])
    if k === :update_color
        return (ARGAObject(this_obj.pixels, resolve_color(t.params[1], this_obj, other)), ARGAObject[])
    end
    if k === :move
        d = resolve_direction(t.params[1], this_obj, other)
        d === nothing && return (this_obj, ARGAObject[])
        return (move_pixels(this_obj, d), ARGAObject[])
    end
    if k === :extend
        d = resolve_direction(t.params[1], this_obj, other)
        d === nothing && return (this_obj, ARGAObject[])
        return (extend_pixels(this_obj, d, t.params[2], others, ctx), ARGAObject[])
    end
    if k === :move_max
        d = resolve_direction(t.params[1], this_obj, other)
        d === nothing && return (this_obj, ARGAObject[])
        return (move_max_pixels(this_obj, d, others, ctx), ARGAObject[])
    end
    k === :rotate && return (rotate_pixels(this_obj, t.params[1]), ARGAObject[])
    if k === :flip
        new_obj = flip_pixels(this_obj, t.params[1])
        return (collides_with(new_obj, others) ? this_obj : new_obj, ARGAObject[])
    end
    if k === :mirror
        target = resolve_var_obj(t.params[1], this_obj, other)
        axis = target === nothing ? nothing : mirror_axis(this_obj, target, ctx)
        new_obj = mirror_pixels(this_obj, axis)
        return (collides_with(new_obj, others) ? this_obj : new_obj, ARGAObject[])
    end
    if k === :add_border
        c = resolve_color(t.params[1], this_obj, other)
        return (this_obj, [add_border_pixels(this_obj, c, others)])
    end
    if k === :fill_rectangle
        c = resolve_color(t.params[1], this_obj, other)
        extra = fill_rectangle_pixels(this_obj, c, t.params[2], others)
        return (this_obj, extra === nothing ? ARGAObject[] : [extra])
    end
    if k === :hollow_rectangle
        c = resolve_color(t.params[1], this_obj, other)
        return hollow_rectangle_pixels(this_obj, c, ctx)
    end
    if k === :insert
        (obj_id, point_expr, rel) = t.params
        (obj_id < 0 || obj_id >= length(ctx.objects)) && return (this_obj, ARGAObject[])
        src = ctx.objects[obj_id+1]
        point = resolve_imgpt(point_expr, this_obj, other, ctx)
        extra = insert_pixels(this_obj, src, point, rel, ctx)
        return (this_obj, isempty(extra.pixels) ? ARGAObject[] : [extra])
    end
    error("ARGA: unknown transform kind $k")
end

"""
    apply_transforms(ts, obj, other, others, ctx)

Apply the `Transform ; Transform ; ...` sequence `ts` to `obj`, threading
the "continuing self" through each step (with `other` fixed for the whole
sequence, same as `others`) while accumulating side objects separately --
a side object created partway through the sequence is *not* itself subject
to later transforms in the same sequence.
"""
function apply_transforms(ts::Vector{ARGATransform}, obj::ARGAObject, other, others::Vector{ARGAObject}, ctx)
    extras = ARGAObject[]
    current = obj
    for t in ts
        (current, e) = apply_transform(t, current, other, others, ctx)
        append!(extras, e)
    end
    return (current, extras)
end

# ------------------------------------------------------------------
# Rule = (vars ...) (filter ...) (apply ...)
# ------------------------------------------------------------------

"""
    apply_rule(grid, decl, filt, transforms)

Decompose `grid` into objects ([`extract_objects`](@ref)). For each `this`
candidate (in raster-scan order): if `decl.use_other`, search every other
object (also raster-scan order) for the first that satisfies `filt` when
bound to `other` and keep it as the witness; otherwise (or if there are no
other objects at all) evaluate `filt` once with `other = nothing`. If
satisfied, [`apply_transforms`](@ref) using that same witness, then
[`render`](@ref) the result back to a grid.

Both the filter and the `other` search see the *original*, pre-transform
object set (so e.g. MIN/MAX/CENTER aggregates and neighbor relations
reflect the untouched grid). Matched objects are transformed in sequence,
each one's collision checks seeing every other object *as it currently
stands* -- already-moved earlier objects free up the space they vacated
for later ones in the same rule application, and not-yet-reached later
objects still block at their original position -- mirroring `ARCGraph.py`'s
shared-graph, sequential-mutation semantics (modulo node-iteration order:
this implementation visits objects in raster-scan order; `ARCGraph.py`
groups by color first).

This is `Start`'s sole production -- the grammar supports exactly one
`Rule`, not the lark grammar's `(do rule*)` sequences (every example
solution in this benchmark's reference solutions uses a single rule).
"""
function apply_rule(grid::ARGAGrid, decl::ARGADecl, filt::ARGAFilter, transforms::Vector{ARGATransform})::ARGAGrid
    h, w = size(grid)
    bg = background_color(grid)
    objects = extract_objects(grid)
    ctx = (objects = objects, height = h, width = w, background = bg, grid = grid)
    world = copy(objects)
    extras_all = ARGAObject[]
    for (i, obj) in enumerate(objects)
        candidates = decl.use_other ? [objects[j] for j in eachindex(objects) if j != i] : ARGAObject[]
        matched = false
        witness = nothing
        if isempty(candidates)
            matched = eval_filter(filt, obj, nothing, ctx)
        else
            for cand in candidates
                if eval_filter(filt, obj, cand, ctx)
                    matched = true
                    witness = cand
                    break
                end
            end
        end
        if matched
            others = [world[j] for j in eachindex(world) if j != i]
            (final_self, extras) = apply_transforms(transforms, obj, witness, others, ctx)
            world[i] = final_self
            append!(extras_all, extras)
        end
    end
    return render(h, w, bg, vcat(world, extras_all))
end
