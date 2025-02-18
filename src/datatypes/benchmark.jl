"""
    Benchmark
    
A wrapper struct containing the benchmark module, its name, all or a selection of its ProblemGrammarPairs and the problem id filter used to filter problems.
"""
struct Benchmark
    mod::Module
    module_name::String
    problem_id_filter::Regex
    problem_grammar_pairs::Vector{ProblemGrammarPair}
end


"""
    Benchmark(mod::Module; problem_id_filter::Regex=r".*")

Returns a 'Benchmark' object containing the problems and their grammars of a specified benchmark module.
One can also specified a Regex filter to match certain problem ids, by default all problems are included (r".*").
Note a problem id, is the name of the variable without the "problem_" suffix.
"""
Benchmark(mod::Module; problem_id_filter::Regex=r".*") = Benchmark(
    mod,
    string(mod),
    problem_id_filter,
    get_problem_grammar_pairs(mod, problem_id_filter=problem_id_filter),
)