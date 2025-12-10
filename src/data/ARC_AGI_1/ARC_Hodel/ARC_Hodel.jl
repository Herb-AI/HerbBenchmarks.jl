module ARC_Hodel

using HerbCore
using HerbSpecification
using HerbGrammar
using Herb.HerbInterpret
using JSON
using StatsBase


include("basic_primitives.jl")
include("grid_primitives.jl")
include("core_primitives.jl")
include("utils_primitives.jl")
include("interpret.jl") # TODO: rename interpret function to avoid clashes

end # module ARC_Hodel
