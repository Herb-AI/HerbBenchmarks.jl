# Set the imports
using Pkg
Pkg.activate(temp=true)
Pkg.add(["HerbGrammar", "HerbSpecification", "HerbInterpret", "HerbSearch"])
using HerbGrammar, HerbSpecification, HerbInterpret, HerbSearch

include("data.jl")
include("grammars.jl")

# Define an iterator to use with the correct grammar and starting symbol. Optionally you can define a max_depth
iterator = BFSIterator(minimal_grammar_fizz_buzz, :String, max_depth=5)

# Synthesize the program for the given problem. Evaluation errors must be allowed for some problems to not fail on trying to divide by 0 for example
program = @time synth(problem_fizz_buzz, iterator, allow_evaluation_errors = true)

# Note: this might take quite some time as a BFSIterator is not very good on its own.

println("program: ", program)