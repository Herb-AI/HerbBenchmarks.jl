using HerbBenchmarks.Pixels_2020

prim_moveRight = RuleNode(6, [])
prim_moveLeft = RuleNode(7, [])
prim_moveUp = RuleNode(8, [])
prim_moveDown = RuleNode(9, [])
prim_draw0 = RuleNode(10, [])
prim_draw1 = RuleNode(11, [])
prim_atTop = RuleNode(14, [])
prim_atBottom = RuleNode(15, [])
prim_atLeft = RuleNode(16, [])
prim_atRight = RuleNode(17, [])
prim_notAtTop = RuleNode(18, [])
prim_notAtBottom = RuleNode(19, [])
prim_notAtLeft = RuleNode(20, [])
prim_notAtRight = RuleNode(21, [])


tags = Pixels_2020.get_relevant_tags(grammar_pixels)

function emptymatrix()
    return PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
end

function emptymatrix_bottomright()
    pixel_state = PixelState(Bool[0 0 0; 0 0 0; 0 0 0])
    pixel_state.position = (3, 3)
    return pixel_state
end

function matrix_onepixel()
    return PixelState(Bool[1 0 0; 0 0 0; 0 0 0])
end

function matrix_filledtop()
    return PixelState(Bool[1 1 1; 0 0 0; 0 0 0])
end


@testset verbose = true "Pixels_2020: General tests" begin
    problems = get_all_problems(Pixels_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample
end

@testset verbose = true "Pixels_2020: Testing pixels conditions" begin
    @testset "empty matrix, pointer top left" begin
        # Test conditions => shouldn't mutate pixel state
        test_state = emptymatrix()
        @test Pixels_2020.interpret(prim_atTop, tags, test_state) == true
        @test Pixels_2020.interpret(prim_atLeft, tags, test_state) == true
        @test Pixels_2020.interpret(prim_notAtBottom, tags, test_state) == true
        @test Pixels_2020.interpret(prim_notAtRight, tags, test_state) == true
        @test Pixels_2020.interpret(prim_atBottom, tags, test_state) == false
        @test Pixels_2020.interpret(prim_atRight, tags, test_state) == false
        @test Pixels_2020.interpret(prim_notAtTop, tags, test_state) == false
        @test Pixels_2020.interpret(prim_notAtLeft, tags, test_state) == false
    end

    @testset "empty matrix, pointer bottom right" begin
        test_state = emptymatrix_bottomright()
        @test Pixels_2020.interpret(prim_atBottom, tags, test_state) == true
        @test Pixels_2020.interpret(prim_atRight, tags, test_state) == true
        @test Pixels_2020.interpret(prim_notAtTop, tags, test_state) == true
        @test Pixels_2020.interpret(prim_notAtLeft, tags, test_state) == true
        @test Pixels_2020.interpret(prim_atTop, tags, test_state) == false
        @test Pixels_2020.interpret(prim_atLeft, tags, test_state) == false
        @test Pixels_2020.interpret(prim_notAtBottom, tags, test_state) == false
        @test Pixels_2020.interpret(prim_notAtRight, tags, test_state) == false
    end
end

@testset verbose = true "Pixels_2020: Testing pixels transformations" begin
    @testset "empty matrix, start at top left" begin
        test_state = emptymatrix() # will be modified throughout test, we reuse the same state
        Pixels_2020.interpret(prim_moveRight, tags, test_state)
        @test test_state.position == (2, 1)
        Pixels_2020.interpret(prim_moveLeft, tags, test_state)
        @test test_state.position == (1, 1)
        Pixels_2020.interpret(prim_moveDown, tags, test_state)
        @test test_state.position == (1, 2)
        Pixels_2020.interpret(prim_moveUp, tags, test_state)
        @test test_state.position == (1, 1)
    end
    @testset "moving out of bounds" begin
        # top left corner
        test_state = emptymatrix()
        Pixels_2020.interpret(prim_moveLeft, tags, test_state)
        @test test_state.position == (1, 1)
        Pixels_2020.interpret(prim_moveUp, tags, test_state)
        @test test_state.position == (1, 1)
        # bottom right corner
        test_state = emptymatrix_bottomright()
        Pixels_2020.interpret(prim_moveRight, tags, test_state)
        @test test_state.position == (3, 3)
        Pixels_2020.interpret(prim_moveDown, tags, test_state)
        @test test_state.position == (3, 3)
    end
    @testset "drawing pixels" begin
        test_state = emptymatrix()
        Pixels_2020.interpret(prim_draw1, tags, test_state)
        @test test_state.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
        Pixels_2020.interpret(prim_draw0, tags, test_state)
        @test test_state.matrix == Bool[0 0 0; 0 0 0; 0 0 0]
        # test repeated drawing doesn't break anything
        test_state = emptymatrix()
        Pixels_2020.interpret(prim_draw0, tags, emptymatrix())
        @test test_state.matrix == Bool[0 0 0; 0 0 0; 0 0 0]
        test_state = matrix_onepixel()
        Pixels_2020.interpret(prim_draw1, tags, test_state)
        @test test_state.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
    end
end

@testset verbose = true "Pixels_2020: Testing IF, WHILE and nested programs" begin
    # Test IF
    test_state = matrix_filledtop()
    prog = RuleNode(12, [RuleNode(18), RuleNode(11), RuleNode(10)]) # IF(notAtTop, draw1, draw0)
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.matrix == Bool[0 1 1; 0 0 0; 0 0 0]
    Pixels_2020.interpret(prim_moveDown, tags, test_state)
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.matrix == Bool[0 1 1; 1 0 0; 0 0 0]
    # Test WHILE
    # Test that while loop terminates correctly (even when condition is always true)
    test_state = emptymatrix()
    prog = RuleNode(13, [RuleNode(14), RuleNode(11)]) # WHILE(atTop, draw1)
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.matrix == Bool[1 0 0; 0 0 0; 0 0 0]
    prog = RuleNode(13, [RuleNode(19), RuleNode(9)]) # WHILE(notAtBottom, moveDown)
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.position == (1, 3)
    # Test nested program: turn matrix of all zeros into identity matrix
    test_state = emptymatrix()
    prog = RuleNode(3, [RuleNode(11), RuleNode(3, [RuleNode(9), RuleNode(3, [RuleNode(6), RuleNode(3, [RuleNode(11), RuleNode(3, [RuleNode(9), RuleNode(3, [RuleNode(6), RuleNode(11)])])])])])])
    Pixels_2020.interpret(prog, tags, test_state)
    @test test_state.matrix == Bool[1 0 0; 0 1 0; 0 0 1]
    @test test_state.position == (3, 3)
end
