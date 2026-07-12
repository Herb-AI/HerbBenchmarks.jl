module Morpheus_2017
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("table_primitives.jl")
include("data.jl")
include("table_functions.jl")
include("base_grammar.jl")
include("grammars.jl")

function make_morpheus_interpreter(g)
    return make_interpreter(g; target_module=Morpheus_2017, cache_module=Morpheus_2017)
end

end # module Morpheus_2017
