input_rules(grammar::AbstractGrammar) = findall(rule -> occursin("_arg_", string(rule)), grammar.rules)

@testset verbose=true "General tests on all submodules" begin
    modules = get_submodules(HerbBenchmarks)
        for mod in modules
        @testset verbose=true "Module $mod" begin
            problems = get_all_problems(mod)
            if length(problems) == 0 
                continue
            end
            @testset verbose=true "Inputs are well-typed" begin
                @test typeof(problems[1]) <: HerbSpecification.Problem
                @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample
            end

            if mod ∉ [HerbBenchmarks.String_transformations_2020,
                      HerbBenchmarks.Pixels_2020,
                      HerbBenchmarks.Robots_2020,
                      HerbBenchmarks.PSB2_2021]

                @testset verbose=true "Inputs align in grammar and problem" begin
                    pairs = get_all_problem_grammar_pairs(mod)
                    for pair in pairs
                        p,g = pair.problem, pair.grammar
                        p_args = length(p.spec[1].in)
                        g_args = length(input_rules(g))
                        # test whether 
                        @test p_args == g_args
                    end            
                end
            end
        end
    end
end

