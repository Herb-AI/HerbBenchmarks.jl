@testsetup module TestEvaluate
    using HerbCore, HerbBenchmarks, HerbGrammar, HerbSearch, HerbSpecification, HerbConstraints
    export grammar, interpreter, to_io_example, iterator, synthesizer, synthesizer_dfs

    grammar = @cfgrammar begin
        Int = 1 | 2
        Int = Int + Int
        Int = Int * Int
        Int = x
    end

    interpreter = (program, input) -> begin
        r = get_rule(program)
        cs = [interpreter(c, input) for c in get_children(program)]

            if r == 1 return 1
        elseif r == 2 return 2
        elseif r == 3 return cs[1] + cs[2]
        elseif r == 4 return cs[1] * cs[2]
        elseif r == 5 return input[:x]
        end
    end

    function synthesizer(problem::Problem)
        programs_enumerated = 0
        solution = nothing

        for program in BFSIterator(grammar, :Int)
            programs_enumerated += 1

            # Success: all I/O examples solved
            all(interpreter(program, io.in) == io.out for io in problem.spec) && (solution = freeze_state(program); break)

            # Failure: max enumerations reached
            programs_enumerated >= 1000 && break
        end

        (
            :problem_name => problem.name,
            :examples => problem.spec,
            :solved => !isnothing(solution),
            :solution => solution,
            :programs_enumerated => programs_enumerated,
        )
    end

    function synthesizer_dfs(problem::Problem)
        programs_enumerated = 0
        solution = nothing

        for program in DFSIterator(grammar, :Int, max_depth=5)
            programs_enumerated += 1

            # Success: all I/O examples solved
            all(interpreter(program, io.in) == io.out for io in problem.spec) && (solution = freeze_state(program); break)

            # Failure: max enumerations reached
            programs_enumerated >= 1000 && break
        end

        (
            :problem_name => problem.name,
            :examples => problem.spec,
            :solved => !isnothing(solution),
            :solution => solution,
            :programs_enumerated => programs_enumerated,
        )
    end

    function synthesizer(problems::Tuple{Problem, Problem})
        programs_enumerated = 0
        solution = nothing

        for program in BFSIterator(grammar, :Int)
            programs_enumerated += 1

            # Success: all I/O examples solved
            all(interpreter(program, io.in) == io.out for io in first(problems).spec) && (solution = freeze_state(program); break)

            programs_enumerated >= 1000 && break
        end

        (
            :problem_name => first(problems).name,
            :examples => first(problems).spec,
            :training_examples => last(problems).spec,
            :solved => !isnothing(solution),
            :solution => solution,
            :test_examples_solved => isnothing(solution) ? 0 : count(interpreter(solution, io.in) == io.out for io in last(problems).spec),
            :programs_enumerated => programs_enumerated,
        )
    end

    to_io_example = ex -> IOExample(Dict(:x => first(ex)), last(ex))
end

@testitem "Evaluate single problem" setup=[TestEvaluate] begin
    using HerbCore, HerbBenchmarks, HerbGrammar, HerbSearch, HerbSpecification, HerbConstraints

    examples = [(0, 0), (1, 3), (2, 8), (3, 15)]
    problem = Problem("x^2 + 2x", to_io_example.(examples))

    d = evaluate_synthesizer(synthesizer, [problem])

    @test d[1, :problem_name] == "x^2 + 2x"
    @test d[1, :solved] == true
    @test d[1, :programs_enumerated] isa Number
    @test d[1, :execution_time_sec] isa Number
    @test d[1, :allocated_bytes] isa Number
end

@testitem "Evaluate single problem with test problem" setup=[TestEvaluate] begin
    using HerbCore, HerbBenchmarks, HerbGrammar, HerbSearch, HerbSpecification

    examples = [(0, 0), (1, 3), (2, 8), (3, 15)]
    problem = Problem("x^2 + 2x", to_io_example.(examples))

    test_examples = [examples..., (4, 24), (5, 35)]
    test_problem = Problem("x^2 + 2x", to_io_example.(test_examples))

    d = evaluate_synthesizer(synthesizer, [(problem, test_problem)])

    @test d[1, :problem_name] == "x^2 + 2x"
    @test d[1, :solved] == true
    @test d[1, :solution] isa RuleNode
    @test d[1, :test_examples_solved] == 6
    @test d[1, :programs_enumerated] isa Number
    @test d[1, :execution_time_sec] isa Number
    @test d[1, :allocated_bytes] isa Number
end

@testitem "Evaluate problem set" setup=[TestEvaluate] begin
    using HerbCore, HerbBenchmarks, HerbGrammar, HerbSearch, HerbSpecification, HerbConstraints
    using DataFrames
    using Random

    problems = [
        Problem("Problem $n", to_io_example.([(i, rand(1:5)) for i in 0:1]))
        for n in 1:100
    ]

    data = DataFrame(
        :label => ["BFS", "DFS"],
        :results => [evaluate_synthesizer(synthesizer, problems), evaluate_synthesizer(synthesizer_dfs, problems)]
    )
end