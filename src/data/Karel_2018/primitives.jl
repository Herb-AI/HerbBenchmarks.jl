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

"""
Represents the state of the Karel world including walls, markers, and hero position.
"""
mutable struct KarelState
    world::Matrix{Char}
    markers::Dict{Tuple{Int,Int},Int}  # Maps position to number of markers
    hero::Hero
end

KarelState(world::Matrix{Char}, hero::Hero) = KarelState(world, Dict{Tuple{Int,Int},Int}(), hero)

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
    display = copy(state.world)
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
    create_world(height::Int, width::Int)::Matrix{Char}

Create a new Karel world of given dimensions with walls around the border.
"""
function create_world(height::Int, width::Int)::Matrix{Char}
    world = fill(EMPTY_CHAR, height, width)
    world[1, :] .= WALL_CHAR  # Top wall
    world[end, :] .= WALL_CHAR  # Bottom wall
    world[:, 1] .= WALL_CHAR  # Left wall
    world[:, end] .= WALL_CHAR  # Right wall
    return world
end

"""
    create_random_world(height::Int, width::Int, wall_ratio::Float64=0.1)::Matrix{Char}

Create a random Karel world with given dimensions and wall ratio.
"""
function create_random_world(height::Int, width::Int, wall_ratio::Float64=0.1)::Matrix{Char}
    world = create_world(height, width)
    for i in 2:height-1
        for j in 2:width-1
            if rand() < wall_ratio
                world[i, j] = WALL_CHAR
            end
        end
    end
    return world
end