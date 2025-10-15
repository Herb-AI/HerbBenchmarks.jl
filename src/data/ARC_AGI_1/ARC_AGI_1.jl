module ARC_AGI_1

using HerbCore
using HerbSpecification
using HerbGrammar

using JSON

include("ARC_Hodel/ARC_Hodel.jl")
include("ARC_Tilman/ARC_Tilman.jl")

include("training_data.jl")
include("evaluation_data.jl")
include("grammar.jl")

export
    parse_ARC_data_file
# Grid

"""
    parseline_strings(line::AbstractString)::IOExample

Parses a line from a file in the `strings` dataset
"""
function parse_ARC_data_file(filename::AbstractString)::Problem
    j = JSON.Parser.parsefile(filename)
    examples::Vector{Example} = Vector{Example}()

    for part ∈ ["train", "test"]
        for (i, o) in zip(j[part][1]["input"], j[part][1]["output"])
            example = IOExample(Dict(:_arg_1 => i), o)
            push!(examples, example)
        end
    end

    return Problem(examples)
end

end # module ARC_AGI_1
