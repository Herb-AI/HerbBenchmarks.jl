@enum Direction begin
    NORTH = 1  # (0, -1)
    EAST = 2   # (1, 0)
    SOUTH = 3  # (0, 1)
    WEST = 4   # (-1, 0)
end

"""
Represents the hero/agent in the Karel world with position and facing direction.
"""
mutable struct Hero
    position::Tuple{Int,Int}
    direction::Direction
    marker_count::Int
end

Hero(position::Tuple{Int,Int}, direction::Direction) = Hero(position, direction, 0)

Base.deepcopy(hero::Hero) = Hero(hero.position, hero.direction, hero.marker_count)

Base.:(==)(h1::Hero, h2::Hero) = h1.position == h2.position &&
                                 h1.direction == h2.direction

Base.hash(h::Hero, h0::UInt) = hash(h.position, h0) ⊻ hash(h.direction, h0) ⊻ hash(h.marker_count, h0)

"""
Represents the state of the Karel world including walls, markers, and hero position.
"""
mutable struct KarelState
    world::Matrix{Bool}
    markers::Dict{Tuple{Int,Int},Int}  # Maps position to number of markers
    hero::Hero
    KarelState(world::Matrix{Bool}, hero::Hero) = new(world, Dict{Tuple{Int,Int},Int}(), hero)
    KarelState(world::Matrix{Bool}, markers::Dict{Tuple{Int,Int},Int}, hero::Hero) = new(world, markers, hero)
end

Base.deepcopy(state::KarelState) = KarelState(
    state.world,
    Dict(deepcopy(k) => deepcopy(v) for (k, v) in state.markers),
    deepcopy(state.hero)
)

Base.:(==)(s1::KarelState, s2::KarelState) = s1.markers == s2.markers &&
                                             s1.hero == s2.hero

Base.hash(s::KarelState, h0::UInt) = hash(s.world, h0) ⊻ hash(s.markers, h0) ⊻ hash(s.hero, h0)

# Constants for Karel world printing
const HERO_CHARS = ['<', '^', '>', 'v']
const MARKER_CHAR = 'o'
const WALL_CHAR = '#'
const EMPTY_CHAR = '.'

const DIRECTION_TO_VECTOR = Dict(
    NORTH => (0, -1),
    EAST => (1, 0),
    SOUTH => (0, 1),
    WEST => (-1, 0),
)

const DIRECTION_TO_ARR_IDX = Dict(
    NORTH => 0,
    SOUTH => 1,
    WEST => 2,
    EAST => 3
)

const ARR_IDX_TO_DIRECTION = Dict(
    0 => NORTH,
    1 => SOUTH,
    2 => WEST,
    3 => EAST
)

function Base.show(io::IO, state::KarelState)
    # Get dimensions
    height, width = size(state.world)
    display = fill(EMPTY_CHAR, height, width)
    # Add walls
    for y in 1:height, x in 1:width
        if state.world[y, x]
            display[y, x] = WALL_CHAR
        end
    end
    # Add markers
    for (pos, _) in state.markers
        x, y = pos
        display[y, x] = MARKER_CHAR
    end
    # Add hero with direction
    hero_x, hero_y = state.hero.position
    dir = state.hero.direction
    hero_char = if dir == WEST      # Left
        HERO_CHARS[1]
    elseif dir == NORTH             # Up
        HERO_CHARS[2]
    elseif dir == EAST              # Right
        HERO_CHARS[3]
    else                            # Down
        HERO_CHARS[4]
    end
    display[hero_y, hero_x] = hero_char
    # Print the grid with border
    println(io, "┌" * "─"^width * "┐")
    for row in 1:height
        print(io, "│")
        for col in 1:width
            print(io, display[row, col])
        end
        println(io, "│")
    end
    println(io, "└" * "─"^width * "┘")
end

"""
    create_world(height::Int, width::Int)::Matrix{Bool}

Create a new Karel world of given dimensions with walls around the border.
"""
function create_world(height::Int, width::Int)::Matrix{Bool}
    world = fill(false, height, width)
    world[1, :] .= true  # Top wall
    world[end, :] .= true  # Bottom wall
    world[:, 1] .= true  # Left wall
    world[:, end] .= true  # Right wall
    return world
end

"""
    create_random_world(height::Int, width::Int, wall_ratio::Float64=0.1)::Matrix{Bool}

Create a random Karel world with given dimensions and wall ratio.
"""
function create_random_world(height::Int, width::Int, wall_ratio::Float64=0.1)::Matrix{Bool}
    world = create_world(height, width)
    for i in 2:height-1
        for j in 2:width-1
            if rand() < wall_ratio
                world[i, j] = true
            end
        end
    end
    return world
end

# ─── Internal helpers ─────────────────────────────────────────────────────────

"""
    move(hero::Hero, world::Matrix{Bool})::Bool

Move the hero one step in the direction it's facing if possible.
Returns true if move successful, false if blocked by wall.
"""
function move(hero::Hero, world::Matrix{Bool})::Bool
    facing = DIRECTION_TO_VECTOR[hero.direction]
    next_x = hero.position[1] + facing[1]
    next_y = hero.position[2] + facing[2]
    if world[next_y, next_x]
        return false
    end
    hero.position = (next_x, next_y)
    return true
end

"""
    turn_left(hero::Hero)::Hero

Turn the hero 90 degrees counter-clockwise.
"""
function turn_left(hero::Hero)::Hero
    hero.direction = Direction(mod1(Int(hero.direction) - 1, 4))
    return hero
end

"""
    turn_right(hero::Hero)::Hero

Turn the hero 90 degrees clockwise.
"""
function turn_right(hero::Hero)::Hero
    hero.direction = Direction(mod1(Int(hero.direction) + 1, 4))
    return hero
end

"""
    pick_marker!(state::KarelState)::Bool

Pick up a marker at the hero's current position if one exists.
Returns true if successful, false otherwise.
"""
function pick_marker!(state::KarelState)::Bool
    pos = state.hero.position
    num_markers = get(state.markers, pos, 0)
    if num_markers == 0
        return false
    end
    if num_markers == 1
        delete!(state.markers, pos)
    else
        state.markers[pos] = num_markers - 1
    end
    state.hero.marker_count += 1
    return true
end

"""
    put_marker!(state::KarelState)::Bool

Put down a marker at the hero's current position.
Returns true if successful.
"""
function put_marker!(state::KarelState)::Bool
    if state.hero.marker_count == 0
        return false
    end
    pos = state.hero.position
    state.markers[pos] = get(state.markers, pos, 0) + 1
    state.hero.marker_count -= 1
    return true
end

"""
    front_is_clear(state::KarelState)::Bool

Check if the space in front of the hero is clear.
"""
function front_is_clear(state::KarelState)::Bool
    facing = DIRECTION_TO_VECTOR[state.hero.direction]
    next_x = state.hero.position[1] + facing[1]
    next_y = state.hero.position[2] + facing[2]
    return !state.world[next_y, next_x]
end

"""
    left_is_clear(state::KarelState)::Bool

Check if the space to the left of the hero is clear.
"""
function left_is_clear(state::KarelState)::Bool
    left_hero = turn_left(state.hero)
    facing = DIRECTION_TO_VECTOR[left_hero.direction]
    next_x = left_hero.position[1] + facing[1]
    next_y = left_hero.position[2] + facing[2]
    return !state.world[next_y, next_x]
end

"""
    right_is_clear(state::KarelState)::Bool

Check if the space to the right of the hero is clear.
"""
function right_is_clear(state::KarelState)::Bool
    right_hero = turn_right(state.hero)
    facing = DIRECTION_TO_VECTOR[right_hero.direction]
    next_x = right_hero.position[1] + facing[1]
    next_y = right_hero.position[2] + facing[2]
    return !state.world[next_y, next_x]
end

"""
    markers_present(state::KarelState)::Bool

Check if there are markers at the hero's current position.
"""
function markers_present(state::KarelState)::Bool
    return haskey(state.markers, state.hero.position)
end

"""
    no_markers_present(state::KarelState)::Bool

Check if there are no markers at the hero's current position.
"""
function no_markers_present(state::KarelState)::Bool
    return !markers_present(state)
end

# ─── Grammar primitives for make_stateful_interpreter ─────────────────────────
# Actions: deepcopy state, mutate the copy, return the copy.

move(state::KarelState) = (new = deepcopy(state); move(new.hero, new.world); new)
turnLeft(state::KarelState) = (new = deepcopy(state); new.hero = turn_left(new.hero); new)
turnRight(state::KarelState) = (new = deepcopy(state); new.hero = turn_right(new.hero); new)
pickMarker(state::KarelState) = (new = deepcopy(state); pick_marker!(new); new)
putMarker(state::KarelState) = (new = deepcopy(state); put_marker!(new); new)
noop(state::KarelState) = state

# Conditions: read KarelState, return Bool.

frontIsClear(state::KarelState) = front_is_clear(state)
leftIsClear(state::KarelState) = left_is_clear(state)
rightIsClear(state::KarelState) = right_is_clear(state)
markersPresent(state::KarelState) = markers_present(state)
noMarkersPresent(state::KarelState) = no_markers_present(state)
NOT(x::Bool) = !x
