"""
The voxel canvas the 3D-Craft houses are built on, and the primitives a program
builds with.

3D-Craft records a house as an *ordered* sequence of single-block placements
and removals -- that order is the point of the dataset, and of the paper's
order-aware model. The DSL here is that action alphabet (`select`, `place`,
`remove`, cursor moves) plus the bulk operations a human is implicitly using
when they lay a wall or a floor one block at a time: [`fill_x`](@ref) and
friends for runs, [`fill_box`](@ref) for solids, [`box_shell`](@ref) for the
hollow box that is most of a house.

Every primitive is a function `HouseState -> HouseState` that mutates and
returns its argument, and [`build_house`](@ref) copies before running, so a
program never disturbs the problem it was run on.
"""

"""
    MAX_ACTIONS

The action budget of a build. Bounds [`repeat_op`](@ref) and stops a runaway
program from filling memory.
"""
const MAX_ACTIONS = 4096

"""
    MAX_BLOCKS

The largest canvas a program may build. The biggest house in the dataset is
about 5,500 blocks, so this leaves ample room while still capping a program
that does nothing but fill space.
"""
const MAX_BLOCKS = 20_000

"""
    HouseState

A build in progress: the blocks placed so far, where the cursor is, and which
block type is selected.

`canvas` maps `(x, y, z)` to a Minecraft block id, with `y` pointing up.
Coordinates are relative to the house's own bounding box -- the dataset's
absolute world coordinates are translated so that the lowest corner is the
origin -- which is why a program can start at `(0, 0, 0)` and mean it.
"""
mutable struct HouseState
    canvas::Dict{NTuple{3,Int},Int}
    cursor::NTuple{3,Int}
    block::Int
    budget::Int
end

"""
    HouseState(; cursor=(0, 0, 0), block=0, budget=MAX_ACTIONS)

An empty canvas, ready to build on.
"""
HouseState(; cursor::NTuple{3,Int}=(0, 0, 0), block::Int=0, budget::Int=MAX_ACTIONS) =
    HouseState(Dict{NTuple{3,Int},Int}(), cursor, block, budget)

Base.copy(s::HouseState) = HouseState(copy(s.canvas), s.cursor, s.block, s.budget)

Base.:(==)(a::HouseState, b::HouseState) =
    a.canvas == b.canvas && a.cursor == b.cursor && a.block == b.block

"""
    spend!(state) -> Bool

Charge one action against the budget, returning whether the build may continue.
Every primitive begins with this.
"""
function spend!(s::HouseState)
    s.budget > 0 || return false
    s.budget -= 1
    return true
end

"""
    write_block!(state, cell)

Write the selected block at `cell`, unless the canvas is already at
[`MAX_BLOCKS`](@ref).

`select` has to have happened first: block id `0` is air, and placing it is a
no-op rather than a way to write holes.
"""
function write_block!(s::HouseState, cell::NTuple{3,Int})
    s.block == 0 && return s
    (length(s.canvas) >= MAX_BLOCKS && !haskey(s.canvas, cell)) && return s
    s.canvas[cell] = s.block
    return s
end

# ---------------------------------------------------------------------------
# The recorded action alphabet
# ---------------------------------------------------------------------------

"""
    select(block)

An operation selecting `block` as the type future placements will use.
"""
select(block::Int) = function (s::HouseState)
    spend!(s) || return s
    s.block = block
    return s
end

"""
    place(state)

Place the selected block at the cursor.
"""
place(s::HouseState) = spend!(s) ? write_block!(s, s.cursor) : s

"""
    remove(state)

Clear whatever is at the cursor. 3D-Craft records block breaks alongside
placements, and a house is the net result of both.
"""
function remove(s::HouseState)
    spend!(s) || return s
    delete!(s.canvas, s.cursor)
    return s
end

"""
    move_x(n)

An operation moving the cursor `n` cells along the `x` axis; `n` may be
negative.
"""
move_x(n::Int) = (s::HouseState) -> spend!(s) ? (s.cursor = s.cursor .+ (n, 0, 0); s) : s

"""
    move_y(n)

An operation moving the cursor `n` cells along the `y` axis (up is positive).
"""
move_y(n::Int) = (s::HouseState) -> spend!(s) ? (s.cursor = s.cursor .+ (0, n, 0); s) : s

"""
    move_z(n)

An operation moving the cursor `n` cells along the `z` axis.
"""
move_z(n::Int) = (s::HouseState) -> spend!(s) ? (s.cursor = s.cursor .+ (0, 0, n); s) : s

# ---------------------------------------------------------------------------
# Bulk shapes
# ---------------------------------------------------------------------------

"""
    fill_along(state, axis, n)

Place a run of blocks from the cursor to `n` cells along `axis` inclusive,
leaving the cursor at the far end.

`n` may be negative, in which case the run goes the other way.
"""
function fill_along(s::HouseState, axis::NTuple{3,Int}, n::Int)
    spend!(s) || return s
    for i in 0:abs(n)
        write_block!(s, s.cursor .+ (sign(n) * i) .* axis)
    end
    s.cursor = s.cursor .+ n .* axis
    return s
end

"""
    fill_x(n)

An operation drawing a run of `abs(n) + 1` blocks along `x`. This is the wall
or floor edge a human lays one `place` at a time.
"""
fill_x(n::Int) = (s::HouseState) -> fill_along(s, (1, 0, 0), n)

"""
    fill_y(n)

An operation drawing a run of `abs(n) + 1` blocks along `y` -- a pillar.
"""
fill_y(n::Int) = (s::HouseState) -> fill_along(s, (0, 1, 0), n)

"""
    fill_z(n)

An operation drawing a run of `abs(n) + 1` blocks along `z`.
"""
fill_z(n::Int) = (s::HouseState) -> fill_along(s, (0, 0, 1), n)

"""
    box_corners(state, dx, dy, dz) -> (lo, hi)

The inclusive corners of the box spanned by the cursor and the cursor offset by
`(dx, dy, dz)`, normalised so `lo` is the lower corner whatever the signs.
"""
function box_corners(s::HouseState, dx::Int, dy::Int, dz::Int)
    far = s.cursor .+ (dx, dy, dz)
    return (min.(s.cursor, far), max.(s.cursor, far))
end

"""
    fill_box(dx, dy, dz)

An operation filling the solid box spanned by the cursor and the cursor offset
by `(dx, dy, dz)`. The cursor does not move, so several boxes can be stacked
from one anchor.
"""
function fill_box(dx::Int, dy::Int, dz::Int)
    return function (s::HouseState)
        spend!(s) || return s
        (lo, hi) = box_corners(s, dx, dy, dz)
        for x in lo[1]:hi[1], y in lo[2]:hi[2], z in lo[3]:hi[3]
            write_block!(s, (x, y, z))
        end
        return s
    end
end

"""
    box_shell(dx, dy, dz)

An operation building the hollow shell of the box spanned by the cursor and the
cursor offset by `(dx, dy, dz)`: four walls, a floor and a roof, one block
thick.

This is the shape most of the dataset's houses are, which is why it earns a
primitive of its own rather than being spelled out as six `fill_box`es.
"""
function box_shell(dx::Int, dy::Int, dz::Int)
    return function (s::HouseState)
        spend!(s) || return s
        (lo, hi) = box_corners(s, dx, dy, dz)
        for x in lo[1]:hi[1], y in lo[2]:hi[2], z in lo[3]:hi[3]
            on_face = x == lo[1] || x == hi[1] || y == lo[2] || y == hi[2] ||
                      z == lo[3] || z == hi[3]
            on_face && write_block!(s, (x, y, z))
        end
        return s
    end
end

# ---------------------------------------------------------------------------
# Composition
# ---------------------------------------------------------------------------

"""
    seq(operation, rest)

Run `operation`, then `rest`.
"""
seq(operation, rest) = (s::HouseState) -> rest(operation(s))

"""
    repeat_op(count, body)

Run `body` `count` times. Rows of windows, courses of bricks and staircases are
all this.
"""
function repeat_op(count::Int, body)
    return function (s::HouseState)
        for _ in 1:count
            s = body(s)
        end
        return s
    end
end

"""
    embed(body)

Run `body`, then restore the cursor and the selected block.

Without this, every excursion to build a detail would have to be undone by hand
with a counting `move`, and the counting would have to be redone whenever the
detail changed.
"""
function embed(body)
    return function (s::HouseState)
        (cursor, block) = (s.cursor, s.block)
        s = body(s)
        s.cursor = cursor
        s.block = block
        return s
    end
end

"""
    build_house(program, state) -> Dict{NTuple{3,Int},Int}

Run `program` on a copy of `state` and return the blocks it placed.

The canvas alone is the result -- where the cursor ended up is an
implementation detail of the plan, not part of the house -- so two programs
that build the same house compare equal however they got there.
"""
build_house(program, state::HouseState) = program(copy(state)).canvas

"""
    final_state(program, state) -> HouseState

Run `program` on a copy of `state` and return the whole resulting state, rather
than just the canvas. The visualiser uses this.
"""
final_state(program, state::HouseState) = program(copy(state))
