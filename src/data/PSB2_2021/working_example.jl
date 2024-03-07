# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret"])
using HerbGrammar, HerbSpecification, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="dev"))
using HerbSearch
import HerbInterpret.interpret

include("data.jl")
include("grammars.jl")

function HerbSearch.execute_on_input(tab::SymbolTable, expr::Expr, input::Dict{Symbol, Any})
	println("Evaluating: ", expr)

	tab = merge(tab, input)
	res = interpret(tab, expr)
	# println("Result: ", res, " of type ", typeof(res))
    res = Dict(:output1 => res)
	return res
end

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


iterator = BFSIterator(input_gcd, :Int, max_depth=4)
program = synth(problem_gcd, iterator, allow_evaluation_errors = true)

println("program: ", program)