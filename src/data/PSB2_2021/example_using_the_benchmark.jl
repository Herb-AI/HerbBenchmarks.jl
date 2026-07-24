## An example of how to use the PSB2 benchmark.
#
# Run this from an environment that has HerbBenchmarks, HerbSearch,
# HerbConstraints, HerbGrammar and HerbSpecification.

using HerbBenchmarks
using HerbBenchmarks.PSB2_2021
using HerbGrammar, HerbSpecification, HerbSearch
import HerbConstraints: freeze_state

# A problem is a set of IOExamples, its grammar is the search space, and the
# interpreter evaluates programs of that grammar. Every problem of the
# benchmark has all three.
problem = get_problem(PSB2_2021, "fizz_buzz")
grammar = get_grammar(PSB2_2021, "fizz_buzz")
interpret = get_interpreter("fizz_buzz")

println("Grammar of fizz_buzz:\n", grammar)

# The example solution of a problem is a RuleNode of its grammar; the
# interpreter maps it and an input to an output.
println("Example solution: ", rulenode2expr(PSB2_2021.solution_fizz_buzz, grammar))
println("Its outputs: ", interpret(PSB2_2021.solution_fizz_buzz, problem.spec[1:5]))
println("On a new input: ", interpret(PSB2_2021.solution_fizz_buzz, Dict{Symbol,Any}(:_arg_1 => 15)))

# Searching that grammar with a breadth first search. `minimal=true` gives the
# small grammar with only the instructions the example solution uses; the full
# grammar is a much bigger search space.
grammar = PSB2_2021.get_grammar_fizz_buzz(minimal=true)
interpret = make_psb2_interpreter(grammar)

function search(grammar, interpret, problem; budget=5000)
    best, best_score = nothing, -1
    for (i, candidate) in enumerate(BFSIterator(grammar, :Return, max_depth=4))
        i > budget && break
        program = freeze_state(candidate)
        # Programs of the PSB2 grammars are total: evaluating one never throws,
        # so no error handling is needed here.
        score = count(example -> interpret(program, example.in) == example.out, problem.spec)
        if score > best_score
            best, best_score = program, score
        end
        best_score == length(problem.spec) && break
    end
    return best, best_score
end

best, best_score = search(grammar, interpret, problem)

println("Best program found: ", rulenode2expr(best, grammar))
println("It solves $(best_score) of the $(length(problem.spec)) examples.")

# The bigger versions of the problems are not kept in this repository; they can
# be downloaded with (this needs the `psb2` python package):
#
#   write_psb2_problems_to_file(["fizz-buzz"], "random", 200, 2000, "psb2")
