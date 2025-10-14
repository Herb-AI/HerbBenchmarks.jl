using HerbCore
using HerbBenchmarks
using HerbSpecification
using HerbGrammar
using Test

@testset "HerbBenchmarks.jl" verbose = true begin
    # include("test_general.jl") # fails for ARC_Hodel => test assumes one grammar per example
    include("test_string_transformations_2020.jl")
    include("test_robots_2020.jl")
    include("test_pixels_2020.jl")
    include("test_problem_fetcher.jl")
    include("Abstract_Reasoning_2019/test_arc_dsl.jl")
end
