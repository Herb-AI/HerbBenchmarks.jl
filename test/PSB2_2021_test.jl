@testitem "PSB2 2021" begin
    import HerbCore: @rulenode, RuleNode
    import HerbBenchmarks.PSB2_2021: grammar_fizz_buzz, problem_fizz_buzz, program_fizzbuzz, interpret_fizzbuzz

    @testset "PSB2_2021" begin
        @testset "Testing fizzbuzz program" begin
            @test interpret_fizzbuzz(program_fizzbuzz, 5) == "Fizz"
        end
    end
end
