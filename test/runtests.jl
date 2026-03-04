using ReTestItems
using HerbBenchmarks

@testitem "HerbBenchmarks.jl" begin
    using HerbCore
    using HerbBenchmarks
    using HerbSpecification
    using Test
    using Documenter
    @testset doctest(HerbBenchmarks, manual=false)
    include("test_general.jl")
    include("test_string_transformations_2020.jl")
    include("test_robots_2020.jl")
    include("test_pixels_2020.jl")
    include("test_abstract_reasoning_2019.jl")
    include("test_problem_fetcher.jl")
    include("test_sexpression_parsing.jl")
end
