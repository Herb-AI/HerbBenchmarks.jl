module ARC_Hodel

using HerbCore
using HerbSpecification
using HerbGrammar
using Herb.HerbInterpret
using JSON


include("arc_basic_primitives.jl")
include("arc_grid_operations.jl")
include("arc_index_operations.jl")
include("arc_something.jl")
include("interpret.jl") # TODO: rename interpret function to avoid clashes

end # module ARC_Hodel

