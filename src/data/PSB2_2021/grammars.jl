include("base_grammars.jl")

## Basement problem
input_basement = @csgrammar begin
    Integer = -1 | 0 | 1
    List = []
    Sym = :i
    Return = Dict(:output1 => Integer)
    # Integer = _(rand(-100:100))
end

grammar_basement = merge_grammar([input_basement, grammar_integer, grammar_list_integer, grammar_state_integer, grammar_boolean])

minimal_grammar_basement = @csgrammar begin
    Return = Dict(:output1 => Integer)
    List = input1
    Integer = 0 | 1
    Integer = Integer + Integer
    Bool = Integer < Integer
    Bool = Bool && Bool
    Integer = length(List)
    Integer = sum(List)
    List = getindex(List, Integer:Integer)
    Sym = :i
    State = Dict(Sym => Integer)
    Integer = get(state, Sym, "Key not found")
    State = push!(state, Sym => Integer)
    Expr = Integer | State
    Expr = begin Expr; Expr end
    Integer = let state = State; Expr end
    State = while Bool; State end  
end

## Bowling problem
input_bowling = @csgrammar begin
    String = input1
    String = "-" | "X" | "/" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "10" # | _(string(rand(10:1000))) 
    Return = Dict(:output1 => Integer)
end

grammar_bowling = merge_grammar([
    input_bowling,
    grammar_integer,
    grammar_boolean,
    grammar_string,
    # grammar_character
])

minimal_grammar_bowling = @csgrammar begin
    String = input1
    Return = Dict(:outpu1 => Integer)
    String = get(String, Integer, "out of bounds")
    Integer = parse(Int, String)
    Integer = length(String)
    Integer = 1 | 2 | 10
    Integer = Integer + Integer
    Integer = Integer - Integer
    Integer = Integer * Integer
    Bool = String == String
    Bool = String != String
    Bool = Int < Int
    Bool = Int <= Int
    Sym = :i | :frame | :score | :multiply1 | :multiply2
    State = Dict(Sym => Integer, Sym => Integer, Sym => Integer, Symb => Integer, Sym => Integer)
    State = push!(state, Sym, "key not found")
    Int = get(state, Sym, "key not found")
    Expression = Integer | State
    Expression = begin Expression; Exprpression end
    State = if Bool; State; State end
    Integer = let state = State; Expression end
    State = while Bool; Expression end  
end

## Coin Sums problem
input_coin_sums = @csgrammar begin
    Integer = 0 | 1 | 5 | 10 | 25
    Integer = input1
    Return = Dict(:output1 => Integer, :output2 => Integer, :output3 => Integer, :output4 => Integer)
end

grammar_coin_sums = merge_grammar([
    input_coin_sums,
    grammar_integer,
    grammar_boolean
])

minimal_grammar_coin_sums = @csgrammar begin
    Integer = 0 | 1 | 5 | 10 | 25
    Integer = input1
    Return = Dict(:output1 => Integer, :output2 => Integer, :output3 => Integer, :output4 => Integer)
    Integer = floor(Integer)
    Integer = Integer / Integer
    Integer = Integer % Integer
end

## FizzBuzz problem
input_fizz_buzz = @csgrammar begin
    Integer = input1
    Integer = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    Return = Dict(:output1 => String)
end

grammar_fizz_buzz = merge_grammar([input_fizz_buzz, grammar_integer, grammar_string, grammar_boolean])

minimal_grammar_fizz_buzz = @csgrammar begin
    Integer = input1
    Integer = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = string(Integer)
    Return = Dict(:output1 => String)
    Integer = Integer % Integer
    Bool = Integer == Integer
    Integer = Bool ? Integer : Integer
    Bool = Bool && Bool
end

## Fuel cost problem
input_fuel_cost = @csgrammar begin
    Integer = 0 | 1 | 2 | 3
    List = input1
    Return = Dict(:output1 => Integer)
    # Integer = rand(6:100000)
end

grammar_fuel_cost = merge_grammar([
    input_fuel_cost, 
    grammar_integer,
    grammar_boolean
])

minimal_grammar_fuel_cost = @csgrammar begin
    List = input1
    Integer = 0 | 1 | 2 | 3
    Float = Integer / Integer
    Integer = floor(Float)
    Integer = Integer - Integer
    Integer = sum(List)
    List = map(Func, List)
    Func = x -> Integer
    Integer = x
    Return = Dict(:output1 => Integer)
end

## GCD problem
input_gcd = @csgrammar begin
    Integer = input1 | input2
    Integer = 0
    Sym = :x | :y
    Return = Dict(:output1 => Integer)
    # Integer = _(rand(1,1000000))
end

grammar_gcd = merge_grammar([input_gcd, grammar_integer, grammar_boolean, grammar_state_integer])

minimal_grammar_gcd = @csgrammar begin
    Integer = input1 | input2
    Return = Dict(:output1 => Integer)
    Integer = 0
    Integer = Integer % Integer
    Bool = Integer > Integer
    Sym = :x | :y
    State = Dict(Sym => Integer, Sym => Integer)
    Integer = get(state, Sym, "Key not found")
    State = merge!(state, State)
    Expr = Integer | State
    Expr = begin Expr; Expr end
    Integer = let state = State; Expr end
    State = while Bool; State end
end
