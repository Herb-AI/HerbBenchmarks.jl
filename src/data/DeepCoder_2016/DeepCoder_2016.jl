module DeepCoder_2016

using HerbCore
using HerbSpecification
using HerbGrammar

using JSON

include("deepcoder_primitives.jl")
include("data.jl")
include("grammar.jl")

export 
    parse_deepcoder_problem


"""
    parse_deepcoder_problem(filename::AbstractString)::Problem
    Parses a DeepCoder problem from a file.
"""
function parse_deepcoder_problem(filename::AbstractString)::Problem
    raw = JSON.Parser.parsefile(filename)
    examples::Vector{IOExample} = Vector{IOExample}()

    for ex ∈ raw["examples"]
        input = Dict{Symbol, Any}(:_arg_1 => ex["input"])
        output = ex["output"]
        push!(examples, IOExample(input, output))
    end

    # Extract numeric ID from filename and pad it to 3 digits
    number = match(r"\d+", raw["name"])
    if number === nothing
        error("Could not extract problem number from filename: $filename")
    end
    problem_name = "problem_" * lpad(number.match, 3, '0')

    return Problem(problem_name, examples)
end

end # module DeepCoder_2016
