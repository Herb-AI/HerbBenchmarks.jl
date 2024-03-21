include("base_grammars.jl")

input_basement = @csgrammar begin
    Int = -1 | 0 | 1
    List = []
    Integer = rand(-100:100)
end

input_fizz_buzz = @csgrammar begin
    Int = input1
    Int = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    output1 = String
end

grammar_fizz_buzz = merge_grammar([input_fizz_buzz, grammar_integer, grammar_string, grammar_boolean, grammar_execution])

# Given a vector of positive integers, divide each by 3, round the result down to the nearest integer, and subtract 2. Return the sum of all of the new integers in the vector
input_fuel_cost = @csgrammar begin
    List = input1
    Int = 0 | 1 | 2 | 3
    Int = rand(6:100000)
    Float = Int / 3
    Int = floor(Float)
    Int = Int - 2
    Int = sum(List)
    Func = Div | floor | Sub 
    List = map(Func, List)
    Func = x -> Int
    Int = x
    output1 = Int
end

struct StateObj
    x::Int
    y::Int
end

input_gcd = @csgrammar begin
    Int = input1
    Int = input2
    State = Dict(:x => Int, :y => Int)
    Int = State[:x] | State[:y]
    Int = Int % Int
    Int = let state = State; Int end
    # Bool = Int == 0
    Bool = Int > Int
    # Bool = Bool && Bool
    Int = while Bool; Int end; Int
    # Int = Bool ? Int : Int
    output1 = Int
    Int = rand(1:1000000) # this should add one random number to the grammar
end
