using NPZ

"""
    load_karel_data(file_path::String)::Vector{IOExample}

Load Karel examples from an NPZ file. The file should contain:
- 'x': Input states as 3D arrays [height, width, channels]
- 'y': Output states as 3D arrays [height, width, channels]
"""
function load_karel_data(file_path::String)::Vector{IOExample}
    data = npzread(file_path)
    input_states = data["x"]  # 4D array [num_examples, height, width, channels]
    output_states = data["y"]  # 4D array [num_examples, height, width, channels]
    # Convert to IOExamples
    examples = Vector{IOExample}()
    for i in eachindex(input_states)
        input_state = input_states[i, :, :, :]
        output_state = output_states[i, :, :, :]
        # Create IOExample with states
        example = IOExample(
            Dict(:_arg_1 => input_state),
            output_state
        )
        push!(examples, example)
    end
    return examples
end

"""
    get_all_problems()::Vector{Problem}

Get all Karel problems from the dataset.
"""
function get_all_problems()::Vector{Problem}
    data_path = joinpath(@__DIR__, "data.npz")
    examples = load_karel_data(data_path)
    # Treat each example as a separate problem for now
    return [Problem([example]) for example in examples]
end

"""
    get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}

Get all Karel problems paired with their grammar.
"""
function get_all_problem_grammar_pairs()::Vector{ProblemGrammarPair}
    problems = get_all_problems()
    return [ProblemGrammarPair(prob, grammar_karel, i) for (i, prob) in enumerate(problems)]
end