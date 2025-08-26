module ARC_DSL

using HerbCore
using HerbSpecification
using HerbGrammar
using JSON

# export Index, IntegerSet, Grid, Indices

include("arc_basic_primitives.jl")
include("arc_grid_operations.jl")
include("arc_index_operations.jl")
include("data.jl")
include("grammar.jl")
include("arc_interpreter.jl")

export
    parse_ARC_example

"""
        parse_ARC_example(filename::AbstractString, dir::AbstractString = ".")

    Parses an example from the ARC dataset from a given JSON filename and an optional directory path into a `HerbSpecification.Problem`.
    Splits the example into training and test problems.
"""
function parse_ARC_example(filename::AbstractString, dir::AbstractString=".")
    filepath = joinpath(dir, filename)
    j = JSON.Parser.parsefile(filepath)
    train_examples = Vector{IOExample}()
    test_examples = Vector{IOExample}()

    # parse input and output to grid
    for example in j["train"]
        input = permutedims(hcat(example["input"]...))
        output = permutedims(hcat(example["output"]...))
        push!(train_examples, IOExample(Dict(:_arg_1 => input), output))
    end
    for example in j["test"]
        input = permutedims(hcat(example["input"]...))
        output = permutedims(hcat(example["output"]...))
        push!(test_examples, IOExample(Dict(:_arg_1 => input), output))
    end
    return Problem(train_examples), Problem(test_examples)
end

end # module ARC_DSL