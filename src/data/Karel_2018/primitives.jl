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
    markers::Vector{Tuple{Int,Int}}
    hero::Hero
end

# Constants for Karel world
const HERO_CHARS = ['<', '^', '>', 'v']
const MARKER_CHAR = 'o'
const WALL_CHAR = '#'
const EMPTY_CHAR = '.'

# Direction mapping dictionaries
const DIRECTION_TO_VECTOR = Dict(
    NORTH => (0, -1),
    EAST => (1, 0),
    SOUTH => (0, 1),
    WEST => (-1, 0),
)

const VECTOR_TO_DIRECTION = Dict(
    (0, -1) => NORTH,
    (1, 0) => EAST,
    (0, 1) => SOUTH,
    (-1, 0) => WEST,
)

# Convert Direction to facing vector
function direction_to_vector(dir::Direction)::Tuple{Int,Int}
    return DIRECTION_TO_VECTOR[dir]
end

# Convert facing vector to Direction
function vector_to_direction(facing::Tuple{Int,Int})::Direction
    return VECTOR_TO_DIRECTION[facing]
end

function Base.show(io::IO, state::KarelState)
    # Get dimensions
    height, width = size(state.world)
    display = copy(state.world)
    # Add markers
    for marker in state.markers
        display[marker[2], marker[1]] = MARKER_CHAR
    end
    # Add hero with direction
    hero_x, hero_y = state.hero.position
    facing = state.hero.direction
    hero_char = if facing == (-1, 0)  # Left
        HERO_CHARS[1]
    elseif facing == (0, -1)          # Up
        HERO_CHARS[2]
    elseif facing == (1, 0)           # Right
        HERO_CHARS[3]
    else                              # Down
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
    # Print debug info if enabled
    if state.debug
        println(io, "Hero position: ", state.hero.position)
        println(io, "Hero direction: ", state.hero.direction)
        println(io, "Marker count: ", length(state.markers))
        println(io, "Marker count on hero: ", state.hero.marker_count)
    end
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

"""
    state_to_array(state::KarelState)::Array{Float64,3}

Convert a KarelState to a 3D array representation for the neural network.
Array dimensions are: [height, width, channels] where channels are:
0-3: Hero direction one-hot (North, South, West, East)
4: Walls
5-15: Number of markers (0-10 markers at position)
"""
function state_to_array(state::KarelState)::Array{Float64,3}
    height, width = size(state.world)
    array = zeros(Float64, height, width, 16)
    # Set hero direction - convert facing vector to direction enum then to channel index
    hero_x, hero_y = state.hero.position
    dir = state.hero.direction
    dir_idx = Int(dir)  # Use enum value directly as channel index
    array[hero_y, hero_x, dir_idx] = 1.0
    # Set walls
    array[:, :, 5] = state.world .== WALL_CHAR
    # Set markers - count markers at each position
    marker_counts = Dict{Tuple{Int,Int},Int}()
    for marker in state.markers
        marker_counts[marker] = get(marker_counts, marker, 0) + 1
    end
    # Set marker channels (channel 6 for 1 marker, channel 7 for 2 markers, etc.)
    for ((x, y), count) in marker_counts
        channel = min(count + 5, 15)  # channel 6-15 for 1-10 markers
        array[y, x, channel] = 1.0
    end
    return array
end

"""
    array_to_state(array::Array{Float64,3})::KarelState

Convert a 3D array representation to a KarelState.
Array dimensions are: [height, width, channels] where channels are:
0-3: Hero direction one-hot (North, South, West, East)
4: Walls
5-15: Number of markers (0-10 markers at position)
"""
function array_to_state(array::Array{Float64,3})::KarelState
    height, width, _ = size(array)
    # Create world with walls
    world = fill(EMPTY_CHAR, height, width)
    world[array[:, :, 5].>0.5] .= WALL_CHAR
    # Find hero position and direction
    hero_pos = findfirst(sum(view(array, :, :, 1:4), dims=3)[:, :, 1] .> 0.5)
    if isnothing(hero_pos)
        # Default to position (1,1) if no hero found
        hero_pos = CartesianIndex(1, 1)
    end
    hero_y, hero_x = hero_pos.I
    # Find direction from one-hot encoding
    dir_idx = findfirst(view(array, hero_y, hero_x, 1:4) .> 0.5)
    dir = Direction(dir_idx)  # Convert channel index directly to Direction enum
    hero = Hero((hero_x, hero_y), dir)
    # Find markers - channels 6-15 represent 1-10 markers
    markers = Tuple{Int,Int}[]
    for y in 1:height, x in 1:width
        # Check each marker channel (6-15)
        for i in 6:15
            if array[y, x, i] > 0.5
                # Channel i represents (i-5) markers
                append!(markers, fill((x, y), i - 5))
            end
        end
    end
    return KarelState(world, markers, hero)
end