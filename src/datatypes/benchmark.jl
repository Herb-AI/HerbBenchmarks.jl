"""
    Benchmark
    
A wrapper struct containing the benchmark module, all or a selection of its ProblemGrammarPairs and the problem ids of them.
"""
struct Benchmark
    mod::Module
    module_name::String
    problem_ids::Union{Vector{String}, String}
    problem_grammar_pairs::Vector{ProblemGrammarPair}
end


"""
    Benchmark(mod::Module; selection_ids=nothing)

Returns a 'Benchmark' object containing the problems and their grammars of a specified benchmark module.
One can also specified a selection of problem ids, by default all problems are included.
Note a problem id, is the name of the variable without the "problem_" suffix.
"""
Benchmark(mod::Module; problem_ids::Union{Vector{String}, String}="all") = Benchmark(
    mod,
    string(mod),
    get_problem_ids(mod, problem_ids),
    [get_problem_grammar_pair(mod, identifier) for identifier in get_problem_ids(mod, problem_ids)],
)

"""
    get_problem_ids(mod::Module, problem_ids::Union{Vector{String}, Nothing})

A helper function returning either all problems, if problem_ids is nothing, or problem_ids it self.
"""
function get_problem_ids(mod::Module, problem_ids::Union{Vector{String}, String})
    return problem_ids == "all" ? get_all_identifiers(mod) : problem_ids
end