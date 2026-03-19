module ARC_AGI_2

using HerbCore
using HerbSpecification
using HerbGrammar

include("data.jl")
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

"""
    all_problems()

Return all public ARC-AGI-2 problems.
"""
all_problems() = ARC_AGI2_ALL


export 
    training_problems
    evaluation_problems
    all_problems

end # module ARC_AGI_2