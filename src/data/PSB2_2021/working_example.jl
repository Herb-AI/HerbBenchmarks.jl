# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret"])
using HerbGrammar, HerbSpecification, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="data_to_specification"))
using HerbSearch
import HerbInterpret.interpret
Pkg.add(["Conda", "PyCall", "JSON"])

include("data.jl")
include("grammars.jl")

function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
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


# program = @time search(input_fuel_cost, problem_fuel_cost, :String, max_depth=4, evaluator=my_evaluator, allow_evaluation_errors = true)

# println("program: ", program)


problem_gcd = Problem([
    IOExample(Dict{Symbol, Any}(:input1 => 1, :input2 => 1), Dict{Symbol, Any}(:output1 => 1)), 
    # IOExample(Dict{Symbol, Any}(:input1 => 4, :input2 => 400000), Dict{Symbol, Any}(:output1 => 4)), 
    IOExample(Dict{Symbol, Any}(:input1 => 54, :input2 => 24), Dict{Symbol, Any}(:output1 => 6)), 
    # IOExample(Dict{Symbol, Any}(:input1 => 4200, :input2 => 3528), Dict{Symbol, Any}(:output1 => 168)), IOExample(Dict{Symbol, Any}(:input1 => 820000, :input2 => 63550), Dict{Symbol, Any}(:output1 => 2050)), IOExample(Dict{Symbol, Any}(:input1 => 123456, :input2 => 654321), Dict{Symbol, Any}(:output1 => 3))
])


program = @time search(input_gcd, problem_gcd, :Int, max_depth=4, evaluator=my_evaluator, allow_evaluation_errors = true)

println("program: ", program)