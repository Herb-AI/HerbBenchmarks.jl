using HerbCore
using HerbBenchmarks
using HerbSpecification
using Test

@testset "HerbBenchmarks.jl" verbose=true begin
    include("test_problem_fetcher.jl")
end
