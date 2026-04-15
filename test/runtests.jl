using HerbCore
using HerbBenchmarks
using HerbSpecification
using HerbGrammar
using Test

@testset "HerbBenchmarks.jl" verbose = true begin
    include("test_general.jl")
    include("test_string_transformations_2020.jl")
    include("test_robots_2020.jl")
    include("test_pixels_2020.jl")
    include("test_problem_fetcher.jl")
    include("test_arc_agi_1.jl")
end
