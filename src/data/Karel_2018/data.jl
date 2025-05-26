using NPZ

"""
    convert_world_to_state(world::Vector{Any})::KarelState

Convert a Karel world from the NPZ format to our KarelState struct.
The world format is [grid, hero_x, hero_y, hero_dir, markers] where:
- grid: Matrix{Int} with 1s for walls
- hero_x, hero_y: Position coordinates
- hero_dir: Direction (0: East, 1: South, 2: West, 3: North)
- markers: Matrix{Int} with marker counts
"""
function convert_world_to_state(world::Vector{Any})::KarelState
    # Extract hero state
    hero_x = world[2]::Int
    hero_y = world[3]::Int
    hero_dir = world[4]::Int
    # Convert direction number to facing vector
    # 0: East (1,0), 1: South (0,1), 2: West (-1,0), 3: North (0,-1)
    facing_vectors = [(1, 0), (0, 1), (-1, 0), (0, -1)]
    hero = Hero((hero_x, hero_y), facing_vectors[hero_dir+1])
    # Convert grid to character matrix for walls
    grid = world[1]::Matrix{Int}
    world_chars = fill(EMPTY_CHAR, size(grid))
    world_chars[grid.==1] .= WALL_CHAR
    # Extract marker positions
    markers = world[5]::Matrix{Int}
    marker_positions = Tuple{Int,Int}[]
    for y in axes(markers, 1), x in axes(markers, 2)
        # Add position once for each marker
        for _ in 1:markers[y, x]
            push!(marker_positions, (x, y))
        end
    end
    return KarelState(world_chars, marker_positions, hero, false)
end

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