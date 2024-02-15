# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret"])
using HerbGrammar, HerbSpecification, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="data_to_specification"))
using HerbSearch
import HerbInterpret.interpret
Pkg.add(["Conda", "PyCall", "JSON"])

include("data.jl") # includes `problem_coin_sums` test data
include("grammars.jl")

function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	# println("Evaluating: ", expr)
	tab = merge(tab, input)
	res = interpret(tab, expr)
	# println("Result: ", res, " of type ", typeof(res))
    res = Dict(:output1 => res)
	return res
end

problem_fizz_buzz = Problem([
	IOExample(Dict{Symbol, Any}(:input1 => 1), Dict{Symbol, Any}(:output1 => "1")), IOExample(Dict{Symbol, Any}(:input1 => 2), Dict{Symbol, Any}(:output1 => "2")), IOExample(Dict{Symbol, Any}(:input1 => 3), Dict{Symbol, Any}(:output1 => "Fizz")), 
	IOExample(Dict{Symbol, Any}(:input1 => 4), Dict{Symbol, Any}(:output1 => "4")), IOExample(Dict{Symbol, Any}(:input1 => 5), Dict{Symbol, Any}(:output1 => "Buzz")), 
	IOExample(Dict{Symbol, Any}(:input1 => 6), Dict{Symbol, Any}(:output1 => "Fizz")), IOExample(Dict{Symbol, Any}(:input1 => 7), Dict{Symbol, Any}(:output1 => "7")), IOExample(Dict{Symbol, Any}(:input1 => 8), Dict{Symbol, Any}(:output1 => "8")), IOExample(Dict{Symbol, Any}(:input1 => 9), Dict{Symbol, Any}(:output1 => "Fizz")), IOExample(Dict{Symbol, Any}(:input1 => 10), Dict{Symbol, Any}(:output1 => "Buzz")),
	# IOExample(Dict{Symbol, Any}(:input1 => 11), Dict{Symbol, Any}(:output1 => "11")), IOExample(Dict{Symbol, Any}(:input1 => 12), Dict{Symbol, Any}(:output1 => "Fizz")), IOExample(Dict{Symbol, Any}(:input1 => 13), Dict{Symbol, Any}(:output1 => "13")), IOExample(Dict{Symbol, Any}(:input1 => 14), Dict{Symbol, Any}(:output1 => "14")), IOExample(Dict{Symbol, Any}(:input1 => 15), Dict{Symbol, Any}(:output1 => "FizzBuzz")),
	# IOExample(Dict{Symbol, Any}(:input1 => 16), Dict{Symbol, Any}(:output1 => "16")), IOExample(Dict{Symbol, Any}(:input1 => 17), Dict{Symbol, Any}(:output1 => "17")), IOExample(Dict{Symbol, Any}(:input1 => 18), Dict{Symbol, Any}(:output1 => "Fizz")), IOExample(Dict{Symbol, Any}(:input1 => 19), Dict{Symbol, Any}(:output1 => "19")), IOExample(Dict{Symbol, Any}(:input1 => 20), Dict{Symbol, Any}(:output1 => "Buzz")), IOExample(Dict{Symbol, Any}(:input1 => 49995), Dict{Symbol, Any}(:output1 => "FizzBuzz")), IOExample(Dict{Symbol, Any}(:input1 => 49998), Dict{Symbol, Any}(:output1 => "Fizz")), IOExample(Dict{Symbol, Any}(:input1 => 49999), Dict{Symbol, Any}(:output1 => "49999")), IOExample(Dict{Symbol, Any}(:input1 => 50000), Dict{Symbol, Any}(:output1 => "Buzz"))
])

program = @time search(grammar_fizz_buzz, problem_fizz_buzz, :String, max_depth=4, evaluator=my_evaluator, allow_evaluation_errors = true)

println("program: ", program)