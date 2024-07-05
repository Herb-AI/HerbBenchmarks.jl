"""
    BENCHMARK_RESULT_PATH = "/benchmarks"

The relative path where the ProblemResults per Benchmark are stored.
"""
BENCHMARK_RESULT_PATH = "/benchmarks"

"""
    ENVIRONMENT_PATH = "/environment.txt"

The relative file path where environment variables of an evaluation are stored.
"""
ENVIRONMENT_PATH = "/environment.txt"

"""
    STATISTICS_PATH = "/statistics.txt"

The relative file path where statistics per benchmark are stored.
"""
STATISTICS_PATH = "/statistics.txt"


"""
    setup_storage(path::String)

A helper function that sets up the result folder at a specified `path`.
"""
function setup_storage(path::String)
    # Check if the path is free, otherwise throw an exception
    if isdir(path)
        throw(ArgumentError("The folder \"$path\" already exsist"))
    end

    # Create folders
    mkpath(path)
    mkpath(path * BENCHMARK_RESULT_PATH)
end

"""
    store_environment(path::String, evaluation_result::EvaluationResult)

A helper function that stores the environment variables of a given `evaluation_result` in the result folder at a given `path`.
"""
function store_environment(path::String, evaluation_result::EvaluationResult)
    final_path = path * ENVIRONMENT_PATH

    open(final_path, "a") do io
        println(io, evaluation_result.environment)
    end
end

"""
    store_problem_result(path::String, benchmark_module::Module, problem_result::ProblemResult)

A helper function that stores a `problem_result` of a `benchmark_module` in the result folder at a given `path`.
"""
function store_problem_result(path::String, benchmark_module::Module, problem_result::ProblemResult)
    benchmark_name = lowercase(string(benchmark_module))
    benchmark_name_safe = replace(benchmark_name, "." => "_")
    final_path = path * BENCHMARK_RESULT_PATH * "/" * benchmark_name_safe * ".txt"
 
    open(final_path, "a") do io
        println(io, problem_result)
    end
end

"""
    store_benchmark_statistics(path::String, benchmark_result::BenchmarkResult)

A helper function that stores statistics of a `benchmark_result` in the result folder at a given `path`.
"""
function store_benchmark_statistics(path::String, benchmark_result::BenchmarkResult)
    final_path = path * STATISTICS_PATH
    lines = join([
        benchmark_result.benchmark_name * ": ", 
        "\t Problem id filter: " * string(benchmark_result.problem_id_filter),
        "\t Statistics:  " * string(benchmark_result.statistics),
    ], "\n") * "\n"

    open(final_path, "a") do io
        println(io, lines)
    end
end