module Karel_2018

using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret
using NPZ

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("karel_primitives.jl")
include("data.jl")
include("grammar.jl")

interpret = make_stateful_interpreter(grammar_karel; target_module=Karel_2018, cache_module=Karel_2018)

export
    parseline_karel

function parseline_karel(line::AbstractString)::IOExample
    # TODO: Main call parsing
    input = Dict(:_arg_1 => "")
    output = ""
    return IOExample(input, output)
end

end # module Karel_2018