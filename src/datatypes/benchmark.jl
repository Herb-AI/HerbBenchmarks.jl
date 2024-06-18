"""
    Benchmark
    
A wrapper struct containing all the a benchmark module and its ProblemGrammarPairs.
"""
struct Benchmark
    module_name::Module
    problem_grammar_pairs::Vector{ProblemGrammarPair}
end