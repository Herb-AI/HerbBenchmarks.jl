using HerbCore
using HerbSpecification
using Test

using HerbBenchmarks
using HerbBenchmarks.String_transformations_2020
using HerbBenchmarks.Robots_2020
using HerbBenchmarks.Pixels_2020


@testset verbose = true "String transformations 2020" begin
    problems = all_problems(String_transformations_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample

    prim_moveRight = RuleNode(6, [])
    prim_moveLeft = RuleNode(7, [])
    prim_makeUppercase = RuleNode(8, [])
    prim_makeLowercase = RuleNode(9, [])
    prim_drop = RuleNode(10, [])

    prim_atEnd = RuleNode(13, [])
    prim_notAtEnd = RuleNode(14, [])
    prim_atStart = RuleNode(15, [])
    prim_notAtStart = RuleNode(16, [])
    prim_isLetter = RuleNode(17, [])
    prim_isNotLetter = RuleNode(18, [])
    prim_isUppercase = RuleNode(19, [])
    prim_isNotUppercase = RuleNode(20, [])
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

    # get tags for grammar
    tags = String_transformations_2020.get_relevant_tags(grammar_string)

    # Test case: multiple character string
    @test String_transformations_2020.interpret(prim_moveRight, tags, test_state_1) == StringState("abc", 2)
    @test String_transformations_2020.interpret(prim_moveLeft, tags, test_state_2) == StringState("abc", 2)
    @test String_transformations_2020.interpret(prim_makeUppercase, tags, test_state_2) == StringState("abC", 3)
    @test String_transformations_2020.interpret(prim_makeLowercase, tags, test_state_3) == StringState("abc", 1)
    @test String_transformations_2020.interpret(prim_drop, tags, test_state_1) == StringState("bc", 1)
    @test String_transformations_2020.interpret(prim_atEnd, tags, test_state_2) == true
    @test String_transformations_2020.interpret(prim_atEnd, tags, test_state_1) == false && String_transformations_2020.interpret(prim_notAtEnd, tags, test_state_1) == true
    @test String_transformations_2020.interpret(prim_atStart, tags, test_state_1) == true
    @test String_transformations_2020.interpret(prim_notAtStart, tags, test_state_1) == false

    @test String_transformations_2020.interpret(prim_notAtStart, tags, test_state_4) == true && String_transformations_2020.interpret(prim_notAtEnd, tags, test_state_4) == true
    @test String_transformations_2020.interpret(prim_isLetter, tags, test_state_1) == true
    @test String_transformations_2020.interpret(prim_isLetter, tags, test_state_5) == false && String_transformations_2020.interpret(prim_isNotLetter, tags, test_state_5) == true
    @test String_transformations_2020.interpret(prim_isUppercase, tags, test_state_3) == true && String_transformations_2020.interpret(prim_isNotUppercase, tags, test_state_3) == false
    @test String_transformations_2020.interpret(prim_isLowercase, tags, test_state_1) == true && String_transformations_2020.interpret(prim_isNotLowercase, tags, test_state_1) == false
    @test String_transformations_2020.interpret(prim_isNumber, tags, test_state_6) == true
    @test String_transformations_2020.interpret(prim_isNotNumber, tags, test_state_1) == true
    @test String_transformations_2020.interpret(prim_isSpace, tags, test_state_6) == false && String_transformations_2020.interpret(prim_isNotSpace, tags, test_state_6) == true

    # Test case: single character string
    @test String_transformations_2020.interpret(prim_moveRight, tags, test_state_8) == StringState("a", 1)
    @test String_transformations_2020.interpret(prim_moveLeft, tags, test_state_8) == StringState("a", 1)
    @test String_transformations_2020.interpret(prim_drop, tags, test_state_8) == StringState("", 0) # TODO: is that how we want this to behave?
    @test String_transformations_2020.interpret(prim_atEnd, tags, test_state_8) == true && String_transformations_2020.interpret(prim_atStart, tags, test_state_8) == true

    # Test case: empty string (pointer at 0)
    ## Transformations
    @test String_transformations_2020.interpret(prim_moveRight, tags, test_state_9) == StringState("", 0)
    @test String_transformations_2020.interpret(prim_moveLeft, tags, test_state_9) == StringState("", 1) # TODO: shouldn't change string state -> == StringState("", 0)
    @test_throws BoundsError String_transformations_2020.interpret(prim_makeUppercase, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_makeLowercase, tags, test_state_9)
    @test String_transformations_2020.interpret(prim_drop, tags, test_state_9) == StringState("", -1) # TODO: pointer shouldn't be -1

    ## Conditions
    @test String_transformations_2020.interpret(prim_atEnd, tags, test_state_9) == true
    # @test String_transformations_2020.interpret(prim_atStart, tags, test_state_9) == true # TODO: should evaluate to true
    @test String_transformations_2020.interpret(prim_notAtEnd, tags, test_state_9) == false
    # @test String_transformations_2020.interpret(prim_notAtStart, tags, test_state_9) == true # TODO
    @test_throws BoundsError String_transformations_2020.interpret(prim_isLetter, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNotLetter, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isUppercase, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNotUppercase, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isLowercase, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNotLowercase, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNumber, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNotNumber, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isSpace, tags, test_state_9)
    @test_throws BoundsError String_transformations_2020.interpret(prim_isNotSpace, tags, test_state_9)
end

@testset verbose = true "Robots 2020" begin
    problems = all_problems(Robots_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample

    prim_moveRight = RuleNode(6, [])
    prim_moveDown = RuleNode(7, [])
    prim_moveLeft = RuleNode(8, [])
    prim_moveUp = RuleNode(9, [])
    prim_drop = RuleNode(10, [])
    prim_grab = RuleNode(11, [])
    prim_atTop = RuleNode(14, [])
    prim_atBottom = RuleNode(15, [])
    prim_atLeft = RuleNode(16, [])
    prim_atRight = RuleNode(17, [])
    prim_notAtTop = RuleNode(18, [])
    prim_notAtBottom = RuleNode(19, [])
    prim_notAtLeft = RuleNode(20, [])
    prim_notAtRight = RuleNode(21, [])
    prim_if = RuleNode(12, [RuleNode(18), RuleNode(9), RuleNode(7)]) # IF(notAtTop, moveUp, moveDown)

    # get tags for grammar
    tags = Robots_2020.get_relevant_tags(grammar_robots)

    # Test case: robot is at the top left corner of the grid, not holding ball (ball position shouldn't change)
    test_state_1 = RobotState(0, 1, 1, 1, 1, 5)
    @test Robots_2020.interpret(prim_moveRight, tags, test_state_1) == RobotState(0, 2, 1, 1, 1, 5)
    @test Robots_2020.interpret(prim_moveDown, tags, test_state_1) == RobotState(0, 1, 2, 1, 1, 5)
    @test Robots_2020.interpret(prim_moveLeft, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
    @test Robots_2020.interpret(prim_moveUp, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
    @test Robots_2020.interpret(prim_drop, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
    @test Robots_2020.interpret(prim_grab, tags, test_state_1) == RobotState(1, 1, 1, 1, 1, 5)

    @test Robots_2020.interpret(prim_atTop, tags, test_state_1) == true
    @test Robots_2020.interpret(prim_atLeft, tags, test_state_1) == true
    @test Robots_2020.interpret(prim_notAtBottom, tags, test_state_1) == true
    @test Robots_2020.interpret(prim_notAtRight, tags, test_state_1) == true

    @test Robots_2020.interpret(prim_atBottom, tags, test_state_1) == false
    @test Robots_2020.interpret(prim_atRight, tags, test_state_1) == false
    @test Robots_2020.interpret(prim_notAtTop, tags, test_state_1) == false
    @test Robots_2020.interpret(prim_notAtLeft, tags, test_state_1) == false

    @test Robots_2020.interpret(prim_if, tags, test_state_1) == RobotState(0, 1, 2, 1, 1, 5)

    # Test case: robot is at the bottom right corner of the grid, holding ball (ball position should change)
    test_state_2 = RobotState(1, 5, 5, 5, 5, 5)
    @test Robots_2020.interpret(prim_moveRight, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)
    @test Robots_2020.interpret(prim_moveDown, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)
    @test Robots_2020.interpret(prim_moveLeft, tags, test_state_2) == RobotState(1, 4, 5, 4, 5, 5)
    @test Robots_2020.interpret(prim_moveUp, tags, test_state_2) == RobotState(1, 5, 4, 5, 4, 5)
    @test Robots_2020.interpret(prim_drop, tags, test_state_2) == RobotState(0, 5, 5, 5, 5, 5)
    @test Robots_2020.interpret(prim_grab, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)

    @test Robots_2020.interpret(prim_atBottom, tags, test_state_2) == true
    @test Robots_2020.interpret(prim_atRight, tags, test_state_2) == true
    @test Robots_2020.interpret(prim_notAtTop, tags, test_state_2) == true
    @test Robots_2020.interpret(prim_notAtLeft, tags, test_state_2) == true

    @test Robots_2020.interpret(prim_atTop, tags, test_state_2) == false
    @test Robots_2020.interpret(prim_atLeft, tags, test_state_2) == false
    @test Robots_2020.interpret(prim_notAtBottom, tags, test_state_2) == false
    @test Robots_2020.interpret(prim_notAtRight, tags, test_state_2) == false

    @test Robots_2020.interpret(prim_if, tags, test_state_2) == RobotState(1, 5, 4, 5, 4, 5)
end

@testset verbose = true "Pixels_2020.interpret conditions" begin
    problems = all_problems(Pixels_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample


    prim_atTop = RuleNode(14, [])
    prim_atBottom = RuleNode(15, [])
    prim_atLeft = RuleNode(16, [])
    prim_atRight = RuleNode(17, [])
    prim_notAtTop = RuleNode(18, [])
    prim_notAtBottom = RuleNode(19, [])
    prim_notAtLeft = RuleNode(20, [])
    prim_notAtRight = RuleNode(21, [])


    # get tags for grammar
    tags = Pixels_2020.get_relevant_tags(grammar_pixels)

    # Test case: empty canvas, pointer at top left corner
    test_state_1 = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
    @test Pixels_2020.interpret(prim_atTop, tags, test_state_1) == true
    @test Pixels_2020.interpret(prim_atLeft, tags, test_state_1) == true
    @test Pixels_2020.interpret(prim_notAtBottom, tags, test_state_1) == true
    @test Pixels_2020.interpret(prim_notAtRight, tags, test_state_1) == true
    @test Pixels_2020.interpret(prim_atBottom, tags, test_state_1) == false
    @test Pixels_2020.interpret(prim_atRight, tags, test_state_1) == false
    @test Pixels_2020.interpret(prim_notAtTop, tags, test_state_1) == false
    @test Pixels_2020.interpret(prim_notAtLeft, tags, test_state_1) == false


    # Test case: empty canvas, pointer at bottom right corner
    test_state_2 = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
    test_state_2.position = (3, 3)
    @test Pixels_2020.interpret(prim_atBottom, tags, test_state_2) == true
    @test Pixels_2020.interpret(prim_atRight, tags, test_state_2) == true
    @test Pixels_2020.interpret(prim_notAtTop, tags, test_state_2) == true
    @test Pixels_2020.interpret(prim_notAtLeft, tags, test_state_2) == true
    @test Pixels_2020.interpret(prim_atTop, tags, test_state_2) == false
    @test Pixels_2020.interpret(prim_atLeft, tags, test_state_2) == false
    @test Pixels_2020.interpret(prim_notAtBottom, tags, test_state_2) == false
    @test Pixels_2020.interpret(prim_notAtRight, tags, test_state_2) == false
end

@testset verbose = true "Pixels_2020.interpret transformations" begin
    prim_moveRight = RuleNode(6, [])
    prim_moveLeft = RuleNode(7, [])
    prim_moveUp = RuleNode(8, [])
    prim_moveDown = RuleNode(9, [])
    prim_draw0 = RuleNode(10, [])
    prim_draw1 = RuleNode(11, [])

    # get tags for grammar
    tags = Pixels_2020.get_relevant_tags(grammar_pixels)

    test_state_1 = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])

    Pixels_2020.interpret(prim_moveRight, tags, test_state_1)
    @test test_state_1.position == (2, 1)
    Pixels_2020.interpret(prim_moveLeft, tags, test_state_1)
    @test test_state_1.position == (1, 1)
    Pixels_2020.interpret(prim_moveDown, tags, test_state_1)
    @test test_state_1.position == (1, 2)
    Pixels_2020.interpret(prim_moveUp, tags, test_state_1)
    @test test_state_1.position == (1, 1)
    Pixels_2020.interpret(prim_moveLeft, tags, test_state_1)
    @test test_state_1.position == (1, 1)
    Pixels_2020.interpret(prim_moveUp, tags, test_state_1)
    @test test_state_1.position == (1, 1)
    # move pointer to bottom right element of matrix
    Pixels_2020.interpret(prim_moveDown, tags, test_state_1)
    Pixels_2020.interpret(prim_moveDown, tags, test_state_1)
    Pixels_2020.interpret(prim_moveDown, tags, test_state_1)
    Pixels_2020.interpret(prim_moveRight, tags, test_state_1)
    Pixels_2020.interpret(prim_moveRight, tags, test_state_1)
    @test test_state_1.position == (3, 3)
    # Tests on this edge case ...
    Pixels_2020.interpret(prim_moveDown, tags, test_state_1)
    Pixels_2020.interpret(prim_moveRight, tags, test_state_1)
    @test test_state_1.position == (3, 3)
    # Draw 
    test_state_2 = PixelState(Bool[1 0 0; 0 0 0; 0 0 0])
    Pixels_2020.interpret(prim_draw1, tags, test_state_2)
    @test test_state_2.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
    Pixels_2020.interpret(prim_draw0, tags, test_state_1)
    @test test_state_1.matrix == Bool[0 0 0; 0 0 0; 0 0 0]
    Pixels_2020.interpret(prim_draw0, tags, test_state_1)
    @test test_state_1.matrix == Bool[0 0 0; 0 0 0; 0 0 0]
    Pixels_2020.interpret(prim_draw1, tags, test_state_2)
    @test test_state_2.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
    # Test if 
    test_state_3 = PixelState(Bool[1 1 1; 0 0 0; 0 0 0])
    prim_if = RuleNode(12, [RuleNode(18), RuleNode(11), RuleNode(10)]) # IF(notAtTop, draw1, draw0)
    Pixels_2020.interpret(prim_if, tags, test_state_3)
    @test test_state_3.matrix == Bool[0 1 1; 0 0 0; 0 0 0]
    Pixels_2020.interpret(prim_moveDown, tags, test_state_3)
    Pixels_2020.interpret(prim_if, tags, test_state_3)
    @test test_state_3.matrix == Bool[0 1 1; 1 0 0; 0 0 0]
    # Test while
    test_state_4 = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
    prim_while_1 = RuleNode(13, [RuleNode(14), RuleNode(11)]) # WHILE(atTop, draw1)
    Pixels_2020.interpret(prim_while_1, tags, test_state_4)
    @test test_state_4.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
    prim_while_2 = RuleNode(13, [RuleNode(19), RuleNode(9)]) # WHILE(notAtBottom, moveDown)
    Pixels_2020.interpret(prim_while_2, tags, test_state_4)
    @test test_state_4.position == (1, 3)
    # Test nested program: turn matrix of all zeros into identity matrix 
    test_state = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
    prog = RuleNode(3, [RuleNode(11), RuleNode(3, [RuleNode(9), RuleNode(3, [RuleNode(6), RuleNode(3, [RuleNode(11), RuleNode(3, [RuleNode(9), RuleNode(3, [RuleNode(6), RuleNode(11)])])])])])])
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.matrix == Bool[1 0 0; 0 1 0; 0 0 1]
    @test test_state.position == (3, 3)
end