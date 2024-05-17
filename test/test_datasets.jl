using HerbCore
using HerbSpecification
using Test

using HerbBenchmarks
using HerbBenchmarks.String_transformations_2020

@testset verbose = true "String transformations 2020" begin
    problems = all_problems(String_transformations_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample

    prim_moveRight = RuleNode(6, [])
    prim_moveLeft = RuleNode(7, [])
    prim_makeUpperCase = RuleNode(8, [])
    prim_makeLowerCase = RuleNode(9, [])
    prim_drop = RuleNode(10, [])

    prim_atEnd = RuleNode(13, [])
    prim_notAtEnd = RuleNode(14, [])
    prim_atSart = RuleNode(15, [])
    prim_notAtStart = RuleNode(16, [])
    prim_isLetter = RuleNode(17, [])
    prim_isNotLetter = RuleNode(18, [])
    prim_isUppercase = RuleNode(19, [])
    prim_isNotUpperCase = RuleNode(20, [])
    prim_isLowercase = RuleNode(21, [])
    prim_isNotLowercase = RuleNode(22, [])
    prim_isNumber = RuleNode(23, [])
    prim_isNotNumber = RuleNode(24, [])
    prim_isSpace = RuleNode(25, [])
    prim_isNotSpace = RuleNode(26, [])

    test_state_1 = StringState("abc", 1)
    test_state_2 = StringState("abc", 3)
    test_state_3 = StringState("Abc", 1)
    test_state_4 = StringState("abc", 2)
    test_state_5 = StringState("ab!c", 3)
    test_state_6 = StringState("a1?", 2)
    test_state_7 = StringState("   ", 2)
    test_state_8 = StringState("a", 1)
    test_state_9 = StringState("", 0)

    # Test case: multiple character string
    @test interpret(prim_moveRight, test_state_1) == StringState("abc", 2)
    @test interpret(prim_moveLeft, test_state_2) == StringState("abc", 2)
    @test interpret(prim_makeUpperCase, test_state_2) == StringState("abC", 3)
    @test interpret(prim_makeLowerCase, test_state_3) == StringState("abc", 1)
    @test interpret(prim_drop, test_state_1) == StringState("bc", 1)
    @test interpret(prim_atEnd, test_state_2) == true
    @test interpret(prim_atEnd, test_state_1) == false && interpret(prim_notAtEnd, test_state_1) == true
    @test interpret(prim_atSart, test_state_1) == true && interpret(prim_notAtStart, test_state_1) == false
    @test interpret(prim_notAtStart, test_state_4) == true && interpret(prim_notAtEnd, test_state_4) == true
    @test interpret(prim_isLetter, test_state_1) == true
    @test interpret(prim_isLetter, test_state_5) == false && interpret(prim_isNotLetter, test_state_5) == true
    @test interpret(prim_isUppercase, test_state_3) == true && interpret(prim_isNotUpperCase, test_state_3) == false
    @test interpret(prim_isLowercase, test_state_1) == true && interpret(prim_isNotLowercase, test_state_1) == false
    @test interpret(prim_isNumber, test_state_6) == true
    @test interpret(prim_isNotNumber, test_state_1) == true
    @test interpret(prim_isSpace, test_state_6) == false && interpret(prim_isNotSpace, test_state_6) == true

    # Test case: single character string
    @test interpret(prim_moveRight, test_state_8) == StringState("a", 1)
    @test interpret(prim_moveLeft, test_state_8) == StringState("a", 1)
    @test interpret(prim_drop, test_state_8) == StringState("", 0) # TODO: is that how we want this to behave?
    @test interpret(prim_atEnd, test_state_8) == true && interpret(prim_atSart, test_state_8) == true

end

