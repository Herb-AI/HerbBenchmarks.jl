# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret"])
using HerbGrammar, HerbSpecification, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="data_to_specification"))
using HerbSearch
import HerbInterpret.interpret
Pkg.add(["Conda", "PyCall", "JSON"])

include("data.jl") # this includes the problem data
include("grammars.jl") # this includes the custom problem grammars

function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	tab = merge(tab, input)
	res = interpret(tab, expr)
	# This is currently custom to the fizz_buzz problem which only has one output
    res = Dict(:output1 => res)
	return res
end


program = @time search(grammar_fizz_buzz, problem_fizz_buzz, :String, max_depth=4, evaluator=my_evaluator, allow_evaluation_errors = true)

println("program: ", program)
