using HerbBenchmarks.ARC_DSL

@testset "Benchmark ARC-DSL" verbose = true begin
    include("test_arc_utils.jl")
    include("test_arc_basic_primitives.jl")
    include("test_arc_grid_operations.jl")
    include("test_arc_index_operations.jl")
    include("test_arc_grid_operations_interpret.jl")
end