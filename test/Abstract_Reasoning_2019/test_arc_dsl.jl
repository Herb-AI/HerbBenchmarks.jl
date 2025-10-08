@testset "Benchmark ARC-DSL" verbose = true begin
    include("ARC_Hodel/test_arc_basic_primitives.jl")
    include("ARC_Hodel/test_arc_grid_operations.jl")
    include("ARC_Hodel/test_arc_index_operations.jl")
    # include("test_arc_interpret.jl")
end