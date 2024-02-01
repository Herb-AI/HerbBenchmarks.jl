function get_grammar(names::Vector{String}, p::Problem, mod::Module)
    """
    Function to create grammar for this problem. `names` specifies the subgrammars to use.
    TODO initialize grammars based on benchmark.
    """
    g = make_input_output_grammar(p.examples, mod)
    if "integer" in names
        Base.include(mod, "grammars/grammar_numbers.jl")
        g = merge_grammar([g, g_integer])
    end
    if "float" in names
        Base.include(mod, "grammars/grammar_numbers.jl")
        g = merge_grammar([g, g_float])
    end
    if "string" in names
        Base.include(mod, "grammars/grammar_string.jl")
        g = merge_grammar([g, g_string])
    end
    if "char" in names
        Base.include(mod, "grammars/grammar_char.jl")
        g = merge_grammar([g, g_char])
    end
    if "bool" in names
        Base.include(mod, "grammars/grammar_bool.jl")
        g = merge_grammar([g, g_bool])
    end
    if "random" in names
        Base.include(mod, "grammars/grammar_random.jl")
        g = merge_grammar([g, g_random])
    end
    return g
end

function make_input_output_grammar(ex::Vector{Example}, mod::Module)
    """Creates the grammar for the input and output values, using functions to write the input type to the stack and retrieve it for the output."""
	grammar_input_output = @csgrammar begin end
	for e in ex
        for input in e.in
            name = Symbol(input[1])
            @eval mod ($(name)) = x -> write_input_to_stack(Symbol($input[1]), $(input[2]), x)
            add_rule!(grammar_input_output, :(State = $name(State)))
        end
        for output in e.out
            name = Symbol(output[1])
            @eval mod ($(name)) = x -> get_output_from_stack(Symbol($output[1]), $(typeof(output[2])), x)
            add_rule!(grammar_input_output, :(State = $name(State)))
        end
    end
	return grammar_input_output
end

function make_input_output_grammar(e::IOExample, mod::Module)
    """Creates the grammar for the input and output values, using functions to write the input type to the stack and retrieve it for the output."""
	grammar_input_output = @csgrammar begin end
    for input in e.in
        name = Symbol(input[1])
        @eval mod ($(name)) = x -> write_input_to_stack(Symbol($input[1]), $(input[2]), x)
        add_rule!(grammar_input_output, :(State = $name(State)))
    end
    for output in e.out
        name = Symbol(output[1])
        @eval mod ($(name)) = x -> get_output_from_stack(Symbol($output[1]), $(typeof(output[2])), x)
        add_rule!(grammar_input_output, :(State = $name(State)))
    end
	return grammar_input_output
end


function merge_grammar(gs::Vector{ContextSensitiveGrammar})
    """Merge the grammars in the vector."""
    new_grammar = @csgrammar begin end
    for g in gs
        for i in eachindex(g.rules)
            ex = :($(g.types[i]) = $(g.rules[i]))
            add_rule!(new_grammar, ex)
        end
    end
    return new_grammar
end




g_random = @csgrammar begin
    State = make_stacks()
    State = boolean_rand(State)
    State = float_rand(State)
    State = integer_rand(State)
    State = string_rand(State)
    State = code_rand(State)
    State = code_rand_atom(State)
    State = char_rand(State)
end

g_char = @csgrammar begin
    State = make_stacks()
    State = char_allfromstring(State)
    State = char_fromfloat(State)
    State = char_isletter(State)
    State = char_isdigit(State)
    State = char_iswhitespace(State)
    State = char_lowercase(State)
    State = char_uppercase(State)
end

g_bool = @csgrammar begin
    State = make_stacks()
    State = boolean_and(State)
    State = boolean_or(State)
    State = boolean_xor(State)
    State = boolean_not(State)
    State = boolean_invert_first_then_and(State)
    State = boolean_invert_second_then_and(State)
    State = boolean_fromfloat(State)
    State = boolean_fromfloat(State)
end

g_integer = @csgrammar begin
    State = make_stacks()
    State = integer_add(State)
    State = integer_sub(State)
    State = integer_mult(State)
    State = integer_div(State)
    State = integer_mod(State)
    State = integer_lt(State)
    State = integer_gt(State)
    State = integer_lte(State)
    State = integer_gte(State)
    State = integer_fromboolean(State)
    State = integer_fromfloat(State)
    State = integer_fromstring(State)
    State = integer_fromchar(State)
    State = integer_min(State)
    State = integer_max(State)
    State = integer_inc(State)
    State = integer_dec(State)
    State = integer_abs(State)
    State = integer_negate(State)
    State = integer_pow(State)
end

g_float = @csgrammar begin
    State = make_stacks()
    State = float_add(State)
    State = float_sub(State)
    State = float_mult(State)
    State = float_div(State)
    State = float_mod(State)
    State = float_lt(State)
    State = float_gt(State)
    State = float_lte(State)
    State = float_gte(State)
    State = float_fromboolean(State)
    State = float_fromfloat(State)
    State = float_fromstring(State)
    State = float_fromchar(State)
    State = float_min(State)
    State = float_max(State)
    State = float_inc(State)
    State = float_dec(State)
    State = float_abs(State)
    State = float_negate(State)
    State = float_pow(State)
    State = float_arctan(State)
    State = float_arccos(State)
    State = float_arcsin(State)
    State = float_floor(State)
    State = float_ceiling(State)
    State = float_log10(State)
    State = float_log2(State)
    State = float_square(State)
    State = float_sqrt(State)
    State = float_tan(State)
    State = float_cos(State)
    State = float_sin(State)
end

g_string = @csgrammar begin
    State = make_stacks()
    State = string_frominteger(State)
    State = string_fromfloat(State)
    State = string_fromchar(State)
    State = string_fromboolean(State)
    State = string_concat(State)
    State = string_conjchar(State)
    State = string_take(State)
    State = string_substring(State)
    State = string_first(State)
    State = string_last(State)
    State = string_nth(State)
    State = string_rest(State)
    State = string_butlast(State)
    State = string_length(State)
    State = string_reverse(State)
    State = string_parse_to_chars(State)
    State = string_split(State)
    State = string_emptystring(State)
    State = string_containschar(State)
    State = string_indexofchar(State)
    State = string_occurrencesofchar(State)
    State = string_replace(State)
    State = string_replacefirst(State)
    State = string_replacechar(State)
    State = string_replacefirstchar(State)
    State = string_removechar(State)
    State = string_setchar(State)
    State = string_capitalize(State)
    State = string_uppercase(State)
    State = string_lowercase(State)
    State = exec_string_iterate(State)
    State = string_sort(State)
    State = string_includes(State)
    State = string_indexof(State)
end