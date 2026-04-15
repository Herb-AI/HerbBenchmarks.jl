module ARC_AGI2

using HerbCore
using HerbSpecification
using HerbGrammar

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("training_data.jl")
include("evaluation_data.jl")
# include("grammar.jl")

"""
    training_problems()

Return the ARC-AGI-2 public training problems.
"""
training_problems() = ARC_AGI2_TRAINING

"""
    evaluation_problems()

Return the ARC-AGI-2 public evaluation problems.
"""
evaluation_problems() = ARC_AGI2_EVALUATION

const ARC_AGI2_ALL = vcat(ARC_AGI2_TRAINING, ARC_AGI2_EVALUATION)

"""
    all_problems()

Return all public ARC-AGI-2 problems.
"""
all_problems() = ARC_AGI2_ALL

function problem_key(p)
    return Symbol(p.name)
end

function train_examples(p)
    s = ARC_AGI2_TRAINING_SPLITS[problem_key(p)]
    return p.spec[1:s.train]
end

function test_examples(p)
    s = ARC_AGI2_TRAINING_SPLITS[problem_key(p)]
    return p.spec[s.train+1 : s.train+s.test]
end

end # module ARC_AGI2