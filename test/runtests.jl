using HerbCore
using HerbSpecification
using Test

@testset "HerbBenchmarks.jl" verbose = true begin
    include("test_string_transformations_2020.jl")
    include("test_robots_2020.jl")
    include("test_pixels_2020.jl")
end
