"""
Represents the hero/agent in the Karel world with position and facing direction.
"""
struct Hero
    position::Tuple{Int,Int}
    facing::Tuple{Int,Int}
    marker_bag::Union{Nothing,Int}
end

Hero(position::Tuple{Int,Int}, facing::Tuple{Int,Int}) = Hero(position, facing, nothing)

"""
Represents the state of the Karel world including walls, markers, and hero position.
"""
mutable struct KarelState
    world::Matrix{Char}
    markers::Vector{Tuple{Int,Int}}
    hero::Hero
    debug::Bool
end

# Constants for Karel world
const HERO_CHARS = ['<', '^', '>', 'v']
const MARKER_CHAR = 'o'
const WALL_CHAR = '#'
const EMPTY_CHAR = '.'

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
    facing = state.hero.facing
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
        println(io, "Hero facing: ", state.hero.facing)
        println(io, "Marker count: ", length(state.markers))
        if !isnothing(state.hero.marker_bag)
            println(io, "Hero marker bag: ", state.hero.marker_bag)
        end
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
1-4: Hero direction (one-hot)
5: Walls
6-16: Marker counts (0-10)
"""
function state_to_array(state::KarelState)::Array{Float64,3}
    height, width = size(state.world)
    array = zeros(Float64, height, width, 16)
    # Set hero direction
    hero_x, hero_y = state.hero.position
    dir_idx = findfirst(d -> d == state.hero.facing, [(0, 1), (1, 0), (0, -1), (-1, 0)])
    array[hero_y, hero_x, dir_idx] = 1.0
    # Set walls
    array[:, :, 5] = state.world .== WALL_CHAR
    # Set markers
    marker_counts = Dict{Tuple{Int,Int},Int}()
    for marker in state.markers
        marker_counts[marker] = get(marker_counts, marker, 0) + 1
    end
    for ((x, y), count) in marker_counts
        array[y, x, 6+min(count, 10)] = 1.0
    end
    return array
end

"""
    array_to_state(array::Array{Float64,3})::KarelState

Convert a 3D array representation back to a KarelState.
"""
function array_to_state(array::Array{Float64,3})::KarelState
    height, width, _ = size(array)
    # Create world with walls
    world = fill(EMPTY_CHAR, height, width)
    world[array[:, :, 5].>0.5] .= WALL_CHAR
    # Find hero position and direction
    hero_y, hero_x = findfirst(view(array, :, :, 1:4) .> 0.5).I[1:2]
    dir_idx = findfirst(view(array, hero_y, hero_x, 1:4) .> 0.5)
    facing = [(0, 1), (1, 0), (0, -1), (-1, 0)][dir_idx]
    hero = Hero((hero_x, hero_y), facing)
    # Find markers
    markers = Tuple{Int,Int}[]
    for y in 1:height
        for x in 1:width
            marker_count = findfirst(view(array, y, x, 6:16) .> 0.5)
            if !isnothing(marker_count)
                append!(markers, fill((x, y), marker_count - 1))  # -1 because indices 6:16 represent 0-10 markers
            end
        end
    end
    return KarelState(world, markers, hero, false)
end