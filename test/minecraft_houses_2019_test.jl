@testitem "Minecraft_Houses_2019" begin
    import HerbBenchmarks: Minecraft_Houses_2019, get_all_identifiers, get_problem,
        get_grammar, get_default_grammar, get_all_problem_grammar_pairs
    import HerbCore: RuleNode
    import HerbSpecification: IOExample, Problem, MetricProblem, Trace
    const MH = Minecraft_Houses_2019

    @testset "problems are well formed" begin
        identifiers = get_all_identifiers(MH)
        @test length(identifiers) == 40
        for pair in get_all_problem_grammar_pairs(MH)
            problem = pair.problem
            @test problem isa Problem
            @test length(problem.spec) == 1
            @test problem.spec[1] isa IOExample
            @test problem.spec[1].in[:_arg_1] isa MH.HouseState
            @test problem.spec[1].out isa Dict{NTuple{3,Int},Int}
            @test !isempty(problem.spec[1].out)
        end
    end

    @testset "per-house grammars offer exactly that house's blocks" begin
        for identifier in get_all_identifiers(MH)
            grammar = get_grammar(MH, identifier)
            offered = Set(grammar.rules[i] for i in eachindex(grammar.rules)
                          if grammar.types[i] === :Block)
            used = Set(values(MH.HOUSE_TARGETS[identifier]))
            @test offered == used
        end
        # `grammar_builder` sorts before every `grammar_house_*`, which is what
        # makes it the default rather than house 1's grammar.
        @test get_default_grammar(MH) === MH.grammar_builder
    end

    @testset "houses are normalised to the origin" begin
        for identifier in get_all_identifiers(MH)
            cells = keys(MH.HOUSE_TARGETS[identifier])
            for axis in 1:3
                @test minimum(cell[axis] for cell in cells) == 0
            end
        end
    end

    @testset "reference programs rebuild their house exactly" begin
        for identifier in get_all_identifiers(MH)
            problem = get_problem(MH, identifier)
            built = MH.interpret(MH.reference_program(identifier), problem.spec[1],
                get_grammar(MH, identifier))
            @test built == problem.spec[1].out
        end
    end

    @testset "compact solutions rebuild their house, much smaller" begin
        for (identifier, _) in MH.COMPACT_SOLUTIONS
            compact = MH.compact_program(identifier)
            grammar = get_grammar(MH, identifier)
            built = MH.interpret(compact, Dict{Symbol,Any}(:_arg_1 => MH.HouseState()), grammar)
            @test built == MH.HOUSE_TARGETS[identifier]
            # The point of shipping these is the gap they demonstrate.
            @test length(compact) < length(MH.reference_program(identifier)) / 2
        end
        @test_throws KeyError MH.compact_program("house_0002")
    end

    @testset "an interpreter is bound to its grammar" begin
        # Two houses whose grammars disagree on what a Block rule index means.
        # Interpreting one house's program under the other's grammar must not
        # quietly succeed with the wrong materials.
        blocks_of(id) = sort!(unique(values(MH.HOUSE_TARGETS[id])))
        identifiers = get_all_identifiers(MH)
        pairs = ((a, b) for a in identifiers, b in identifiers
                 if a != b && length(blocks_of(a)) == length(blocks_of(b)) &&
                    blocks_of(a) != blocks_of(b))
        differing = iterate(pairs)

        if differing !== nothing
            (a, b) = first(differing)
            target = MH.HOUSE_TARGETS[a]
            wrong = MH.interpret(MH.reference_program(a),
                Dict{Symbol,Any}(:_arg_1 => MH.HouseState()), MH.HOUSE_GRAMMARS[b])
            @test wrong != target
            # ... and the cells are right even though the materials are not,
            # which is exactly the bug a shared interpreter would introduce.
            @test keys(wrong) == keys(target)
        end
    end

    @testset "bulk shapes" begin
        state = MH.HouseState()
        shell = MH.seq(MH.select(5), MH.box_shell(2, 2, 2))
        canvas = MH.build_house(shell, state)
        # A 3x3x3 shell is 27 cells minus the single interior one.
        @test length(canvas) == 26
        @test !haskey(canvas, (1, 1, 1))
        @test all(block == 5 for block in values(canvas))

        solid = MH.build_house(MH.seq(MH.select(5), MH.fill_box(2, 2, 2)), MH.HouseState())
        @test length(solid) == 27

        # A box flat in one axis is a floor or a roof, which is why `Extent`
        # admits zero where `Offset` does not.
        slab = MH.build_house(MH.seq(MH.select(5), MH.fill_box(3, 0, 3)), MH.HouseState())
        @test length(slab) == 16
        @test all(cell[2] == 0 for cell in keys(slab))
        grammar = MH.grammar_builder
        @test MH.rule_index(grammar, :Extent, 0) > 0
        @test_throws ErrorException MH.rule_index(grammar, :Offset, 0)

        # `embed` restores the cursor, so two embedded excursions stack.
        program = MH.seq(MH.select(1),
            MH.seq(MH.embed(MH.fill_x(3)), MH.embed(MH.fill_z(3))))
        canvas = MH.build_house(program, MH.HouseState())
        @test length(canvas) == 7
        @test haskey(canvas, (3, 0, 0)) && haskey(canvas, (0, 0, 3))

        # Air is not a block: placing without selecting writes nothing.
        @test isempty(MH.build_house(MH.place, MH.HouseState()))
    end

    @testset "scoring" begin
        target = Dict((0, 0, 0) => 5, (1, 0, 0) => 5)
        @test MH.voxel_f1(target, target) == 1.0
        @test MH.voxel_iou(target, target) == 1.0
        @test MH.voxel_f1(Dict{NTuple{3,Int},Int}(), target) == 0.0
        # Right cells, wrong material scores zero -- block type is part of the
        # answer, not decoration.
        @test MH.voxel_f1(Dict((0, 0, 0) => 1, (1, 0, 0) => 1), target) == 0.0
        # Half the house scores between the two.
        half = MH.voxel_f1(Dict((0, 0, 0) => 5), target)
        @test 0.0 < half < 1.0
    end

    @testset "alternative specifications" begin
        identifier = "house_0001"
        program = MH.reference_program(identifier)

        (built, is_done, reward) = MH.evaluate_trace(program, identifier)
        @test is_done
        @test reward == 1.0
        @test built == MH.HOUSE_TARGETS[identifier]

        order = MH.build_order(identifier)
        @test order isa Trace
        @test isempty(first(order.exec_path))
        @test last(order.exec_path) == MH.HOUSE_TARGETS[identifier]
        @test length(order.exec_path) == length(MH.HOUSE_TRACES[identifier]) + 1

        @test MH.trace_problem(identifier) isa Problem
        @test MH.metric_problem(identifier) isa MetricProblem
        @test MH.build(identifier) == MH.HOUSE_TARGETS[identifier]
    end

    @testset "visualising" begin
        identifier = "house_0001"
        program = MH.reference_program(identifier)

        svg = MH.visualize(identifier)
        @test startswith(svg, "<svg")

        gif = MH.visualize(program, identifier; path = tempname() * ".gif", scale = 4)
        @test isfile(gif)
        @test read(gif, 6) == b"GIF89a"

        # `compare` paints a missing block, so a partial build differs from the
        # target's own rendering.
        partial = Dict(first(MH.HOUSE_TARGETS[identifier]))
        @test MH.compare(partial, identifier) != MH.visualize(identifier)

        # A plan uses one letter per block type, and the legend names them.
        plan = MH.house_ascii(MH.HOUSE_TARGETS["house_0030"]; y = 0)
        @test occursin('a', plan) && occursin('.', plan)
        @test MH.house_legend(MH.HOUSE_TARGETS["house_0030"]) == "a = oak planks, b = glass"
    end
end
