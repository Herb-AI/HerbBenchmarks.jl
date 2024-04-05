include("base_grammars.jl")

## Basement problem
input_basement = @csgrammar begin
    Int = -1 | 0 | 1
    List = []
    Integer = rand(-100:100)
    Return = Dict(:output1 => Int)
end

grammar_basement = merge_grammar([input_basement, grammar_integer, grammar_list_integer, grammar_state_integer, grammar_boolean])

## Coin Sums problem
input_coin_sums = @csgrammar begin
    Int = 0 | 1 | 5 | 10 | 25
    Int = input1
    Return = Dict(:output1 => Int, :output2 => Int, :output3 => Int, :output4 => Int)
end

grammar_coin_sums = merge_grammar([
    input_coin_sums,
    grammar_integer,
    grammar_boolean
])

minimal_grammar_coin_sums = @csgrammar begin
    Int = 0 | 1 | 5 | 10 | 25
    Int = input1
    Return = Dict(:output1 => Int, :output2 => Int, :output3 => Int, :output4 => Int)
    Int = floor(Int)
    Int = Int / Int
    Int = Int % Int
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

grammar_fuel_cost = merge_grammar([
    input_fuel_cost, 
    grammar_integer,
    # grammar_boolean
])

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
    Return = Dict(:output1 => Int)
end

## GCD problem
input_gcd = @csgrammar begin
    Int = input1 | input2
    Int = 0
    Return = Dict(:output1 => Int)
end

grammar_gcd = merge_grammar([input_gcd, grammar_integer, grammar_boolean, grammar_state_integer])

minimal_grammar_gcd_old = @csgrammar begin
    Int = input1 | input2
    Return = Dict(:output1 => Int)
    Int = 0
    State = Dict(:x => Int, :y => Int)
    Int = state[:x] | state[:y]
    Int = Int % Int
    Int = let state = State; Int end
    Bool = Int > Int
    Int = while Bool; Int end; Int
    output1 = Int
end

minimal_grammar_gcd = @csgrammar begin
    # TODO should :state be a Var?
    Int = input1 | input2
    Return = Dict(:output1 => Int)
    Int = 0
    Int = Int % Int
    Bool = Int > Int
    Sym = :x | :y
    State = Dict(Sym => Int, Sym => Int)
    Int = get(state, Sym, "Key not found")
    State = merge!(state, State)
    Expr = Int | State
    Expr = begin Expr; Expr end
    Int = let state = State; Expr end
    State = while Bool; State end
end
