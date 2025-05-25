using LinearAlgebra

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

"""
    move(hero::Hero, world::Matrix{Char})::Union{Hero,Nothing}

Move the hero one step in the direction it's facing if possible.
Returns new hero state if move successful, nothing if blocked.
"""
function move(hero::Hero, world::Matrix{Char})::Union{Hero,Nothing}
    next_x = hero.position[1] + hero.facing[1]
    next_y = hero.position[2] + hero.facing[2]
    if world[next_y, next_x] == WALL_CHAR
        return nothing
    end
    return Hero((next_x, next_y), hero.facing, hero.marker_bag)
end

"""
    turn_left(hero::Hero)::Hero

Turn the hero 90 degrees counter-clockwise.
"""
function turn_left(hero::Hero)::Hero
    new_facing = (hero.facing[2], -hero.facing[1])
    return Hero(hero.position, new_facing, hero.marker_bag)
end

"""
    turn_right(hero::Hero)::Hero

Turn the hero 90 degrees clockwise.
"""
function turn_right(hero::Hero)::Hero
    new_facing = (-hero.facing[2], hero.facing[1])
    return Hero(hero.position, new_facing, hero.marker_bag)
end

"""
    pick_marker!(state::KarelState)::Bool

Pick up a marker at the hero's current position if one exists.
Returns true if successful, false otherwise.
"""
function pick_marker!(state::KarelState)::Bool
    pos = state.hero.position
    idx = findfirst(m -> m == pos, state.markers)
    if isnothing(idx)
        return false
    end
    deleteat!(state.markers, idx)
    return true
end

"""
    put_marker!(state::KarelState)::Bool

Put down a marker at the hero's current position.
Returns true if successful.
"""
function put_marker!(state::KarelState)::Bool
    push!(state.markers, state.hero.position)
    return true
end

"""
    front_is_clear(state::KarelState)::Bool

Check if the space in front of the hero is clear.
"""
function front_is_clear(state::KarelState)::Bool
    next_x = state.hero.position[1] + state.hero.facing[1]
    next_y = state.hero.position[2] + state.hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    left_is_clear(state::KarelState)::Bool

Check if the space to the left of the hero is clear.
"""
function left_is_clear(state::KarelState)::Bool
    left_hero = turn_left(state.hero)
    next_x = left_hero.position[1] + left_hero.facing[1]
    next_y = left_hero.position[2] + left_hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    right_is_clear(state::KarelState)::Bool

Check if the space to the right of the hero is clear.
"""
function right_is_clear(state::KarelState)::Bool
    right_hero = turn_right(state.hero)
    next_x = right_hero.position[1] + right_hero.facing[1]
    next_y = right_hero.position[2] + right_hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    markers_present(state::KarelState)::Bool

Check if there are markers at the hero's current position.
"""
function markers_present(state::KarelState)::Bool
    return state.hero.position in state.markers
end

"""
    no_markers_present(state::KarelState)::Bool

Check if there are no markers at the hero's current position.
"""
function no_markers_present(state::KarelState)::Bool
    return !markers_present(state)
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
            count = findfirst(view(array, y, x, 6:16) .> 0.5)
            if !isnothing(count)
                for _ in 1:count
                    push!(markers, (x, y))
                end
            end
        end
    end
    return KarelState(world, markers, hero, false)
end