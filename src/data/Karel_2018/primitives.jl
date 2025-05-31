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
    walls::Matrix{Bool}
    markers::Dict{Tuple{Int,Int},Int}  # Maps position to number of markers
    hero::Hero
end

KarelState(world::Matrix{Bool}, hero::Hero) = KarelState(world, Dict{Tuple{Int,Int},Int}(), hero)

Base.deepcopy(state::KarelState) = KarelState(
    state.walls,
    Dict(deepcopy(k) => deepcopy(v) for (k, v) in state.markers),
    deepcopy(state.hero)
)

Base.:(==)(s1::KarelState, s2::KarelState) = s1.markers == s2.markers &&
                                             s1.hero == s2.hero

Base.hash(s::KarelState, h0::UInt) = hash(s.walls, h0) ⊻ hash(s.markers, h0) ⊻ hash(s.hero, h0)

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
    height, width = size(state.walls)
    display = fill(EMPTY_CHAR, height, width)
    # Add walls
    for y in 1:height, x in 1:width
        if state.walls[y, x]
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