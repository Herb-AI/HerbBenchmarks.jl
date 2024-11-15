using Random
using HerbGrammar

include("problem_grammars.jl")
include("base_grammars.jl")

function get_grammar_basement(;minimal=true, seed=nothing)
    # Basement has a random integer and all integers are in range (-100, 100)
    if !isnothing(seed)
        Random.seed!(seed)
    end

    grammar_basement = merge_grammar([
        input_basement, 
        grammar_integer, 
        grammar_list_integer, 
        grammar_state_integer, 
        grammar_boolean
    ])

    g = minimal ? minimal_grammar_basement : grammar_basement
    g = deepcopy(g)

    int_erc = rand((-100, 100))
    HerbGrammar.add_rule!(g, :(IntRule = $int_erc))

    return g
end

function get_grammar_bouncing_balls(;minimal=true)
    @warn  "Not yet implemented grammar bouncing balls"
    return ContextSensitiveGrammar()
end

function get_grammar_bowling(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar bowling"
    return ContextSensitiveGrammar()
end

function get_grammar_camel_case(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar camel case"
    return ContextSensitiveGrammar()
end

function get_grammar_coinsums(;minimal=true)
    # Coin sums does not have a random integer
    grammar_coin_sums = merge_grammar([
        input_coin_sums,
        grammar_integer,
        grammar_boolean
    ])
    g = minimal ? minimal_grammar_coin_sums : grammar_coin_sums
    return g
end

function get_grammar_cut_vector(;minimal=true)
    @warn  "Not yet implemented grammar cut vector"
    return ContextSensitiveGrammar()
end

function get_grammar_dice_game(;minimal=true)
    @warn  "Not yet implemented grammar dice game"
    return ContextSensitiveGrammar()
end

function get_grammar_find_pair(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar find pair"
    return ContextSensitiveGrammar()
end

function get_grammar_fizz_buzz(;minimal=true)
    # Fizz buzz does not have a random character
    grammar_fizz_buzz = merge_grammar([
        input_fizz_buzz, 
        grammar_integer,
        grammar_string, 
        grammar_boolean
    ])
    g = minimal ? minimal_grammar_fizz_buzz : grammar_fizz_buzz
    return g
end

function get_grammar_fuelcost(;minimal=true, seed=nothing)
    # Fuel cost has a random integer and all integers are in range (6, 1000000)
    if !isnothing(seed)
        Random.seed!(seed)
    end

    grammar_fuel_cost = merge_grammar([
        input_fuel_cost, 
        grammar_integer,
        grammar_boolean,
        grammar_list_integer
    ])
    
    g = minimal ? minimal_grammar_fuel_cost : grammar_fuel_cost
    g = deepcopy(g)

    int_erc = rand((6, 1000000))
    HerbGrammar.add_rule!(g, :(IntRule = $int_erc))

    return g
end

function get_grammar_gcd(;minimal=true, seed=nothing)
    # GCD has a random integer and all integers are in range (1, 1000000)
    if !isnothing(seed)
        Random.seed!(seed)
    end

    grammar_gcd = merge_grammar([
        input_gcd,
        grammar_integer,
        grammar_boolean,
        grammar_state_integer
    ])
    
    g = minimal ? minimal_grammar_gcd : grammar_gcd
    g = deepcopy(g)

    int_erc = rand((1, 1000000))
    HerbGrammar.add_rule!(g, :(IntRule = $int_erc))

    return g
end

function get_grammar_indices_of_substring(;minimal=true)
    @warn  "Not yet implemented grammar indices of substring"
    return ContextSensitiveGrammar()
end

function get_grammar_leaders(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar leaders"
    return ContextSensitiveGrammar()
end

function get_grammar_luhn(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar luhn"
    return ContextSensitiveGrammar()
end

function get_grammar_mastermind(;minimal=true)
    @warn  "Not yet implemented grammar mastermind"
    return ContextSensitiveGrammar()
end

function get_grammar_middle_character(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar middle character"
    return ContextSensitiveGrammar()
end

function get_grammar_paired_digits(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar paired digits"
    return ContextSensitiveGrammar()
end

function get_grammar_shopping_list(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar shopping list"
    return ContextSensitiveGrammar()
end

function get_grammar_snow_day(;minimal=true)
    @warn  "Not yet implemented grammar snow day"
    return ContextSensitiveGrammar()
end

function get_grammar_solve_boolean(;minimal=true)
    @warn  "Not yet implemented grammar solve boolean"
    return ContextSensitiveGrammar()
end

function get_grammar_spin_words(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar spin words"
    return ContextSensitiveGrammar()
end

function get_grammar_square_digits(;minimal=true, seed=nothing)
    @warn  "Not yet implemented grammar square digits"
    return ContextSensitiveGrammar()
end

function get_grammar_substitution_cipher(;minimal=true)
    @warn  "Not yet implemented grammar substitution cipher"
    return ContextSensitiveGrammar()
end

function get_grammar_twitter(;minimal=true)
    @warn  "Not yet implemented grammar twitter"
    return ContextSensitiveGrammar()
end

function get_grammar_vector_distance(;minimal=true)
    @warn  "Not yet implemented grammar vector distance"
    return ContextSensitiveGrammar()
end

grammar_basement = get_grammar_basement(seed=42)
grammar_bouncing_balls = get_grammar_bouncing_balls()
grammar_bowling = get_grammar_bowling(seed=42)
grammar_camel_case = get_grammar_camel_case(seed=42)
grammar_coin_sums = get_grammar_coinsums()
grammar_cut_vector = get_grammar_cut_vector()
grammar_dice_game = get_grammar_dice_game()
grammar_find_pair = get_grammar_find_pair(seed=42)
grammar_fizz_buzz = get_grammar_fizz_buzz()
grammar_fuel_cost = get_grammar_fuelcost(seed=42)
grammar_gcd = get_grammar_gcd()
grammar_indices_of_substring = get_grammar_indices_of_substring()
grammar_leaders = get_grammar_leaders(seed=42)
grammar_luhn = get_grammar_luhn(seed=42)
grammar_mastermind = get_grammar_mastermind()
grammar_middle_character = get_grammar_middle_character(seed=42)
grammar_paired_digits = get_grammar_paired_digits(seed=42)
grammar_shopping_list = get_grammar_shopping_list(seed=42)
grammar_snow_day = get_grammar_snow_day()
grammar_solve_boolean = get_grammar_solve_boolean()
grammar_spin_words = get_grammar_spin_words(seed=42)
grammar_square_digits = get_grammar_square_digits(seed=42)
grammar_substitution_cipher = get_grammar_substitution_cipher()
grammar_twitter = get_grammar_twitter()
grammar_vector_distance = get_grammar_vector_distance()