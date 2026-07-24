"""
Example solutions for the implemented PSB2 problems.

Every problem has

* `program_<problem>(args...)`, a plain Julia function, the readable reference
  solution, and
* `solution_<problem>`, the same program as a `RuleNode` of
  `grammar_<problem>`, and `minimal_solution_<problem>` for
  `get_grammar_<problem>(minimal=true)`.

The `RuleNode`s are built with [`expr_to_rulenode`](@ref), which fails when the
expression cannot be derived from the grammar. Together with the tests, which
run them through `make_interpreter` on *all* examples of the problem, this is
what pins down that a problem is solvable within its grammar.
"""

# ---------------------------------------------------------------------------
# Basement
# ---------------------------------------------------------------------------

"""
    program_basement(_arg_1)

Index of the first element of `_arg_1` up to which the elements sum to a
negative number. Indices are 0-based, as in the PSB2 data.
"""
function program_basement(_arg_1)
    return while_loop(0,
        s -> begin bind_var!(:s, s); list_sum(sublist(_arg_1, 1, int_var(:s) + 1)) >= 0 end,
        s -> begin bind_var!(:s, s); int_var(:s) + 1 end)
end

const expression_basement = :(
    while_loop(0,
        s -> begin bind_var!(:s, s); list_sum(sublist(_arg_1, 1, int_var(:s) + 1)) >= 0 end,
        s -> begin bind_var!(:s, s); int_var(:s) + 1 end)
)

# ---------------------------------------------------------------------------
# Coin sums
# ---------------------------------------------------------------------------

"""
    program_coin_sums(_arg_1)

Number of pennies, nickels, dimes and quarters that make up `_arg_1` cents,
using as few coins as possible.
"""
function program_coin_sums(_arg_1)
    return Dict(
        :output1 => safe_mod(safe_mod(safe_mod(_arg_1, 25), 10), 5),
        :output2 => safe_div(safe_mod(safe_mod(_arg_1, 25), 10), 5),
        :output3 => safe_div(safe_mod(_arg_1, 25), 10),
        :output4 => safe_div(_arg_1, 25))
end

const expression_coin_sums = :(
    Dict(:output1 => safe_mod(safe_mod(safe_mod(_arg_1, 25), 10), 5),
         :output2 => safe_div(safe_mod(safe_mod(_arg_1, 25), 10), 5),
         :output3 => safe_div(safe_mod(_arg_1, 25), 10),
         :output4 => safe_div(_arg_1, 25))
)

# ---------------------------------------------------------------------------
# FizzBuzz
# ---------------------------------------------------------------------------

"""
    program_fizz_buzz(_arg_1)

"Fizz" for multiples of 3, "Buzz" for multiples of 5, "FizzBuzz" for multiples
of both and the number itself otherwise.
"""
function program_fizz_buzz(_arg_1)
    return if safe_mod(_arg_1, 3) == 0 && safe_mod(_arg_1, 5) == 0
        "FizzBuzz"
    elseif safe_mod(_arg_1, 3) == 0
        "Fizz"
    elseif safe_mod(_arg_1, 5) == 0
        "Buzz"
    else
        string(_arg_1)
    end
end

const expression_fizz_buzz = :(
    (safe_mod(_arg_1, 3) == 0 && safe_mod(_arg_1, 5) == 0) ? "FizzBuzz" :
    (safe_mod(_arg_1, 3) == 0 ? "Fizz" :
     (safe_mod(_arg_1, 5) == 0 ? "Buzz" : string(_arg_1)))
)

# ---------------------------------------------------------------------------
# Fuel cost
# ---------------------------------------------------------------------------

"""
    program_fuel_cost(_arg_1)

Total fuel for a list of masses: every mass costs `mass ÷ 3 - 2` fuel.
"""
function program_fuel_cost(_arg_1)
    return list_sum(map(x -> begin bind_var!(:x, x); safe_div(int_var(:x), 3) - 2 end, _arg_1))
end

const expression_fuel_cost = :(
    list_sum(map(x -> begin bind_var!(:x, x); safe_div(int_var(:x), 3) - 2 end, _arg_1))
)

# ---------------------------------------------------------------------------
# Greatest common divisor
# ---------------------------------------------------------------------------

"""
    program_gcd(_arg_1, _arg_2)

Euclid's algorithm. The two numbers of the loop are carried through the loop as
a two element list, since a loop of the grammar has a single accumulator.
"""
function program_gcd(_arg_1, _arg_2)
    return list_first(while_loop(list_push(list_push([], _arg_1), _arg_2),
        s -> begin bind_var!(:s, s); list_last(list_var(:s)) > 0 end,
        s -> begin
            bind_var!(:s, s)
            list_push(list_push([], list_last(list_var(:s))),
                safe_mod(list_first(list_var(:s)), list_last(list_var(:s))))
        end))
end

const expression_gcd = :(
    list_first(while_loop(list_push(list_push([], _arg_1), _arg_2),
        s -> begin bind_var!(:s, s); list_last(list_var(:s)) > 0 end,
        s -> begin
            bind_var!(:s, s)
            list_push(list_push([], list_last(list_var(:s))),
                safe_mod(list_first(list_var(:s)), list_last(list_var(:s))))
        end))
)

# ---------------------------------------------------------------------------
# The same programs as rule nodes
# ---------------------------------------------------------------------------

solution_basement = expr_to_rulenode(grammar_basement, :Return, expression_basement)
solution_coin_sums = expr_to_rulenode(grammar_coin_sums, :Return, expression_coin_sums)
solution_fizz_buzz = expr_to_rulenode(grammar_fizz_buzz, :Return, expression_fizz_buzz)
solution_fuel_cost = expr_to_rulenode(grammar_fuel_cost, :Return, expression_fuel_cost)
solution_gcd = expr_to_rulenode(grammar_gcd, :Return, expression_gcd)

minimal_solution_basement = expr_to_rulenode(minimal_grammar_basement, :Return, expression_basement)
minimal_solution_coin_sums = expr_to_rulenode(minimal_grammar_coin_sums, :Return, expression_coin_sums)
minimal_solution_fizz_buzz = expr_to_rulenode(minimal_grammar_fizz_buzz, :Return, expression_fizz_buzz)
minimal_solution_fuel_cost = expr_to_rulenode(minimal_grammar_fuel_cost, :Return, expression_fuel_cost)
minimal_solution_gcd = expr_to_rulenode(minimal_grammar_gcd, :Return, expression_gcd)

"""
    PSB2_SOLUTIONS

The problems that have an example solution, mapped to that solution. Used by
the tests, and a good starting point when adding a problem.
"""
const PSB2_SOLUTIONS = Dict{String,Any}(
    "basement" => solution_basement,
    "coin_sums" => solution_coin_sums,
    "fizz_buzz" => solution_fizz_buzz,
    "fuel_cost" => solution_fuel_cost,
    "gcd" => solution_gcd,
)

"""
    PSB2_MINIMAL_SOLUTIONS

Like [`PSB2_SOLUTIONS`](@ref), for the minimal grammars.
"""
const PSB2_MINIMAL_SOLUTIONS = Dict{String,Any}(
    "basement" => minimal_solution_basement,
    "coin_sums" => minimal_solution_coin_sums,
    "fizz_buzz" => minimal_solution_fizz_buzz,
    "fuel_cost" => minimal_solution_fuel_cost,
    "gcd" => minimal_solution_gcd,
)
