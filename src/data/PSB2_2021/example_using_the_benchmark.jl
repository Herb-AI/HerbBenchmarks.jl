# Set the imports
using Pkg
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret", "HerbSearch"])
using HerbGrammar, HerbSpecification, HerbInterpret, HerbSearch

include("data.jl")
include("grammar.jl")
include("program_examples.jl")

# Define an iterator to use with the correct grammar and starting symbol. 
# Optionally you can define a max_depth
grammar = get_grammar_basement(minimal=true, seed=42)
iterator = BFSIterator(grammar, :Return, max_depth=4)

# Synthesize the program for the given problem. Evaluation errors must be allowed for some problems to not fail on trying to divide by 0 for example
program, result = @time synth(problem_basement, iterator, allow_evaluation_errors = true)
# program = result[1]

# Note: this might take quite some time as a BFSIterator is not very good on its own.
println("Result ", result)
println("Found program rulenode: ", program)
println("Found program: ", HerbGrammar.rulenode2expr(program, grammar))

# Now, we can evaluate a program
input1 = [5,2,3,92]
println("Found program outputs: ", eval(HerbGrammar.rulenode2expr(program, grammar)))
println("Provided example program outputs: ", program_basement(input1))