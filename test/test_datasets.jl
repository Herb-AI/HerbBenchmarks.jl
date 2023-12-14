using HerbCore
using HerbData
using Test

using HerbBenchmarks

@testset verbose=true "String transformations 2020" begin
    problem = String_transformations_2020.all_problems
    @test typeof(problem[1]) == HerbData.Problem
    @test typeof(problem[1].examples[1]) == HerbData.IOExample
end

