using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbCore", "HerbSpecification", "HerbInterpret"])
using HerbGrammar, HerbCore, HerbSpecification, HerbInterpret, Pkg
Pkg.add(PackageSpec(name="HerbSearch", rev="data_to_specification"))
using HerbSearch
import HerbInterpret.interpret
using Test

include("grammar.jl")
include("grammars/custom_util.jl")
include("grammars/grammar_char.jl")
include("data_grammars.jl")

function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	# println("Evaluating: ", expr)
	res = interpret(tab, expr)
	# println("Result: ", res)
    res = Dict(k => v for (k, v) in res if occursin("output", string(k)))
	return res
end

function test_case(g::Grammar, e::IOExample, mod::Module)
	add_rule!(g, :(State = write_input_to_stack(:input, $(e.in[:input]), State)))
	add_rule!(g, :(State = get_output_from_stack(:output, $(typeof(e.out[:output])), State)))
	println(g)
	sol = HerbSearch.search(g, Problem([e]), :State, 
		max_depth=10,
		evaluator = my_evaluator,
		allow_evaluation_errors = true,
		mod = mod,
	)
	return string(sol)
end

function test_case(g::Grammar, p::Problem, mod::Module)
	sol = HerbSearch.search(g, p, :State, 
		max_depth=4,
		evaluator = my_evaluator,
		allow_evaluation_errors = true,
		mod=mod
	)
	return string(sol)
end

@testset "Benchmarks" begin
	mod = Module(:BenchmarkTest)
	Base.include(mod, "grammars/custom_util.jl")
	Base.include(mod, "grammars/grammar_numbers.jl")
	Base.include(mod, "grammars/grammar_bool.jl")
	
	println(grammar_coin_sums)
	@test test_case(grammar_coin_sums, problem_coin_sums, mod)
end


# TEST CHAR

@testset "GrammarChar" begin
	# mod = Module(:GrammarTest)

	# e = IOExample(Dict(:input => 'a'), Dict(:output => true))
	# @test test_case(grammar_paired_digits)

	# char_issletter
	# e = IOExample(Dict(:input => 'a'), Dict(:output => true))
	# @test test_case(g_char, e, mod) == "output(char_isletter(input(make_stacks())))"
	# e = IOExample(Dict(:input => '1'), Dict(:output => false))
	# @test test_case(e, mod) == "output(char_isletter(input(make_stacks())))"

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
