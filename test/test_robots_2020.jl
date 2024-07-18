using HerbBenchmarks.Robots_2020

test_state_1 = RobotState(0, 1, 1, 1, 1, 5)
test_state_2 = RobotState(1, 5, 5, 5, 5, 5)
test_state_3 = RobotState(0, 5, 1, 1, 1, 5)

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
prim_while = RuleNode(13, [RuleNode(14), RuleNode(6)]) # WHILE(atTop, moveRight)

tags = Robots_2020.get_relevant_tags(grammar_robots)

@testset verbose = true "Robots_2020" begin
    @testset verbose = true "General tests" begin
        problems = get_all_problems(Robots_2020)
        @test typeof(problems[1]) <: HerbSpecification.Problem
        @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample
    end

    @testset verbose = true "Testing robot transformations" begin
        @testset "Robot in top left corner" begin
            @test Robots_2020.interpret(prim_moveRight, tags, test_state_1) == RobotState(0, 2, 1, 1, 1, 5)
            @test Robots_2020.interpret(prim_moveDown, tags, test_state_1) == RobotState(0, 1, 2, 1, 1, 5)
            @test Robots_2020.interpret(prim_moveLeft, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
            @test Robots_2020.interpret(prim_moveUp, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
            @test Robots_2020.interpret(prim_drop, tags, test_state_1) == RobotState(0, 1, 1, 1, 1, 5)
            @test Robots_2020.interpret(prim_grab, tags, test_state_1) == RobotState(1, 1, 1, 1, 1, 5)
        end
        # Test case: robot in bottom right corner
        @testset "Robot in bottom right corner" begin
            @test Robots_2020.interpret(prim_moveRight, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)
            @test Robots_2020.interpret(prim_moveDown, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)
            @test Robots_2020.interpret(prim_moveLeft, tags, test_state_2) == RobotState(1, 4, 5, 4, 5, 5)
            @test Robots_2020.interpret(prim_moveUp, tags, test_state_2) == RobotState(1, 5, 4, 5, 4, 5)
            @test Robots_2020.interpret(prim_drop, tags, test_state_2) == RobotState(0, 5, 5, 5, 5, 5)
            @test Robots_2020.interpret(prim_grab, tags, test_state_2) == RobotState(1, 5, 5, 5, 5, 5)
        end
    end

    @testset verbose = true "Testing robot conditions" begin
        @testset "Robot in top left corner" begin
            @test Robots_2020.interpret(prim_atTop, tags, test_state_1) == true
            @test Robots_2020.interpret(prim_atLeft, tags, test_state_1) == true
            @test Robots_2020.interpret(prim_notAtBottom, tags, test_state_1) == true
            @test Robots_2020.interpret(prim_notAtRight, tags, test_state_1) == true
            @test Robots_2020.interpret(prim_atBottom, tags, test_state_1) == false
            @test Robots_2020.interpret(prim_atRight, tags, test_state_1) == false
            @test Robots_2020.interpret(prim_notAtTop, tags, test_state_1) == false
            @test Robots_2020.interpret(prim_notAtLeft, tags, test_state_1) == false
        end

        @testset "Robot in bottom right corner" begin
            @test Robots_2020.interpret(prim_atBottom, tags, test_state_2) == true
            @test Robots_2020.interpret(prim_atRight, tags, test_state_2) == true
            @test Robots_2020.interpret(prim_notAtTop, tags, test_state_2) == true
            @test Robots_2020.interpret(prim_notAtLeft, tags, test_state_2) == true
            @test Robots_2020.interpret(prim_atTop, tags, test_state_2) == false
            @test Robots_2020.interpret(prim_atLeft, tags, test_state_2) == false
            @test Robots_2020.interpret(prim_notAtBottom, tags, test_state_2) == false
            @test Robots_2020.interpret(prim_notAtRight, tags, test_state_2) == false
        end


    end

    @testset verbose = true "Testing IF, WHILE and nested programs" begin
        @test Robots_2020.interpret(prim_if, tags, test_state_2) == RobotState(1, 5, 4, 5, 4, 5)
        # Nested program: while not at bottom move down and left
        condition = RuleNode(19)
        body = RuleNode(3, [RuleNode(7), RuleNode(8)]) # (moveDown; moveLeft)
        prog = RuleNode(13, [condition, body])
        @test Robots_2020.interpret(prog, tags, test_state_3) == RobotState(0, 1, 5, 1, 1, 5)
        @test Robots_2020.interpret(prim_if, tags, test_state_1) == RobotState(0, 1, 2, 1, 1, 5)
        # WHILE loop
        @test Robots_2020.interpret(prim_while.children[1], tags, test_state_1) == true # test that condition is true
        @test Robots_2020.interpret(prim_while, tags, test_state_1) == RobotState(0, 5, 1, 1, 1, 5)
    end
end
