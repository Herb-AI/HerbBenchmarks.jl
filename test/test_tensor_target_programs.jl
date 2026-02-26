using HerbCore
using HerbBenchmarks
using HerbSpecification
using Test

using HerbBenchmarks.Tensors_2022
using HerbSearch
using HerbGrammar

function t(name, expr)
    @testset "$name" begin
        problem = getfield(Tensors_2022, Symbol("problem_", name))
        grammar = getfield(Tensors_2022, Symbol("grammar_", name))

        for io in problem.spec
            grammar_tags = Tensors_2022.get_relevant_tags(grammar, io.in)
            program = expr2rulenode(expr, grammar)
            output = Tensors_2022.interpret_tensor(program, grammar_tags)
            output = hcat(output...)'
            target_output = hcat(io.out...)'
            @test target_output == output
        end
    end
end

@testset "Tensor target program" begin
    t("test_add", :(tf_add(_arg_1, _arg_2)))
    t("test_cast", :(tf_cast(_arg_1, tf_bool)))

    t("simple_add_big_tensors", :(tf_add(_arg_1, tf_expand_dims(_arg_2, tf_axis(2)))))
    t("simple_broadcasted_add", :(tf_add(_arg_1, tf_expand_dims(_arg_2, tf_axis(2)))))
    t("simple_cast", :(tf_cast(_arg_1, tf_float)))
    t("simple_index", :(tf_index(_arg_1, _arg_2)))
    t("simple_output_equals_constant", :(tf_constant(10)))
    t("simple_output_equals_input_multiple", :(_arg_2))
    t("simple_output_equals_input_single", :(_arg_1))
    # t("simple_slice", :(slice(_arg_1, tf_ranges(tf_range(start, finish), range(2, _arg_2)))))
    t("simple_sparse_add", :(tf_sparse_add(_arg_1, tf_sparse_from_dense(_arg_2))))
    t("simple_using_boolean_constant", :(tf_sparse_reduce_sum(_arg_1, tf_axis(2), tf_true)))
    t("simple_using_constant", :(tf_add(_arg_1, tf_constant(100))))
    t("simple_using_constant_kwarg", :(tf_argsort_descending(_arg_1, tf_axis(1))))
    t("simple_using_output_shape", :(tf_multiply(_arg_1, tf_eye(5))))
    t("simple_using_output_shape_tuple", :(tf_zeros(tf_dimensions(tf_dimension(2), tf_dimensions(tf_dimension(3), tf_dimensions(tf_dimension(4), tf_dimension(5)))))))
    t("simple_using_primitive_input", :(tf_add(_arg_2, tf_constant(_arg_1))))
    # t("simple_with_many_inputs", :(tf_gather(_arg_1, _arg_2, _arg_3, _arg_4)))
    # t("", :())
    # t("", :())
end