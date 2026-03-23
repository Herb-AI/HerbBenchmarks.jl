@testitem "Usage example 1" begin
    using HerbBenchmarks, HerbSearch, DataFrames

    module DummyBenchmark
        using HerbSpecification, HerbGrammar

        p = (n, exs) -> Problem(n, [IOExample(Dict{Symbol, Any}(:_arg_1 => first(ex)), last(ex)) for ex in exs])

        problem_1 = p("y = x", [(0, 0), (1, 1), (2, 2)])
        grammar_1 = @cfgrammar begin
            Start = Num
            Num = 1 | 2
            Num = -Num 
            Num = Num + Num 
            Num = Num * Num 
            Num = _arg_1 
        end

        problem_2 = p("y = 2 * x", [(0, 0), (1, 2), (2, 4)])
        grammar_2 = grammar_1

        problem_3 = p("y = 2 - x", [(0, 2), (1, 1), (2, 0)])
        grammar_3 = grammar_1

        problem_4 = p("y = x / 2", [(0.0, 0.0), (1.0, 0.5), (2.0, 1.0)])
        grammar_4 = @cfgrammar begin 
            Start = Num
            Num = 1 | 2
            Num = Num / Num
            Num = _arg_1 
        end
    end

    b = DummyBenchmark
    
    # Single problem
    d1 = @benchmark BFSIterator params=(max_enumerations=100,) problem=b.problem_1 grammar=b.grammar_1

    # Benchmark
    d2 = @benchmark [BFSIterator, DFSIterator] params=(max_enumerations=100, max_depth=5) benchmark=b
    problems_solved_over_time(d2)

    # Custom labels
    d3 = @benchmark [DFSIterator, DFSIterator] specific_params=[(max_depth=5,), (max_depth=2,)] params=(max_enumerations=100,) benchmark=b
    problems_solved_over_time(d3, label=r->"Max depth $(r.params[:max_depth])")
end