using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbData", "HerbInterpret"])
using HerbGrammar, HerbData, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="dev"))
using HerbSearch
import HerbInterpret.interpret
using Test


include("grammar.jl")


function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	println("Evaluating: ", expr)
	res = interpret(tab, expr)
	println("Result: ", res)
    res = Dict(k => v for (k, v) in res if occursin("output", string(k)))
	println("Final: ", res)
	return res
end

function test_case(e::IOExample, mod::Module)
	g = merge_grammar([make_input_output_grammar(e, mod), g_char])
	println(g)
	sol = HerbSearch.search(g, Problem([e]), :State, max_depth=4,
		evaluator = my_evaluator,
		allow_evaluation_errors = true,
		mod = mod,
	)
	return string(sol)
end

# TEST CHAR

@testset "GrammarChar" begin
	mod = Module(:GrammarTest)
	Base.include(mod, "grammars/custom_util.jl")
	Base.include(mod, "grammars/grammar_char.jl")

	# char_issletter
	e = IOExample(Dict(:input => 'a'), Dict(:output => true))
	@test test_case(e, mod) == "output(char_isletter(input(make_stacks())))"
	e = IOExample(Dict(:input => '1'), Dict(:output => false))
	@test test_case(e, mod) == "output(char_isletter(input(make_stacks())))"

	# # char_isdigit
	# e = IOExample(Dict(:input => 'a'), Dict(:output => false))
	# @test test_case(e, mod) == "output(char_isdigit(input(make_stacks())))"
	# e = IOExample(Dict(:input => '2'), Dict(:output => true))
	# @test test_case(e, mod) == "output(char_isdigit(input(make_stacks())))"
	
	# # char_iswhitespace
	# e = IOExample(Dict(:input => ' '), Dict(:output => true))
	# @test test_case(e, mod) == "output(char_iswhitespace(input(make_stacks())))"
	# e = IOExample(Dict(:input => 'a'), Dict(:output => false))
	# @test test_case(e, mod) == "output(char_iswhitespace(input(make_stacks())))"

	# # char_lowercase
	# e = IOExample(Dict(:input => 'A'), Dict(:output => 'a'))
	# @test test_case(e, mod) == "output(char_lowercase(input(make_stacks())))"

	# # char_uppercase
	# e = IOExample(Dict(:input => 'a'), Dict(:output => 'A'))
	# @test test_case(e, mod) == "output(char_uppercase(input(make_stacks())))"

	# # char_fromfloat
	# e = IOExample(Dict(:input => 100), Dict(:output => 'd'))
	# @test test_case(e, mod) == "output(char_fromfloat(input(make_stacks())))"
	# e = IOExample(Dict(:input => 45), Dict(:output => '-'))
	# @test test_case(e, mod) == "output(char_fromfloat(input(make_stacks())))"

	# # char_allfromstring
	# e = IOExample(Dict(:input => "test"), Dict(:output => ['t', 'e', 's', 't']))
	# @test test_case(e, mod) == "output(char_allfromstring(input(make_stacks())))"
end
