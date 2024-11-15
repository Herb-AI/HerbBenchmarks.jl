using HerbBenchmarks.PSB2_2021
using HerbGrammar

@testset verbose = true "PSB2_2021" begin
    @testset verbose = true "General tests" begin
        domains = get_all_identifiers(PSB2_2021)
        for dom in domains
            @testset verbose = true "Domain $(dom)" begin
                domain = replace(dom, "-" => "_")
                problem = get_problem(PSB2_2021, domain)
                grammar = get_grammar(PSB2_2021, domain)
                @test typeof(problem) <: HerbSpecification.Problem
                @test typeof(problem.spec[1]) == HerbSpecification.IOExample
                @test length(problem.spec) >= 10
            end
        end        
    end

    @testset verbose = true "Program examples" begin
        result_basement = program_basement(problem_basement.spec[1].in[:input1])
        expected_basement = problem_basement.spec[1].out
        @test result_basement == expected_basement

        result_coinsums = program_coin_sums(problem_coin_sums.spec[1].in[:input1])
        expected_coinsums = problem_coin_sums.spec[1].out
        @test result_coinsums == expected_coinsums

        result_fizzbuzz = program_fizzbuzz(problem_fizz_buzz.spec[1].in[:input1])
        expected_fizzbuzz = problem_fizz_buzz.spec[1].out
        @test result_fizzbuzz == expected_fizzbuzz

        result_fuelcost = program_fuel_cost(problem_fuel_cost.spec[1].in[:input1])
        expected_fuelcost = problem_fuel_cost.spec[1].out
        @test result_fuelcost == expected_fuelcost

        result_gcd1 = program_gcd(problem_gcd.spec[1].in[:input1], problem_gcd.spec[1].in[:input2])
        expected_gcd1 = problem_gcd.spec[1].out
        @test result_gcd1 == expected_gcd1

        result_gcd2 = program_gcd2(problem_gcd.spec[1].in[:input1], problem_gcd.spec[1].in[:input2])
        expected_gcd2 = problem_gcd.spec[1].out
        @test result_gcd2 == expected_gcd2
    end

    @testset verbose = true "Grammars" begin
        @testset verbose = true "Grammar primitives" begin
            @testset verbose = true "replace_in_string" begin
                test_string = "test101"
                check_string = "tesT101"
                result = replace_in_string(test_string, 4, 'T')
                @test result == check_string
            end

            @testset verbose = true "merge_grammar" begin
                test_g1 = @csgrammar begin
                    Rule = 1
                    Rule = Rule + Rule
                end
                test_g2 = @csgrammar begin
                    Rule = 2
                end
                test_g3 = @csgrammar begin 
                    Rule = 3
                end
                test_full_grammar = merge_grammar([test_g1, test_g2, test_g3])
                @test length(test_full_grammar.rules) == 4
                @test eval(rulenode2expr(RuleNode(2, [RuleNode(3), RuleNode(4)]), test_full_grammar)) == 5
            end

            @testset verbose = true "command_while" begin
                # TODO Idea use the SymbolTable
                @warn  "TODO test the command_while function using the correct scope"
            end
        end
        @testset verbose = true "Grammar boolean" begin
            @warn "Not yet implemented boolean grammar functionality tests"
        end
        @testset verbose = true "Grammar integer" begin
            @warn "Not yet implemented integer grammar functionality tests"
        end
        @testset verbose = true "Grammar state integer" begin
            @warn "Not yet implemented state integer grammar functionality tests"
        end
        @testset verbose = true "Grammar list integer" begin
            @warn "Not yet implemented list integer grammar functionality tests"
        end
        @testset verbose = true "Grammar float" begin
            @warn "Not yet implemented float grammar functionality tests"
        end
        @testset verbose = true "Grammar string" begin
            @warn "Not yet implemented string grammar functionality tests"
        end
        @testset verbose = true "Grammar char" begin
            @warn "Not yet implemented char grammar functionality tests"
        end
    end
end
