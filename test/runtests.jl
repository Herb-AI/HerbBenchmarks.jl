using HerbCore
using HerbBenchmarks
using HerbBenchmarks.ARC_DSL
using HerbSpecification
using Test


@testset "HerbBenchmarks.jl" verbose = true begin
    # include("test_general.jl")
    # include("test_string_transformations_2020.jl")
    # include("test_robots_2020.jl")
    # include("test_pixels_2020.jl")
    # include("test_abstract_reasoning_2019.jl")
    # include("test_problem_fetcher.jl")
    include("test_arc_utils.jl")
    # include("test_arc_basic_primitives.jl")
    # include("test_arc_grid_operations.jl")
    # include("test_arc_index_operations.jl")
end
