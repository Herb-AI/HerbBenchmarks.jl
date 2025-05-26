using NPZ

"""
    get_all_problems()::Vector{Problem}

Get all Karel problems from the dataset.
"""
function get_all_problems()::Vector{Problem}
    data = npzread(joinpath(@__DIR__, "data.npz"))
    inputs = data["inputs"]
    outputs = data["outputs"]
    num_examples_per_code = data["num_examples_per_code"]

    problems = Vector{Problem}()
    for pidx in 0:(size(inputs, 1)÷num_examples_per_code-1)
        examples = Vector{IOExample}()
        for eidx in 0:(num_examples_per_code-1)
            # Get 3D slice for this example
            input_array = inputs[pidx*num_examples_per_code+eidx+1, :, :, :]
            output_array = outputs[pidx*num_examples_per_code+eidx+1, :, :, :]
            push!(examples, IOExample(
                Dict(:_arg_1 => input_array),
                output_array
            ))
        end
        push!(problems, Problem(examples))
    end
    return problems
end

"""
    get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}

Get all Karel problems paired with their grammar.
"""
function get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}
    problems = get_all_problems()
    return [ProblemGrammarPair(prob, grammar_karel, i) for (i, prob) in enumerate(problems)]
end

"""
    state_to_array(state::KarelState)::Array{Int8,3}

Convert a KarelState to a 3D array representation for the neural network.
Array dimensions are: [height, width, channels] where channels are:
0-3: Hero direction one-hot (North, South, West, East)
4: Walls
5-15: Number of markers (0-9 markers at position, one-hot encoded)
"""
function state_to_array(state::KarelState)::Array{Int8,3}
    height, width = size(state.world)
    array = zeros(Int8, height, width, 16)
    # Set hero direction - one-hot encoding
    hero_x, hero_y = state.hero.position
    dir = state.hero.direction
    dir_idx = Int(dir)
    array[hero_y, hero_x, dir_idx] = 1
    # Set walls
    array[:, :, 5] = state.world .== WALL_CHAR
    # Set markers - one hot encoding for number of markers (0-10)
    for y in 1:height, x in 1:width
        pos = (x, y)
        num_markers = get(state.markers, pos, 0)
        channel = min(num_markers + 6, 16)
        array[y, x, channel] = 1
    end
    return array
end

"""
    array_to_state(array::Array{Int8,3})::KarelState

Convert a 3D array representation to a KarelState.
Array dimensions are: [height, width, channels] where channels are:
0-3: Hero direction one-hot (North, South, West, East)
4: Walls
5-15: Number of markers (0-9 markers at position, one-hot encoded)
"""
function array_to_state(array::Array{Int8,3})::KarelState
    height, width, _ = size(array)
    # Create world with walls
    world = fill(EMPTY_CHAR, height, width)
    world[array[:, :, 5].>0.5] .= WALL_CHAR # 5th dimension marks whether it's a wall
    # Find hero position and direction
    hero_pos = findfirst(sum(view(array, :, :, 1:4), dims=3)[:, :, 1] .> 0.5)
    if isnothing(hero_pos)
        # Default to position (2,2) if no hero found
        hero_pos = CartesianIndex(2, 2)
    end
    hero_y, hero_x = hero_pos.I
    # Find direction from one-hot encoding
    dir_idx = findfirst(view(array, hero_y, hero_x, 1:4) .> 0.5)
    dir = Direction(dir_idx)
    hero = Hero((hero_x, hero_y), dir)
    # Find markers from one-hot encoding
    markers = Dict{Tuple{Int,Int},Int}()
    for y in 1:height, x in 1:width
        # Find which marker channel is active (if any)
        marker_channel = findfirst(view(array, y, x, 6:16) .> 0.5)
        if !isnothing(marker_channel)
            num_markers = marker_channel - 1
            if num_markers > 0
                markers[(x, y)] = num_markers
            end
        end
    end
    return KarelState(world, markers, hero)
end