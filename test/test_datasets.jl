using HerbCore
using HerbSpecification
using Test

using HerbBenchmarks
using HerbBenchmarks.String_transformations_2020

@testset verbose=true "String transformations 2020" begin
    problems = all_problems(String_transformations_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample

    prim_moveRight = RuleNode(6, [])
    prim_moveLeft = RuleNode(7, [])
    prim_makeUpperCase = RuleNode(8, [])
    prim_makeLowerCase = RuleNode(9, [])
    prim_drop = RuleNode(10, [])

    prim_atEnd = RuleNode(13, [])

    test_state_1 = StringState("abc", 1)
    

    @test interpret(prim_moveRight, test_state_1) == StringState("abc", 2)
    @test interpret(prim_drop, test_state_1) == StringState("bc", 1)
    @test interpret(prim_atEnd, test_state_1) == false

end

