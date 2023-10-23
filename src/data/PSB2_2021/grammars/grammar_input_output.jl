include("util.jl")


struct MetaValue{T}
    value::T
    metadata::Dict{Symbol, Any}
end

function with_meta(obj, meta::Dict{Symbol, Any})
    return MetaValue(obj, meta)
end

function get_meta(meta_value::MetaValue)
    return meta_value.metadata
end

function printer(type)
    return function (state)
        if isempty(state[type])
            return state
        end
        
        top_thing = state[type][end]
        top_thing_string = ""
        
        if isa(top_thing, String) || isa(top_thing, Char)
            top_thing_string = top_thing
        elseif isa(top_thing, Float)
            top_thing_string = string(round_to_n_decimal_places(top_thing, 10))
        else
            top_thing_string = string(top_thing)
        end
        
        if length(string(stack_ref(:output, 0, state), top_thing_string)) < max_string_length
            return state
        else
            return stack_assoc(string(stack_ref(:output, 0, state), top_thing_string), :output, 1, pop_item(type, state))
        end
    end
end

# const print_exec = with_meta(printer(:exec), Dict(:stack_types => [:print, :exec], :parentheses => 1))
# const print_integer = with_meta(printer(:integer), Dict(:stack_types => [:print, :integer]))
# const print_float = with_meta(printer(:float), Dict(:stack_types => [:print, :float]))
# const print_code = with_meta(printer(:code), Dict(:stack_types => [:print, :code]))
# const print_boolean = with_meta(printer(:boolean), Dict(:stack_types => [:print, :boolean]))
# const print_string = with_meta(printer(:string), Dict(:stack_types => [:print, :string]))
const print_char = printer(:char)
# const print_vector_integer = with_meta(printer(:vector_integer), Dict(:stack_types => [:print, :vector_integer]))
# const print_vector_float = with_meta(printer(:vector_float), Dict(:stack_types => [:print, :vector_float]))
# const print_vector_boolean = with_meta(printer(:vector_boolean), Dict(:stack_types => [:print, :vector_boolean]))
# const print_vector_string = with_meta(printer(:vector_string), Dict(:stack_types => [:print, :vector_string]))

function print_newline(state)
    if length(string(stack_ref(:output, 0, state), '\n')) < max_string_length
        return state
    else
        return stack_assoc(string(stack_ref(:output, 0, state), '\n'), :output, 0, state)
    end
end

    function handle_input_instruction(instr, state)
    if state[:autoconstructing]
        return state
    end
    
    instr_str = string(instr)
    n_str = match(r"in(\d+)", instr_str).match
    n = parse(Int, n_str)
    
    if n > length(state[:input]) || n < 1
        error("Undefined instruction: $instr\nNOTE: Likely not the same number of items on the input stack as input instructions.")
    end
    
    item = stack_ref(:input, n - 1, state)
    literal_type = recognize_literal(item)
    
    if isempty(item) || (isvector(item) && isempty(item))
        state = push_item([], :vector_integer, push_item([], :vector_float, push_item([], :vector_string, push_item([], :vector_boolean, state))))
    elseif isseq(item)
        state = push_item(item, :exec, state)
    else
        state = push_item(item, literal_type, state)
    end
    
    return state
end

function recognize_literal(thing)
    for (type, pred) in literals
        if pred(thing)
            return type
        end
    end
    return false
end

function round_to_n_decimal_places(f, n)
    if !isnumber(f)
        return f
    end
    
    factor = 10.0^n
    return round(f * factor) / factor
end

