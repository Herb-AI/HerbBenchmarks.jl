using HerbBenchmarks
using HerbSearch
using HerbGrammar

include("tensor_functions.jl")
include("targets.jl")

mod = HerbBenchmarks.Tensors_2022

function test_target_program(name)
    problem = getfield(mod, Symbol("problem_", name))
    grammar = getfield(mod, Symbol("grammar_", name))
    target_program = getfield(Main, Symbol("target_", name))

    for io_example in problem.spec
        inputs = io_example.in
        target_output = io_example.out
        grammar_tags = get_relevant_tags(grammar, inputs)
        program = HerbSearch.expr2rulenode(target_program, grammar)
        output = interpret_tensor(program, grammar_tags)

        if target_output == output
            println("\n\nSUCCES")
        else
            println("\n\nFAILED")
        end

        @show inputs
        @show target_program
        @show target_output
        @show output
    end
end

function test_all_target_programs()
    for name in names(Main, all=true)
        if startswith(string(name), "target_") && isdefined(Main, name)
            test_target_program(replace(string(name), "target_" => ""))
        end
    end
end

# target_test_add = :(tf_add(_arg_1, _arg_2))
# target_test_cast = :(tf_cast(_arg_1, tf_bool))
target_simple_add_big_tensors = :(tf_add(_arg_1, tf_expand_dims(_arg_2, 2)))
# target_simple_add_big_tensors = :(tf_add(_arg_1, tf_expand_dims(_arg_2, _arg_2)))
# target_simple_add_big_tensors = :(tf_argsort_descending(_arg_2, 2))

# test_all_target_programs()

test_target_program("simple_add_big_tensors")