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

grammar_basement = get_grammar_basement(seed=42)
grammar_coin_sums = get_grammar_coinsums()
grammar_fizz_buzz = get_grammar_fizz_buzz()
grammar_fuel_cost = get_grammar_fuelcost(seed=42)
grammar_gcd = get_grammar_gcd()