@testitem "MineRL_2019" begin
    import HerbBenchmarks: MineRL_2019, get_all_identifiers, get_problem, get_grammar,
        get_default_grammar, get_all_problem_grammar_pairs
    import HerbCore: RuleNode, get_rule
    import HerbSpecification: IOExample, Problem, MetricProblem, Trace
    const M = MineRL_2019

    @testset "grammars" begin
        # The movement grammar must stay a rule-index prefix of the full one:
        # a program written against either has to mean the same thing under
        # both, and one interpreter serves them on that basis.
        navigate = M.grammar_minerl_navigate.rules
        full = M.grammar_minerl.rules
        @test length(navigate) < length(full)
        @test all(navigate[i] == full[i] for i in eachindex(navigate))
        @test all(M.grammar_minerl_navigate.types[i] == M.grammar_minerl.types[i]
                  for i in eachindex(navigate))

        # The full grammar is the module default, so problems without their own
        # grammar get mining and crafting rather than movement only.
        @test get_default_grammar(M) === M.grammar_minerl
        @test get_grammar(M, "navigate_01_plain") === M.grammar_minerl_navigate
        @test get_grammar(M, "obtain_diamond") === M.grammar_minerl
    end

    @testset "problems are well formed" begin
        identifiers = get_all_identifiers(M)
        @test length(identifiers) == 17
        for pair in get_all_problem_grammar_pairs(M)
            problem = pair.problem
            @test problem isa Problem
            @test length(problem.spec) == 1
            @test problem.spec[1] isa IOExample
            @test problem.spec[1].in[:_arg_1] isa M.MineWorld
            @test problem.spec[1].out === true
        end
    end

    @testset "reference solutions solve their task" begin
        for identifier in get_all_identifiers(M)
            problem = get_problem(M, identifier)
            @test M.interpret(M.reference_program(identifier), problem.spec[1]) === true
        end
    end

    @testset "the item hierarchy is enforced" begin
        # Stone cannot be mined by hand, iron ore needs a stone pickaxe, and
        # diamond an iron one. If any of these stops being true, the Obtain*
        # tasks collapse into trivial ones.
        @test M.BLOCK_DROPS[:stone][2] == 1
        @test M.BLOCK_DROPS[:iron_ore][2] == 2
        @test M.BLOCK_DROPS[:diamond_ore][2] == 3
        @test M.BLOCK_DROPS[:log][2] == 0

        world = get_problem(M, "obtain_diamond").spec[1].in[:_arg_1]
        bare_handed = M.interpret(RuleNode(2, [M.seq_node(M.tunnel(8))]), Dict{Symbol,Any}())
        after = M.final_world(bare_handed, world)
        # Five logs come out; the stone beyond them does not.
        @test M.item_count(after, :log) == 5
        @test M.item_count(after, :cobblestone) == 0
    end

    @testset "prerequisites recover the hierarchy" begin
        chain = M.prerequisites(:diamond)
        for item in (:log, :planks, :stick, :crafting_table, :wooden_pickaxe,
            :cobblestone, :stone_pickaxe, :furnace, :iron_ore, :iron_ingot,
            :iron_pickaxe, :diamond)
            @test item in chain
        end
        # Nothing on the bed or cooking branches belongs to the diamond chain.
        @test !(:white_wool in chain)
        @test !(:cooked_beef in chain)
    end

    @testset "reward increases up the hierarchy" begin
        world = get_problem(M, "obtain_diamond").spec[1].in[:_arg_1]
        run(ops) = M.interpret(RuleNode(2, [M.seq_node(ops)]), Dict{Symbol,Any}())
        stages = [
            M.walk(1),
            M.tunnel(5),
            [M.tunnel(5); M.wooden_pickaxe_chain()],
            M.IRON_PICKAXE_PLAN,
            [M.IRON_PICKAXE_PLAN; M.walk(1); M.tunnel(1)],
        ]
        rewards = [M.reward(run(ops), world) for ops in stages]
        @test issorted(rewards)
        @test first(rewards) == 0.0
        @test last(rewards) == 1.0
    end

    @testset "budget bounds every program" begin
        # A `while_op` whose condition never goes false must still terminate.
        world = get_problem(M, "navigate_01_plain").spec[1].in[:_arg_1]
        forever = M.while_op(M.not_op(M.at_goal), M.turn_left)
        after = M.final_world(forever, world)
        @test after.budget == 0
        @test !M.objective_met(after)
    end

    @testset "alternative specifications" begin
        identifier = "navigate_01_plain"
        world = get_problem(M, identifier).spec[1].in[:_arg_1]
        program = M.program_function(M.reference_program(identifier))

        (observation, is_done, reward) = M.evaluate_trace(program, world)
        @test observation isa M.MineWorld
        @test is_done
        @test reward == 1.0

        @test M.trace_problem(identifier) isa Problem
        @test M.trace_problem(identifier).spec[1] isa Trace
        @test M.metric_problem(identifier) isa MetricProblem

        # A trace holds the world after every action, plus the starting one.
        frames = M.execution_frames(program, world)
        @test length(frames) == 9
        @test first(frames).pos == world.pos
        @test last(frames).pos == world.goal
    end

    @testset "visualising" begin
        identifier = "obtain_wooden_pickaxe"
        problem = get_problem(M, identifier)
        program = M.reference_program(identifier)

        svg = M.visualize(program, problem)
        @test startswith(svg, "<svg")
        @test occursin("polygon", svg)

        gif = M.visualize(program, problem; path = tempname() * ".gif", scale = 4)
        @test isfile(gif)
        @test read(gif, 6) == b"GIF89a"

        @test occursin('A', M.world_ascii(problem.spec[1].in[:_arg_1]))
    end
end
