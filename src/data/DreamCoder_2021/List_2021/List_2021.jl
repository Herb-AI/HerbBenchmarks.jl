"""
    List_2021

DreamCoder's list-processing domain (Ellis et al., 2021): 217 tasks over lists
of integers, each specified by 15 input/output examples. See
`src/data/DreamCoder_2021/README.md` for the domain overview.
"""
module List_2021
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("list_primitives.jl")
include("data.jl")
include("grammars.jl")

"""
    make_list_interpreter(g::AbstractGrammar)

Build an interpreter for a list-domain grammar. Grammars differ per problem
(the input rule sits at a different nonterminal), so the interpreter is built
per grammar rather than once for the module.
"""
make_list_interpreter(g::AbstractGrammar) =
    make_interpreter(g; target_module=List_2021, cache_module=List_2021)

end # module List_2021
