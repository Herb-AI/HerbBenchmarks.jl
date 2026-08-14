"""
    Text_2021

DreamCoder's text-editing domain (Ellis et al., 2021): 128 automatically
generated string-transformation tasks — replace a delimiter, abbreviate a
name, take the n-th word, parenthesise a word — each specified by four
input/output examples. See `src/data/DreamCoder_2021/README.md` for the domain
overview.

`PROBLEM_NAMES` maps an identifier to DreamCoder's own description of the
task, which is worth consulting: several tasks differ only in which delimiter
they use, and identifiers cannot carry punctuation.
"""
module Text_2021
using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("text_primitives.jl")
include("data.jl")
include("metadata.jl")
include("grammars.jl")

"""
    make_text_interpreter(g::AbstractGrammar)

Build an interpreter for a text grammar. Grammars differ per problem (arity
and string constants vary), so the interpreter is built per grammar rather
than once for the module.
"""
make_text_interpreter(g::AbstractGrammar) =
    make_interpreter(g; target_module=Text_2021, cache_module=Text_2021)

end # module Text_2021
