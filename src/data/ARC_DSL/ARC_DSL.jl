module ARC_DSL

using HerbCore
using HerbSpecification
using HerbGrammar

include("arc_types.jl")

export Index, IntegerSet, Grid, Indices

include("arc_basic_primitives.jl")
include("arc_grid_operations.jl")
# include("data.jl")
include("grammar.jl")


end # module ARC_DSL