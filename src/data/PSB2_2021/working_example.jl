# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret", "HerbConstraints"])
using HerbGrammar, HerbSpecification, HerbInterpret, HerbConstraints
Pkg.add(PackageSpec(name="HerbSearch"))
using HerbSearch
import HerbInterpret.interpret

include("data.jl")
include("grammars.jl")

function HerbSearch.execute_on_input(tab::SymbolTable, expr::Expr, input::Dict{Symbol, Any})
	println("Evaluating: ", expr)

	tab = merge(tab, input)
	res = interpret(tab, expr)
	# println("Result: ", res, " of type ", typeof(res))
	return res
end

problem_fizz_buzz = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => 1), Dict{Symbol, Any}(:output1 => "1")), 
    IOExample(Dict{Symbol, Any}(:input1 => 2), Dict{Symbol, Any}(:output1 => "2")), 
    IOExample(Dict{Symbol, Any}(:input1 => 3), Dict{Symbol, Any}(:output1 => "Fizz")), 
    IOExample(Dict{Symbol, Any}(:input1 => 4), Dict{Symbol, Any}(:output1 => "4"))
])

problem_fuel_cost = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => Any[6]), Dict{Symbol, Any}(:output1 => 0)), 
    IOExample(Dict{Symbol, Any}(:input1 => Any[9]), Dict{Symbol, Any}(:output1 => 1)), 
    IOExample(Dict{Symbol, Any}(:input1 => Any[15]), Dict{Symbol, Any}(:output1 => 3)), 
    IOExample(Dict{Symbol, Any}(:input1 => Any[9998]), Dict{Symbol, Any}(:output1 => 3330))
])

problem_gcd = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => 1, :input2 => 1), Dict{Symbol, Any}(:output1 => 1)), 
    IOExample(Dict{Symbol, Any}(:input1 => 4, :input2 => 400000), Dict{Symbol, Any}(:output1 => 4)), 
    IOExample(Dict{Symbol, Any}(:input1 => 9, :input2 => 6), Dict{Symbol, Any}(:output1 => 3))
])

problem_coin_sums = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => 25), Dict{Symbol, Any}(:output1 => 0, :output2 => 0, :output3 => 0, :output4 => 1)),
    IOExample(Dict{Symbol, Any}(:input1 => 50), Dict{Symbol, Any}(:output1 => 0, :output2 => 0, :output3 => 0, :output4 => 2)),
    IOExample(Dict{Symbol, Any}(:input1 => 75), Dict{Symbol, Any}(:output1 => 0, :output2 => 0, :output3 => 0, :output4 => 3)),
    IOExample(Dict{Symbol, Any}(:input1 => 125), Dict{Symbol, Any}(:output1 => 0, :output2 => 0, :output3 => 0, :output4 => 5))
])


# TODO current way of adding the random value to the grammar, waiting on compatibility with _() in HerbGrammar
randX = rand(1:10)
grammar_test_square_with_random = @csgrammar begin
    Int = input1
    Int = Int + Int
    Int = Int * Int
    Int = 1
    Int = randX
    Return = Dict(Symbol("output1") => Int)
end
problem_test_square_with_random = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => 5), Dict{Symbol, Any}(:output1 => 25)),
    IOExample(Dict{Symbol, Any}(:input1 => 4), Dict{Symbol, Any}(:output1 => 16)),
    IOExample(Dict{Symbol, Any}(:input1 => 9), Dict{Symbol, Any}(:output1 => 81)),
])


iterator = BFSIterator(grammar_test_square_with_random, :Return, max_depth=3)
program = synth(problem_test_square_with_random, iterator, allow_evaluation_errors=false)

println("program: ", program)