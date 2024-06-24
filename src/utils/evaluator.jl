"""
    function evaluate_iterator(iterator_constructor::Function, benchmarks::Vector{Benchmark}; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

Evaluates an ProgramIterator on a given Vector of Benchmarks.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmarks              - A vector containing the Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
        - path                    - The location at which the result folder should be created. Throws an ArgumentError if that folder already exists.
Returns an EvaluationResult containg the results of every Benchmark, their problem results and environment variables to reproduce the evaluation.
"""
function evaluate_iterator(
    iterator_constructor::Function, 
    benchmarks::Vector{Benchmark};
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int),
    path::Union{Nothing, String} = nothing,
)::EvaluationResult

    # Create empty EvaluationResult
    result = EvaluationResult()

    # If a path is specified, initalise storage and store the environment variables
    if !isnothing(path)
        setup_storage(path)
        store_environment(path, result)
    end

    # Evauate each benchmark and append the results.
    for benchmark in benchmarks
        benchmark_result = evaluate_benchmark(
            iterator_constructor, 
            benchmark, 
            shortcircuit=shortcircuit, 
            allow_evaluation_errors=allow_evaluation_errors, 
            max_time=max_time, 
            max_enumerations=max_enumerations,
            path=path)

        push!(result.benchmark_results, benchmark_result)
    end

    # Return the result, wrapped in the corresponding structure.
    return result
end

"""
    function evaluate_iterator(iterator_constructor::Function, benchmark::Benchmark; shortcircuit::Bool=true, allow_evaluation_errors::Bool=false, max_time::Int64 = typemax(Int), max_enumerations::Int64 = typemax(Int))::EvaluationResult

Evaluates an ProgramIterator on a given Benchmark.
        - iterator_constructor    - A function constructing a iterator::ProgramIterator from an grammar::AbstractGrammar and a starting_symbol::Symbol
        - benchmark               - The Benchmarks to be evaluated
        - shortcircuit            - Whether to stop evaluating after finding a single example that fails, to speed up the [synth](@ref) procedure. If true, the returned score is an underapproximation of the actual score.
        - allow_evaluation_errors - Whether the search should crash if an exception is thrown in the evaluation
        - max_time                - The maximum time before termination of a single program search 
        - max_enumerations        - The maximum amount of enumerations before termination of a single program search
        - path                    - The location at which the result folder should be created. Throws an ArgumentError if that folder already exists.
Returns an EvaluationResult containg the results of the Benchmark, their problem results and environment variables to reproduce the evaluation.
"""
function evaluate_iterator(
    iterator_constructor::Function, 
    benchmark::Benchmark;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int),
    path::Union{Nothing, String} = nothing,
)::EvaluationResult

    # Call the evaluate for a vector of Benchmarks.
    return evaluate(
        iterator_constructor, 
        [benchmark], 
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations,
        path=path
    )
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
        - path                    - The location at which the result folder is located.
Returns a ProblemResult containg the results of the evaluation.
"""
function evaluate_problem(
    iterator_constructor::Function, 
    problem_grammar_pair::ProblemGrammarPair;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int),
    path::Union{Nothing, String} = nothing,
)::ProblemResult
   
    # Construct program iterator
    iterator = iterator_constructor(problem_grammar_pair.grammar, :Start)

    # Create Synth object
    synth = HerbBenchmarks.Synth(
        problem_grammar_pair,
        iterator, 
        problem_grammar_pair.benchmark_module,
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations
    )

    # Run synthesis
    result = synthesize(synth)

    # Store result if a path was specified
    if !isnothing(path)
        store_problem_result(path, problem_grammar_pair.benchmark_module, result)
    end

    return result
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
        - path                    - The location at which the result folder is located.
Returns a BenchmarkResult containg the results of the evaluation.
"""
function evaluate_benchmark(
    iterator_constructor::Function, 
    benchmark::Benchmark;
    shortcircuit::Bool=true, 
    allow_evaluation_errors::Bool=false,
    max_time::Int64 = typemax(Int),
    max_enumerations::Int64 = typemax(Int),
    path::Union{Nothing, String} = nothing,
)::BenchmarkResult

    # Evaluate each problem
    problem_results = [evaluate_problem(
        iterator_constructor, 
        pg, 
        shortcircuit=shortcircuit, 
        allow_evaluation_errors=allow_evaluation_errors, 
        max_time=max_time, 
        max_enumerations=max_enumerations,
        path=path) for pg in benchmark.problem_grammar_pairs]
    
    result = BenchmarkResult(
        benchmark,
        problem_results
    )

    # If a path was specified, store the benchmark statistics
    store_benchmark_statistics(path, result)

    # Return the result
    return result
end