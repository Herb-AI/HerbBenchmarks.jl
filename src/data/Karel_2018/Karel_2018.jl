module Karel_2018

using HerbCore
using HerbSpecification
using HerbGrammar
using NPZ

include("primitives.jl")
include("data.jl")
include("grammar.jl")
include("grammar_utils.jl")

export
    parseline_karel

function parseline_karel(line::AbstractString)::IOExample
    # TODO: Main call parsing
    input = Dict(:_arg_1 => "")
    output = ""
    return IOExample(input, output)
end

end # module Karel_2018