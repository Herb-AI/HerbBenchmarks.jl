module ARC_AGI1

using HerbCore
using HerbSpecification
using HerbGrammar
using HerbInterpret
using StatsBase

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

using JSON

include("arc_primitives.jl")
include("arc_visualize.jl")
include("training_data.jl")
include("evaluation_data.jl")
include("grammar.jl")

interpret = make_interpreter(grammar_hodel; target_module=ARC_AGI1, cache_module=ARC_AGI1)

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


"""
    training_problems()

Return the ARC-AGI-1 public training problems.
"""
training_problems() = ARC_AGI1_TRAINING

"""
    evaluation_problems()

Return the ARC-AGI-1 public evaluation problems.
"""
evaluation_problems() = ARC_AGI1_EVALUATION

const ARC_AGI1_ALL = vcat(ARC_AGI1_TRAINING, ARC_AGI1_EVALUATION)

"""
    all_problems()

Return all public ARC-AGI-1 problems.
"""
all_problems() = ARC_AGI1_ALL

function problem_key(p)
    return Symbol(p.name)
end

function train_examples(p)
    s = ARC_AGI1_TRAINING_SPLITS[problem_key(p)]
    return p.spec[1:s.train]
end

function test_examples(p)
    s = ARC_AGI1_TRAINING_SPLITS[problem_key(p)]
    return p.spec[s.train+1 : s.train+s.test]
end

end # module ARC_AGI1
