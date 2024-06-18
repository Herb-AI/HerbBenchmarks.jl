"""
    ProblemGrammarPair

A wrapper struct that contains a problem, its corresponding grammar, the benchmark/module of origin and its identifier.
"""
struct ProblemGrammarPair
    benchmark_name::Module
    identifier::String
    problem::Problem
    grammar::AbstractGrammar
end