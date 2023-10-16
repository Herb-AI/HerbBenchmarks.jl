using HerbCore
using HerbData
using Test

using HerbBenchmarks

@testset verbose=true "String transformations 2020" begin
    problem = String_transformations_2020.train_problem
    @test typeof(problem) == HerbData.Problem
    @test typeof(problem.examples[1]) == HerbData.IOExample

    problem = String_transformations_2020.test_problem
    @test typeof(problem) == HerbData.Problem
    @test typeof(problem.examples[1]) == HerbData.IOExample
end

