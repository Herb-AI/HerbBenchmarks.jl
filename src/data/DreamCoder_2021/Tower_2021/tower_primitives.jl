"""
Primitives for DreamCoder's block-tower domain.

A program controls a "hand" that slides left and right along the ground and
drops blocks; the task is to reproduce a target tower. This mirrors
`dreamcoder/domains/tower/towerPrimitives.py` and `tower_common.py`.

Every operation denotes a **function from `TowerState` to `TowerState`**, and
programs are built by composing those functions with [`seq`](@ref),
[`tower_loop`](@ref) and [`tower_embed`](@ref). Writing the domain this way
keeps it first-order — the grammar composes function *values*, so no rule ever
has to bind a variable — while still giving `tower_loop` a body it can run
more than once.
"""

"""
    TowerState(hand, blocks)

Position of the hand plus the blocks dropped so far, in placement order.

Each block is `(x, w, h)`, where `x` is the hand position it was dropped from
and `w`/`h` are *doubled* dimensions, exactly as in DreamCoder — a `3x1` block
is stored as `(x, 6, 2)`. Doubling keeps every coordinate an integer once
blocks are centred on their `x`.
"""
struct TowerState
    hand::Int
    blocks::Vector{NTuple{3,Int}}
end

TowerState() = TowerState(0, NTuple{3,Int}[])

"""
    place_v(state)

Drop a `1x3` (upright) block at the hand's position.
"""
place_v(state::TowerState) =
    TowerState(state.hand, vcat(state.blocks, [(state.hand, 2, 6)]))

"""
    place_h(state)

Drop a `3x1` (flat) block at the hand's position.
"""
place_h(state::TowerState) =
    TowerState(state.hand, vcat(state.blocks, [(state.hand, 6, 2)]))

"""
    move_right(n)

The operation that moves the hand `n` steps to the right.
"""
move_right(n::Integer) = state::TowerState -> TowerState(state.hand + n, state.blocks)

"""
    move_left(n)

The operation that moves the hand `n` steps to the left.
"""
move_left(n::Integer) = state::TowerState -> TowerState(state.hand - n, state.blocks)

"""
    seq(f, g)

Run operation `f`, then operation `g`.
"""
seq(f, g) = state::TowerState -> g(f(state))

"""
    tower_loop(n, body)

Run `body` `n` times. DreamCoder's `tower_loopM` also passes the iteration
index to the body; a context-free grammar cannot bind that index, so this
loop is a plain repetition. Nothing becomes unbuildable — any finite tower can
be written as a straight-line program — but some reference solutions are
longer here than in the original DSL.
"""
function tower_loop(n::Integer, body)
    return function (state::TowerState)
        for _ in 1:n
            state = body(state)
        end
        return state
    end
end

"""
    tower_embed(body)

Run `body`, then move the hand back to where it was. DreamCoder's
`tower_embed`: blocks dropped by `body` are kept, hand movement is undone.
"""
tower_embed(body) =
    state::TowerState -> TowerState(state.hand, body(state).blocks)

"""
    settle(blocks)

Drop each block straight down onto whatever is already beneath it, returning
`(x, y, w, h)` tuples sorted by position. Port of `simulateWithoutPhysics`.
"""
function settle(blocks::AbstractVector{<:NTuple{3,Int}})
    world = NTuple{4,Int}[]
    for (x, w, h) in blocks
        lowest = h ÷ 2
        for (x2, y2, w2, h2) in world
            # Blocks that do not overlap horizontally do not support each other.
            (x2 - w2 / 2 >= x + w / 2 || x - w / 2 >= x2 + w2 / 2) && continue
            lowest = max(lowest, y2 + h2 ÷ 2 + h ÷ 2)
        end
        push!(world, (x, lowest, w, h))
    end
    return sort(world)
end

"""
    center(world)

Translate a settled tower so that it is centred on `x = 0`, which makes the
specification independent of where the hand happened to start. Port of
`centerTower`.
"""
function center(world::AbstractVector{<:NTuple{4,Int}})
    isempty(world) && return NTuple{4,Int}[]
    xs = [x for (x, _, _, _) in world]
    c = Int(floor((maximum(xs) - minimum(xs)) / 2.0)) + minimum(xs)
    return sort([(x - c, y, w, h) for (x, y, w, h) in world])
end

"""
    run_tower(program, state)

Run a tower `program` from `state` and return the target representation: the
blocks after settling and centring. This is the value a problem's
`IOExample` output is compared against.
"""
run_tower(program, state::TowerState) = center(settle(program(state).blocks))
