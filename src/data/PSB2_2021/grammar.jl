using Random

"""
The grammars of the PSB2 benchmark.

For every problem there is

* a `get_grammar_<problem>(; minimal=false, seed=nothing)` function, and
* a `grammar_<problem>` object, the grammar the benchmark hands out through
  `get_grammar(PSB2_2021, "<problem>")`.

The full grammar of a problem is the merge of its `input_<problem>` grammar
(inputs, constants, output type, see `problem_grammars.jl`) with the base
grammars of the types the problem uses (see `base_grammars.jl`). Rules that
mention a type the merged grammar has no productions for are pruned, so every
grammar is complete: every non-terminal can be expanded.

`minimal=true` returns the small hand-written grammar that contains just the
instructions used by the example solution of the problem, which is only
available for the problems that have an example solution.

Some problems use an ephemeral random constant. As in the PSB2 paper, one
random constant, drawn from the range of the inputs of that problem, is added
to the grammar. Pass `seed` to make that draw reproducible; `grammar_<problem>`
uses seed 42.
"""

"""
    add_erc!(grammar::AbstractGrammar, type::Symbol, range; seed=nothing)

Add one ephemeral random constant of type `type`, drawn from `range`, to
`grammar`. Uses a local random number generator, so it does not disturb the
global one.
"""
function add_erc!(grammar::AbstractGrammar, type::Symbol, range; seed=nothing)
    rng = seed === nothing ? Random.default_rng() : Random.MersenneTwister(seed)
    constant = rand(rng, range)
    add_rule!(grammar, :($type = $constant))
    return grammar
end

# The characters PSB2 draws a character ERC from.
const ERC_CHARACTERS = [collect('a':'z'); collect('A':'Z'); collect('0':'9'); collect(" !\"#\$%&'()*+,-./:;<=>?@")]

function get_grammar_basement(; minimal=false, seed=nothing)
    g = minimal ? deepcopy(minimal_grammar_basement) : merge_grammar([
            input_basement, grammar_integer, grammar_boolean,
            grammar_list_integer, grammar_loop_integer,
        ]; start=:Return)
    return add_erc!(g, :IntRule, -100:100; seed=seed)
end

function get_grammar_bouncing_balls(; minimal=false, seed=nothing)
    return merge_grammar([
        input_bouncing_balls, grammar_integer, grammar_float, grammar_boolean,
        grammar_loop_float,
    ]; start=:Return)
end

function get_grammar_bowling(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_bowling, grammar_integer, grammar_boolean, grammar_character,
        grammar_string, grammar_loop_integer,
    ]; start=:Return)
    return add_erc!(g, :Character, ERC_CHARACTERS; seed=seed)
end

function get_grammar_camel_case(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_camel_case, grammar_integer, grammar_boolean, grammar_character,
        grammar_string, grammar_loop_string,
    ]; start=:Return)
    return add_erc!(g, :Character, ERC_CHARACTERS; seed=seed)
end

function get_grammar_coin_sums(; minimal=false, seed=nothing)
    return minimal ? deepcopy(minimal_grammar_coin_sums) : merge_grammar([
        input_coin_sums, grammar_integer, grammar_boolean,
    ]; start=:Return)
end

function get_grammar_cut_vector(; minimal=false, seed=nothing)
    return merge_grammar([
        input_cut_vector, grammar_integer, grammar_boolean,
        grammar_list_integer, grammar_loop_list,
    ]; start=:Return)
end

function get_grammar_dice_game(; minimal=false, seed=nothing)
    return merge_grammar([
        input_dice_game, grammar_integer, grammar_float, grammar_boolean,
    ]; start=:Return)
end

function get_grammar_find_pair(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_find_pair, grammar_integer, grammar_boolean,
        grammar_list_integer, grammar_loop_integer,
    ]; start=:Return)
    return add_erc!(g, :IntRule, -10000:10000; seed=seed)
end

function get_grammar_fizz_buzz(; minimal=false, seed=nothing)
    return minimal ? deepcopy(minimal_grammar_fizz_buzz) : merge_grammar([
        input_fizz_buzz, grammar_integer, grammar_boolean, grammar_string,
    ]; start=:Return)
end

function get_grammar_fuel_cost(; minimal=false, seed=nothing)
    g = minimal ? deepcopy(minimal_grammar_fuel_cost) : merge_grammar([
            input_fuel_cost, grammar_integer, grammar_boolean, grammar_list_integer,
        ]; start=:Return)
    return add_erc!(g, :IntRule, 6:100000; seed=seed)
end

function get_grammar_gcd(; minimal=false, seed=nothing)
    g = minimal ? deepcopy(minimal_grammar_gcd) : merge_grammar([
            input_gcd, grammar_integer, grammar_boolean, grammar_list_integer,
            grammar_loop_list,
        ]; start=:Return)
    return add_erc!(g, :IntRule, 1:1000000; seed=seed)
end

function get_grammar_indices_of_substring(; minimal=false, seed=nothing)
    return merge_grammar([
        input_indices_of_substring, grammar_integer, grammar_boolean,
        grammar_character, grammar_string, grammar_list_integer,
        grammar_loop_list,
    ]; start=:Return)
end

function get_grammar_leaders(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_leaders, grammar_integer, grammar_boolean, grammar_list_integer,
        grammar_loop_list,
    ]; start=:Return)
    return add_erc!(g, :IntRule, 0:1000; seed=seed)
end

function get_grammar_luhn(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_luhn, grammar_integer, grammar_boolean, grammar_list_integer,
        grammar_loop_integer,
    ]; start=:Return)
    return add_erc!(g, :IntRule, 0:9; seed=seed)
end

function get_grammar_mastermind(; minimal=false, seed=nothing)
    return merge_grammar([
        input_mastermind, grammar_integer, grammar_boolean, grammar_character,
        grammar_string, grammar_loop_integer,
    ]; start=:Return)
end

function get_grammar_middle_character(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_middle_character, grammar_integer, grammar_boolean,
        grammar_character, grammar_string,
    ]; start=:Return)
    return add_erc!(g, :Character, ERC_CHARACTERS; seed=seed)
end

function get_grammar_paired_digits(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_paired_digits, grammar_integer, grammar_boolean,
        grammar_character, grammar_string, grammar_loop_integer,
    ]; start=:Return)
    return add_erc!(g, :Character, ERC_CHARACTERS; seed=seed)
end

function get_grammar_shopping_list(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_shopping_list, grammar_integer, grammar_float, grammar_boolean,
        grammar_list_float,
    ]; start=:Return)
    return add_erc!(g, :Float, 0.0:0.01:100.0; seed=seed)
end

function get_grammar_snow_day(; minimal=false, seed=nothing)
    return merge_grammar([
        input_snow_day, grammar_integer, grammar_float, grammar_boolean,
        grammar_loop_float,
    ]; start=:Return)
end

function get_grammar_solve_boolean(; minimal=false, seed=nothing)
    return merge_grammar([
        input_solve_boolean, grammar_integer, grammar_boolean,
        grammar_character, grammar_string, grammar_loop_string,
    ]; start=:Return)
end

function get_grammar_spin_words(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_spin_words, grammar_integer, grammar_boolean, grammar_character,
        grammar_string, grammar_list_string, grammar_loop_string,
    ]; start=:Return)
    return add_erc!(g, :Character, ERC_CHARACTERS; seed=seed)
end

function get_grammar_square_digits(; minimal=false, seed=nothing)
    g = merge_grammar([
        input_square_digits, grammar_integer, grammar_boolean, grammar_string,
        grammar_loop_string,
    ]; start=:Return)
    return add_erc!(g, :IntRule, 0:10; seed=seed)
end

function get_grammar_substitution_cipher(; minimal=false, seed=nothing)
    return merge_grammar([
        input_substitution_cipher, grammar_integer, grammar_boolean,
        grammar_character, grammar_string, grammar_loop_string,
    ]; start=:Return)
end

function get_grammar_twitter(; minimal=false, seed=nothing)
    return merge_grammar([
        input_twitter, grammar_integer, grammar_boolean, grammar_string,
    ]; start=:Return)
end

function get_grammar_vector_distance(; minimal=false, seed=nothing)
    return merge_grammar([
        input_vector_distance, grammar_integer, grammar_float, grammar_boolean,
        grammar_list_float,
    ]; start=:Return)
end

grammar_basement = get_grammar_basement(seed=42)
grammar_bouncing_balls = get_grammar_bouncing_balls(seed=42)
grammar_bowling = get_grammar_bowling(seed=42)
grammar_camel_case = get_grammar_camel_case(seed=42)
grammar_coin_sums = get_grammar_coin_sums(seed=42)
grammar_cut_vector = get_grammar_cut_vector(seed=42)
grammar_dice_game = get_grammar_dice_game(seed=42)
grammar_find_pair = get_grammar_find_pair(seed=42)
grammar_fizz_buzz = get_grammar_fizz_buzz(seed=42)
grammar_fuel_cost = get_grammar_fuel_cost(seed=42)
grammar_gcd = get_grammar_gcd(seed=42)
grammar_indices_of_substring = get_grammar_indices_of_substring(seed=42)
grammar_leaders = get_grammar_leaders(seed=42)
grammar_luhn = get_grammar_luhn(seed=42)
grammar_mastermind = get_grammar_mastermind(seed=42)
grammar_middle_character = get_grammar_middle_character(seed=42)
grammar_paired_digits = get_grammar_paired_digits(seed=42)
grammar_shopping_list = get_grammar_shopping_list(seed=42)
grammar_snow_day = get_grammar_snow_day(seed=42)
grammar_solve_boolean = get_grammar_solve_boolean(seed=42)
grammar_spin_words = get_grammar_spin_words(seed=42)
grammar_square_digits = get_grammar_square_digits(seed=42)
grammar_substitution_cipher = get_grammar_substitution_cipher(seed=42)
grammar_twitter = get_grammar_twitter(seed=42)
grammar_vector_distance = get_grammar_vector_distance(seed=42)
