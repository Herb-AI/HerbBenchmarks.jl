module Tensors_2022

using HerbCore
using HerbSpecification
using HerbGrammar

using Flux, SparseArrays, StatsBase, Statistics

include("data.jl")
include("grammars.jl")
include("tensor_functions.jl")
include("targets.jl")

end