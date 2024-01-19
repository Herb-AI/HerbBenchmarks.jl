function make_stacks()
    return Dict{Symbol,Any}(
        :char => [],
        :float => [],
        :integer => [],
        :string => [],
        :boolean => [],
    )
end

function get_output_from_stack(output_id::Symbol, type_of_output::Type, state::Dict)
    """
    Adds the first value in the stack of the type_of_output to the output.

    For example, if the :char stack is ['a', 'b', 'c'], then the following
    call will add 'a' to the output with id `:output1`.

    `get_output_from_stack(:output1, char, state)`

    Args:
        output_id (Symbol): The output id to add the value to
        type_of_output (Symbol): The type of the output value
        state (Dict): The state of the program
    
    Returns:
        Dict: The state of the program
    """
    if type_of_output <: Char
        if length(state[:char]) > 0 
            println(state[:char][1])
            state[output_id] = state[:char][1]
        end
    elseif type_of_output <: String
        if length(state[:string]) > 0
            state[output_id] = state[:string][1]
        end
    elseif type_of_output <: Bool
        if length(state[:boolean]) > 0
            state[output_id] = state[:boolean][1]
        end
    elseif type_of_output <: AbstractFloat
        if length(state[:float]) > 0
            state[output_id] = state[:float][1]
        end
    elseif type_of_output <: Integer
        if length(state[:integer]) > 0
            state[output_id] = state[:integer][1]
        end
    else
        println("Could not match type_of_output: ", type_of_output)
    end
    return state
end

function write_input_to_stack(input_id::Symbol, input_value::Any, state::Dict)
    """
    Adds the input symbol to the state, mapped to the input value.

    Args:
        input_id (Symbol): The input id to which the value belongs
        input_valae (Any): The input value
        state (Dict): The state of the program
    
    Returns:
        Dict: The state of the program
    """
    state[input_id] = input_value
    return state
end

