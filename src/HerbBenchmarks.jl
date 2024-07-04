module HerbBenchmarks

using HerbCore
using HerbSpecification
using HerbGrammar

include("export_module.jl")

# Iterate over directories in `/data/` and include all available files
for (root, dirs, files) in walkdir(dirname(@__FILE__)*"/data/")
    for f in files
        # Check if module name starts with capital letter (formerly also <year>.jl)
        # if occursin(r"^[A-Z].*\d{4}\.jl$", f)
        if occursin(r"^[A-Z].*\.jl$", f)
            include(joinpath(root, f))
            @eval @make_public $(Symbol(f[1:(findfirst('.', f)-1)]))
        end
    end
end

# Include utils
#include("utils/benchmark_generator.jl")
include("utils/benchmarks_io.jl")
include("utils/problem_fetcher.jl")

# Include data types
include("datatypes/problem_grammar_pair.jl")
include("datatypes/benchmark.jl")

export 
    # Data types
    ProblemGrammarPair,
    Benchmark,

    # utils
    parse_file,
    write_problem,
    parse_to_julia,
    append_cfgrammar,
    enumerate_problem_files,
    
    # Problem fetcher
    get_all_benchmarks,
    get_benchmark,
    get_all_problem_grammar_pairs,
    get_all_identifiers,
    get_problem_grammar_pair,
    get_problem,
    get_grammar,
    get_default_grammar,

    make_public,
    make_public_rec
end # module HerbBenchmarks
