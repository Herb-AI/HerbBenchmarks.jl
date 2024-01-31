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
        state[output_id] = pop!(state[:char])
    elseif type_of_output <: String
            state[output_id] = pop!(state[:string])
    elseif type_of_output <: Bool
            state[output_id] = pop!(state[:boolean])
    elseif type_of_output <: AbstractFloat
            state[output_id] = pop!(state[:float])
    elseif type_of_output <: Integer
            state[output_id] = pop!(state[:integer])
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
	stack_to_push_to = missing
	if typeof(input_value) <: Char
		stack_to_push_to = :char
	elseif input_value isa AbstractString
		stack_to_push_to = :string
	elseif input_value isa Bool
		stack_to_push_to = :boolean
	elseif input_value isa Integer
		stack_to_push_to = :integer
	else
		error("No stack for $typeof(input_value)")
	end
	
	push!(state[stack_to_push_to], input_value)
    return state
end

