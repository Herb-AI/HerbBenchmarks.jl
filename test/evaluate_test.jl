@testitem "Usage example 1" begin
    using HerbBenchmarks, HerbSearch, DataFrames

    module DummyBenchmark
        using HerbSpecification, HerbGrammar

        p = (n, exs) -> Problem(n, [IOExample(Dict{Symbol, Any}(:_arg_1 => first(ex)), last(ex)) for ex in exs])

        problem_1 = p("y = x", [(0, 0), (1, 1), (2, 2)])
        grammar_1 = @cfgrammar begin 
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
            Num = 1 | 2
            Num = Num / Num
            Num = _arg_1 
        end
    end
    
    # Single problem
    d1 = benchmark(BFSIterator, problem=DummyBenchmark.problem_1, grammar=DummyBenchmark.grammar_1, params=(starting_symbol=:Num, max_enumerations=100))

    # Benchmark
    d2 = benchmark(BFSIterator, benchmark=DummyBenchmark, params=(starting_symbol=:Num, max_enumerations=100))
    d3 = benchmark(DFSIterator, benchmark=DummyBenchmark, params=(starting_symbol=:Num, max_enumerations=100, max_depth=5))
    problems_solved_over_time([d2, d3])

    # Custom labels
    d4 = benchmark(DFSIterator, benchmark=DummyBenchmark, params=(starting_symbol=:Num, max_depth=2, max_enumerations=100,))
    d5 = benchmark(DFSIterator, benchmark=DummyBenchmark, params=(starting_symbol=:Num, max_depth=5, max_enumerations=100,))
    problems_solved_over_time([d4, d5], label=r->"Max depth $(r.params.max_depth)")

    #= 
    
    Each data frame contains:
        - iterator: type of iterator
        - params:   user-defined parameters
        - results:  result dataframe with rows of:
            - problem_name
            - solved
            - solution
            - program_enumerated
            - execution_time_sec
            - allocated_bytes 

    =#
end