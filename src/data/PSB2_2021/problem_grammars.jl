include("psb2_primitives.jl")

## Basement problem
input_basement = @csgrammar begin
    IntRule = -1 | 0 | 1
    List = []
    Sym = :i
    Return = Dict(:output1 => IntRule)
end

minimal_grammar_basement = @csgrammar begin
    Return = Dict(:output1 => IntRule)
    List = input1
    IntRule = 0 | 1
    IntRule = IntRule + IntRule
    Boolean = IntRule < IntRule
    Boolean = Boolean && Boolean
    IntRule = length(List)
    IntRule = sum(List)
    List = getindex(List, IntRule:IntRule)
    Sym = :i
    State = Dict(Sym => IntRule)
    IntRule = get(state, Sym, "Key not found")
    State = push!(state, Sym => IntRule)
    Expression = IntRule | State
    Expression = begin Expression; Expression end
    IntRule = let state = State; Expression end
    State = command_while(Boolean, IntRule)
end

## Coin Sums problem
input_coin_sums = @csgrammar begin
    IntRule = 0 | 1 | 5 | 10 | 25
    IntRule = input1
    Return = Dict(:output1 => IntRule, :output2 => IntRule, :output3 => IntRule, :output4 => IntRule)
end

minimal_grammar_coin_sums = @csgrammar begin
    IntRule = 0 | 1 | 5 | 10 | 25
    IntRule = input1
    Return = Dict(:output1 => IntRule, :output2 => IntRule, :output3 => IntRule, :output4 => IntRule)
    IntRule = floor(IntRule)
    IntRule = IntRule / IntRule
    IntRule = IntRule % IntRule
end

## FizzBuzz problem
input_fizz_buzz = @csgrammar begin
    IntRule = input1
    IntRule = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    Return = Dict(:output1 => String)
end

minimal_grammar_fizz_buzz = @csgrammar begin
    IntRule = input1
    IntRule = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = string(IntRule)
    Return = Dict(:output1 => String)
    IntRule = IntRule % IntRule
    Boolean = IntRule == IntRule
    IntRule = Boolean ? IntRule : IntRule
    Boolean = Boolean && Boolean
end

## Fuel cost problem
input_fuel_cost = @csgrammar begin
    IntRule = 0 | 1 | 2 | 3
    List = input1
    Return = Dict(:output1 => IntRule)
end

minimal_grammar_fuel_cost = @csgrammar begin
    List = input1
    IntRule = 0 | 1 | 2 | 3
    Float = IntRule / IntRule
    IntRule = floor(Float)
    IntRule = IntRule - IntRule
    IntRule = sum(List)
    List = map(Func, List)
    Func = x -> IntRule
    IntRule = x
    Return = Dict(:output1 => IntRule)
end

## GCD problem
input_gcd = @csgrammar begin
    IntRule = input1 | input2
    IntRule = 0
    Sym = :x | :y
    Return = Dict(:output1 => IntRule)
end

minimal_grammar_gcd = @csgrammar begin
    IntRule = input1 | input2
    Return = Dict(:output1 => IntRule)
    IntRule = 0
    IntRule = IntRule % IntRule
    Boolean = IntRule > IntRule
    Sym = :x | :y
    State = Dict(Sym => IntRule, Sym => IntRule)
    IntRule = get(state, Sym, "Key not found")
    State = merge!(state, State)
    Expression = IntRule | State
    Expression = begin Expression; Expression end
    IntRule = let state = State; Expression end
    State = command_while(Boolean, State)
end