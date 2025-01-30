using HerbCore
using HerbBenchmarks
using HerbSpecification
using Test

@testset "HerbBenchmarks.jl" verbose = true begin
	include("test_general.jl")
	include("test_string_transformations_2020.jl")
	include("test_robots_2020.jl")
	include("test_pixels_2020.jl")
	include("test_abstract_reasoning_2019.jl")
	include("test_problem_fetcher.jl")
end
