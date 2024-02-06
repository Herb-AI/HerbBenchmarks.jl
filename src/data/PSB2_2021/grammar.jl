include("data.jl")

function get_grammar(names::Vector{String}, p::Problem, mod::Module)
    """
    Function to create grammar for this problem. `names` specifies the subgrammars to use.
    TODO initialize grammars based on benchmark.
    """
    Base.include(mod, "grammars/custom_util.jl")
    g = make_input_output_grammar(p.examples, mod)
    for n in names
        if n == "integer"
            Base.include(mod, "grammars/grammar_numbers.jl")
            g = merge_grammar([g, g_integer])
        elseif n == "float"
            Base.include(mod, "grammars/grammar_numbers.jl")
            g = merge_grammar([g, g_float])
        elseif n == "string"
            Base.include(mod, "grammars/grammar_string.jl")
            g = merge_grammar([g, g_string])
        elseif n == "char"
            Base.include(mod, "grammars/grammar_char.jl")
            g = merge_grammar([g, g_char])
        elseif n ==  "bool" || n == "boolean"
            Base.include(mod, "grammars/grammar_bool.jl")
            g = merge_grammar([g, g_bool])
        elseif n == "random" 
            Base.include(mod, "grammars/grammar_random.jl")
            g = merge_grammar([g, g_random])
        else
            @warn n * " grammar is not implemented (yet)."
        end
    end
    return g
end

function get_grammar(problem_name::String, p::Problem, mod::Module)
    """
    Function to create grammar for this problem. `names` specifies the subgrammars to use.
    TODO initialize grammars based on benchmark.
    """
    Base.include(mod, "grammars/custom_util.jl")
    names = benchmark_to_grammar[replace(problem_name, "problem_" => "")]
    g = make_input_output_grammar(p.spec, mod)
    for n in names
        if n == "integer"
            Base.include(mod, "grammars/grammar_numbers.jl")
            g = merge_grammar([g, g_integer])
        elseif n == "float"
            Base.include(mod, "grammars/grammar_numbers.jl")
            g = merge_grammar([g, g_float])
        elseif n == "string"
            Base.include(mod, "grammars/grammar_string.jl")
            g = merge_grammar([g, g_string])
        elseif n == "char"
            Base.include(mod, "grammars/grammar_char.jl")
            g = merge_grammar([g, g_char])
        elseif n ==  "bool" || n == "boolean"
            Base.include(mod, "grammars/grammar_bool.jl")
            g = merge_grammar([g, g_bool])
        elseif n == "random" 
            Base.include(mod, "grammars/grammar_random.jl")
            g = merge_grammar([g, g_random])
        else
            @warn n * " grammar is not implemented (yet)."
        end
    end
    return g
end

benchmark_to_grammar = Dict{String, Vector{String}}(
    "basement" => ["integer", "boolean", "vector_of_integer"],
    "bouncing_balls" => ["integer", "float", "boolean"],
    "bowling" => ["integer", "float", "boolean", "string", "char"],
    "camel_case" => ["integer", "boolean", "char", "string"],
    "coin_sums" => ["integer", "boolean"],
    "cut_vector" => ["integer", "boolean"],
    "dice_game" => ["integer", "boolean", "float"],
    "find_pair" => ["integer", "boolean", "vector_of_integer"],
    "fizz_buzz" => ["integer", "boolean", "string"],
    "fuel_cost" => ["integer", "boolean", "vector_of_integer"],
    "gcd" => ["integer", "boolean"],
    "indices_of_substring" => ["integer", "booelan", "string", "char", "vector_of_integer"],
    "leaders" => ["integer", "boolean", "vector_of_integer"],
    "luhn" => ["integer", "boolean", "vector_of_integer"],
    "mastermind" => ["integer", "boolean", "string", "char"],
    "middle_character" => ["integer", "boolean", "string", "char"],
    "paired_digits" => ["integer", "boolean", "string", "char"],
    "shopping_list" => ["integer", "float", "boolean", "vector_of_float"],
    "snow_day" => ["integer", "float", "boolean"],
    "solve_boolean" => ["integer", "char", "string", "boolean"],
    "spin_words" => ["integer", "boolean", "string", "char"],
    "square_digits" => ["integer", "boolean", "string", "char"],
    "substitution_cipher" => ["integer", "boolean", "string", "char"],
    "twitter" => ["integer", "boolean", "string", "char"],
    "vector_distance" => ["integer", "float", "boolean", "vector_of_float"]
)

all_problems = Dict(
    "basement" => problem_basement,
    "bouncing_balls" => problem_bouncing_balls,
    "bowling" => problem_bowling,
    "camel_case" => problem_camel_case,
    "coin_sums" => problem_coin_sums,
    "cut_vector" => problem_cut_vector,
    "dice_game" => problem_dice_game,
    "find_pair" => problem_find_pair,
    "fizz_buzz" => problem_fizz_buzz,
    "fuel_cost" => problem_fuel_cost,
    "gcd" => problem_gcd,
    "indices_of_substring" => problem_indices_of_substring,
    "leaders" => problem_leaders,
    "luhn" => problem_luhn,
    "mastermind" => problem_mastermind,
    "middle_character" => problem_middle_character,
    "paired_digits" => problem_paired_digits,
    "shopping_list" => problem_shopping_list,
    "snow_day" => problem_snow_day,
    "solve_boolean" => problem_solve_boolean,
    "spin_words" => problem_spin_words,
    "square_digits" => problem_square_digits,
    "substitution_cipher" => problem_substitution_cipher,
    "twitter" => problem_twitter,
    "vector_distance" => problem_vector_distance
)

function write_grammars_to_file()
    mod = Module(:Grammar)
    f = open("data_grammars.jl", "w")
    for (name, p) in all_problems
        g = get_grammar(name, p, mod)
        println(f, "grammar_" * name * " = @csgrammar begin")
        for rule in g.rules
            println(f, "    State = " * string(rule))
        end
        println(f, "end")
    end
end

function make_input_output_grammar(ex::AbstractSpecification, mod::Module)
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
