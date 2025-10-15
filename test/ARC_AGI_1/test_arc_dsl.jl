@testset "Benchmark ARC-DSL" verbose = true begin
    include("ARC_Hodel/test_arc_basic_primitives.jl")
    include("ARC_Hodel/test_arc_grid_operations.jl")
    include("ARC_Hodel/test_arc_index_operations.jl")
    include("ARC_Hodel/test_arc_interpret.jl")
    include("ARC_Tilman/test_abstract_reasoning_2019.jl")
end