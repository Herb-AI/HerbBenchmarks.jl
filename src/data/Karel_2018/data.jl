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
    for y in 1:size(markers, 1), x in 1:size(markers, 2)
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
    # inputs = data["inputs"]
    # outputs = data["outputs"]
    # num_examples_per_code = data["num_examples_per_code"]
    # problems = Vector{Problem}()

    # for prog_idx in 1:(length(inputs)/num_examples_per_code)
    #     # Create IOExamples for this program
    #     examples = Vector{IOExample}()
    #     for i in ((prog_idx-1)*num_examples_per_code+1):(prog_idx*num_examples_per_code)
    #         input_state = convert_world_to_state(inputs[i])
    #         output_state = convert_world_to_state(outputs[i])

    #         # Convert states to array format for consistency with other benchmarks
    #         example = IOExample(
    #             Dict(:_arg_1 => state_to_array(input_state)),
    #             state_to_array(output_state)
    #         )
    #         push!(examples, example)
    #     end
    #     push!(problems, Problem(examples))
    # end
    return []
end

"""
    get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}

Get all Karel problems paired with their grammar.
"""
function get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}
    problems = get_all_problems()
    return [ProblemGrammarPair(prob, grammar_karel, i) for (i, prob) in enumerate(problems)]
end