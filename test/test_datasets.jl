using HerbCore
using HerbSpecification
using Test

using HerbBenchmarks

@testset verbose=true "String transformations 2020" begin
    problems = all_problems(String_transformations_2020)
    @test typeof(problems[1]) <: HerbSpecification.Problem
    @test typeof(problems[1].spec[1]) == HerbSpecification.IOExample
end

