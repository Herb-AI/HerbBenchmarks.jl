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
# TODO example of importing the files using the PSB2_2021 module

include("grammar.jl")
mod = Module(:GrammarImplementation)
g = get_grammar(["integer", "bool"], problem_coin_sums, mod)


function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	res = interpret(tab, expr)
    res = Dict(k => v for (k, v) in res if occursin("output", string(k)))
	return res
end

program, cost = search(g, problem_coin_sums, :Start, max_depth=10, evaluator=my_evaluator, allow_evaluation_errors = true)