include("base_grammars.jl")

## Basement problem
input_basement = @csgrammar begin
    Int = -1 | 0 | 1
    List = []
    Integer = rand(-100:100)
    Return = Dict(:output1 => Int)
end

## Coin Sums problem
input_coin_sums = @csgrammar begin
    Int = 0 | 1 | 5 | 10 | 25
    Int = input1
    Return = Dict(:output1 => Int, :output2 => Int, :output3 => Int, :output4 => Int)
end

## FizzBuzz problem
input_fizz_buzz = @csgrammar begin
    Int = input1
    Int = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    Return = Dict(:output1 => String)
end

grammar_fizz_buzz = merge_grammar([input_fizz_buzz, grammar_integer, grammar_string, grammar_boolean])

minimal_grammar_fizz_buzz = @csgrammar begin
    Int = input1
    Int = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = string(Int)
    Return = Dict(:output1 => String)
    Int = Int % Int
    Bool = Int == Int
    Int = Bool ? Int : Int
    Bool = Bool && Bool
end

## Fuel cost problem
input_fuel_cost = @csgrammar begin
    Int = 0 | 1 | 2 | 3
    List = input1
    # Int = rand(6:100000)
    Return = Dict(:output1 => Int)
end

grammar_fuel_cost = merge_grammar([input_fuel_cost, grammar_boolean, grammar_integer])

minimal_grammar_fuel_cost = @csgrammar begin
    List = input1
    Int = 0 | 1 | 2 | 3
    Float = Int / Int
    Int = floor(Float)
    Int = Int - Int
    Int = sum(List)
    List = map(Func, List)
    Func = x -> Int
    Int = x
    output1 = Int
end

## GCD problem
input_gcd = @csgrammar begin
    Int = input1 | input2
    Int = 0
    Return = Dict(:output1 => Int)
end

grammar_gcd = merge_grammar([input_gcd, grammar_integer, grammar_boolean, grammar_state])

minimal_grammar_gcd = @csgrammar begin
    Int = input1 | input2
    State = Dict(:x => Int, :y => Int)
    Int = state[:x] | state[:y]
    Int = Int % Int
    Int = let state = State; Int end
    # Bool = Int == 0
    Bool = Int > Int
    # Bool = Bool && Bool
    Int = while Bool; Int end; Int
    # Int = Bool ? Int : Int
    output1 = Int
    Int = 0
    # Int = rand(1:1000000) # this should add one random number to the grammar
end
