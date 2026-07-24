"""
Problem specific parts of the PSB2 grammars: the inputs, the constants of the
instruction set of the PSB2 paper, and the `Return` rule.

* Inputs are named `_arg_1, _arg_2, ...` and are typed by the non-terminal they
  are defined on, matching the `IOExample`s in `data.jl`.
* The `Return` rule fixes the output type of a problem. Problems with several
  outputs return a `Dict` with the keys `:output1, :output2, ...`, again
  matching `data.jl`.
* Ephemeral random constants (ERCs) are *not* part of these grammars; they are
  added by the `get_grammar_*` functions in `grammar.jl`, which draw them from
  the range given in the paper.

`minimal_grammar_<problem>` is a hand-written grammar that contains just the
instructions needed for the example solution in `program_examples.jl`. It is
useful as a small, well-understood search space for testing a search
algorithm; the full `grammar_<problem>` is the actual benchmark.
"""

## Basement: index of the first prefix of the input that sums to a negative number
input_basement = @csgrammar begin
    List = _arg_1
    IntRule = -1 | 0 | 1
    Return = IntRule
end

minimal_grammar_basement = @csgrammar begin
    Return = IntRule
    List = _arg_1
    IntRule = 0 | 1
    IntRule = IntRule + IntRule
    IntRule = list_sum(List)
    List = sublist(List, IntRule, IntRule)
    Boolean = IntRule >= IntRule
    IntRule = while_loop(IntRule, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); IntRule end)
    IntRule = int_var(:s)
end

## Bouncing balls: distance travelled by a bouncing ball
input_bouncing_balls = @csgrammar begin
    Float = _arg_1 | _arg_2
    IntRule = _arg_3
    Float = 0.0 | 1.0 | 2.0
    IntRule = 0 | 1 | 2
    Return = Float
end

## Bowling: score of a game of bowling
input_bowling = @csgrammar begin
    String = _arg_1
    IntRule = 0 | 1 | 2 | 10
    Character = 'X' | '/' | '-'
    String = "X" | "/" | "-"
    Return = IntRule
end

## Camel case: turn a kebab-case string into camelCase
input_camel_case = @csgrammar begin
    String = _arg_1
    Character = '-' | ' '
    String = "" | "-" | " "
    IntRule = 0 | 1
    Return = String
end

## Coin sums: the number of quarters, dimes, nickels and pennies of a change
input_coin_sums = @csgrammar begin
    IntRule = _arg_1
    IntRule = 0 | 1 | 5 | 10 | 25
    Return = Dict(:output1 => IntRule, :output2 => IntRule, :output3 => IntRule, :output4 => IntRule)
end

minimal_grammar_coin_sums = @csgrammar begin
    IntRule = _arg_1
    IntRule = 5 | 10 | 25
    IntRule = safe_div(IntRule, IntRule)
    IntRule = safe_mod(IntRule, IntRule)
    Return = Dict(:output1 => IntRule, :output2 => IntRule, :output3 => IntRule, :output4 => IntRule)
end

## Cut vector: split a vector into the two halves with the closest sums
input_cut_vector = @csgrammar begin
    List = _arg_1
    IntRule = 0 | 1
    Return = Dict(:output1 => List, :output2 => List)
end

## Dice game: probability that a die with `_arg_1` sides beats one with `_arg_2`
input_dice_game = @csgrammar begin
    IntRule = _arg_1 | _arg_2
    IntRule = 0 | 1 | 2
    Float = 0.0 | 1.0 | 2.0
    Return = Float
end

## Find pair: two numbers of the input that sum to the target
input_find_pair = @csgrammar begin
    List = _arg_1
    IntRule = _arg_2
    IntRule = -1 | 0 | 1 | 2
    Return = Dict(:output1 => IntRule, :output2 => IntRule)
end

## FizzBuzz
input_fizz_buzz = @csgrammar begin
    IntRule = _arg_1
    IntRule = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    Return = String
end

minimal_grammar_fizz_buzz = @csgrammar begin
    IntRule = _arg_1
    IntRule = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = string(IntRule)
    String = Boolean ? String : String
    IntRule = safe_mod(IntRule, IntRule)
    Boolean = IntRule == IntRule
    Boolean = Boolean && Boolean
    Return = String
end

## Fuel cost: total fuel needed for a list of masses
input_fuel_cost = @csgrammar begin
    List = _arg_1
    IntRule = 0 | 1 | 2 | 3
    Return = IntRule
end

minimal_grammar_fuel_cost = @csgrammar begin
    List = _arg_1
    IntRule = 2 | 3
    IntRule = IntRule - IntRule
    IntRule = safe_div(IntRule, IntRule)
    IntRule = list_sum(List)
    List = map(x -> begin bind_var!(:x, x); IntRule end, List)
    IntRule = int_var(:x)
    Return = IntRule
end

## Greatest common divisor
input_gcd = @csgrammar begin
    IntRule = _arg_1 | _arg_2
    IntRule = 0 | 1
    Return = IntRule
end

minimal_grammar_gcd = @csgrammar begin
    IntRule = _arg_1 | _arg_2
    IntRule = 0
    IntRule = safe_mod(IntRule, IntRule)
    Boolean = IntRule > IntRule
    List = []
    List = list_push(List, IntRule)
    IntRule = list_first(List)
    IntRule = list_last(List)
    List = while_loop(List, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); List end)
    List = list_var(:s)
    Return = IntRule
end

## Indices of substring: all indices at which the target occurs in the text
input_indices_of_substring = @csgrammar begin
    String = _arg_1 | _arg_2
    IntRule = 0 | 1
    String = ""
    Return = List
end

## Leaders: all elements that are greater than or equal to everything after them
input_leaders = @csgrammar begin
    List = _arg_1
    IntRule = 0 | 1
    Return = List
end

## Luhn: the Luhn checksum of 16 digits
input_luhn = @csgrammar begin
    List = _arg_1
    IntRule = 0 | 1 | 2 | 9 | 10
    Return = IntRule
end

## Mastermind: number of white and black pegs of a Mastermind guess
input_mastermind = @csgrammar begin
    String = _arg_1 | _arg_2
    IntRule = 0 | 1
    Character = 'B' | 'R' | 'W' | 'Y' | 'O' | 'G'
    String = ""
    Return = Dict(:output1 => IntRule, :output2 => IntRule)
end

## Middle character: the middle one or two characters of a string
input_middle_character = @csgrammar begin
    String = _arg_1
    IntRule = 0 | 1 | 2
    String = ""
    Return = String
end

## Paired digits: sum of the digits that are equal to the digit after them
input_paired_digits = @csgrammar begin
    String = _arg_1
    IntRule = 0 | 1
    Return = IntRule
end

## Shopping list: total price of a list of prices with a list of discounts
input_shopping_list = @csgrammar begin
    List = _arg_1 | _arg_2
    Float = 0.0 | 1.0 | 100.0
    IntRule = 0 | 1 | 100
    Return = Float
end

## Snow day: amount of snow after a number of hours of snowfall and melting
input_snow_day = @csgrammar begin
    IntRule = _arg_1
    Float = _arg_2 | _arg_3 | _arg_4
    IntRule = 0 | 1
    Float = 0.0 | 1.0
    Return = Float
end

## Solve boolean: evaluate a boolean expression written with t, f, & and |
input_solve_boolean = @csgrammar begin
    String = _arg_1
    Character = 't' | 'f' | '&' | '|'
    String = "t" | "f" | "&" | "|" | ""
    IntRule = 0 | 1
    Return = Boolean
end

## Spin words: reverse every word of five letters or more
input_spin_words = @csgrammar begin
    String = _arg_1
    Character = ' '
    String = " " | ""
    IntRule = 0 | 1 | 4 | 5
    Return = String
end

## Square digits: the digits of a number, squared and concatenated
input_square_digits = @csgrammar begin
    IntRule = _arg_1
    IntRule = 0 | 1 | 2 | 10
    String = ""
    Return = String
end

## Substitution cipher: encode a text with a substitution alphabet
input_substitution_cipher = @csgrammar begin
    String = _arg_1 | _arg_2 | _arg_3
    IntRule = 0 | 1
    String = ""
    Return = String
end

## Twitter: report the length of a tweet
input_twitter = @csgrammar begin
    String = _arg_1
    IntRule = 0 | 140
    String = "Your tweet has " | " characters" | "Too many characters" | "You didn't type anything" | ""
    Return = String
end

## Vector distance: euclidean distance between two vectors
input_vector_distance = @csgrammar begin
    List = _arg_1 | _arg_2
    Float = 0.0 | 2.0
    IntRule = 0 | 2
    Return = Float
end
