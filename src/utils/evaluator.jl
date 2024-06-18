"""
    function evaluate(iterator_constructor::Function, benchmarks::Vector{Benchmark}; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

Evaluates an ProgramIterator on a given Vector of Benchmarks.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmarks              - A vector containing the Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
Returns an EvaluationResult containg the results of every Benchmark, their problem results and environment variables to reproduce the evaluation.
"""
function evaluate(
    iterator_constructor::Function, 
    benchmarks::Vector{Benchmark};
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int)
)::EvaluationResult

    # Evauate each benchmark and store results in a vector.
    benchmark_results = [evaluate_benchmark(
        iterator_constructor, 
        benchmark, 
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations) for benchmark in benchmarks]

    # Return the result, wrapped in the corresponding structure.
    return EvaluationResult(benchmark_results)
end

"""
    function evaluate(iterator_constructor::Function, benchmark::Benchmark; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

Evaluates an ProgramIterator on a given Benchmark.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmark               - The Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
Returns an EvaluationResult containg the results of the Benchmark, their problem results and environment variables to reproduce the evaluation.
"""
function evaluate(
    iterator_constructor::Function, 
    benchmark::Benchmark;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int)
)::EvaluationResult

    # Evauate the benchmark and store result in a vector.
    benchmark_result = evaluate_benchmark(
        iterator_constructor, 
        benchmark, 
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations
    )

    # Return the result, wrapped in the corresponding structure.
    return EvaluationResult([benchmark_result])
end

"""
    function evaluate(iterator_constructor::Function, problem_grammar_pair::ProblemGrammarPair; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

A helper function that evaluates an ProgramIterator on a given ProblemGrammarPair.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmark               - The Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
Returns a ProblemResult containg the results of the evaluation.
"""
function evaluate_problem(
    iterator_constructor::Function, 
    problem_grammar_pair::ProblemGrammarPair;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int)
)::ProblemResult
   
    # Construct program iterator
    iterator = iterator_constructor(problem_grammar_pair.grammar, :Start)

    # Run synth function and return
    return HerbBenchmarks.synth(
        problem_grammar_pair,
        iterator, 
        benchmark=problem_grammar_pair.benchmark_name,
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations
    )
end


"""
    function evaluate(iterator_constructor::Function, benchmark::Benchmark; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

A helper function that evaluates an ProgramIterator on a given Benchmark.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmark               - The Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
Returns a BenchmarkResult containg the results of the evaluation.
"""
function evaluate_benchmark(
    iterator_constructor::Function, 
    benchmark::Benchmark;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int)
)::BenchmarkResult

    # Evaluate each problem
    problem_results = [evaluate_problem(
        iterator_constructor, 
        pg, 
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations) for pg in benchmark.problem_grammar_pairs]
    
    # Return the result
    return BenchmarkResult(
        benchmark.module_name,
        problem_results
    )
end