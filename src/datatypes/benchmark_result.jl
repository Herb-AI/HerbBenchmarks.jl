using Statistics

"""
    BenchmarkResult

A struct containg the results of a Benchmark evaluation. It contains the benchmark/module, ProblemResult per problem and some statistics.
The statistics include at least the average amount of programs evaluated (also only for optimally solved instances), the average execution time (s) (also only for optimally solved instances), the average memory usage (bytes) (also only for optimally solved instances) and a Dict mapping a TerminationCause to the amount of problems that were terminated due to that cause.
"""
struct BenchmarkResult
    benchmark_name::String
    problem_id_filter::Regex
    problem_results::Vector{ProblemResult}
    statistics::Dict{String,Any}
end

"""
    BenchmarkResult(benchmark_name::Module, problem_results::Vector{ProblemResult})

A constructor for BenchmarkResult that automatically computes the statistics.
"""
BenchmarkResult(benchmark::Benchmark, problem_results::Vector{ProblemResult}) = BenchmarkResult(
    benchmark.module_name,
    benchmark.problem_id_filter,
    problem_results,
    compute_statistics(problem_results),
)

"""
    compute_statistics(problem_results::Vector{ProblemResult})::Dict{String,Any}

A helper function that computes the BenchmarkResult statistics given a Vector of ProblemResults.
Returns a Dict mapping a statistic identifier to it's corresponding value.
A lot of these values come in the form (mean, standard deviation).
"""
function compute_statistics(problem_results::Vector{ProblemResult})::Dict{String,Any}
    Dict(
        "average_programs_evaluated" => compute_average_and_mean(problem_results, "programs_evaluated", false),
        "average_programs_evaluated_only_optimal_programs" => compute_average_and_mean(problem_results, "programs_evaluated", true),
        "average_execution_time_s" => compute_average_and_mean(problem_results, "execution_time_s", false),
        "average_execution_time_s_only_optimal_programs" => compute_average_and_mean(problem_results, "execution_time_s", true),
        "average_memory_usage_bytes" => compute_average_and_mean(problem_results, "memory_usage_bytes", false),
        "average_memory_usage_bytes_only_optimal_programs" => compute_average_and_mean(problem_results, "memory_usage_bytes", true),
        "termination_causes" => compute_termination_causes(problem_results)
    )
end

"""
    compute_average_and_mean(problem_results, key, only_optimal)::Tuple{Number, Number}

A helper function that computes the mean and standard deviation of a specified metric for a given Vector of ProblemResults.
There is the option to only include instances for which an optimal program was found.
Returns a Tuple containg the mean and standard deviation.
"""
function compute_average_and_mean(problem_results, key, only_optimal)::Tuple{Number, Number}
    if only_optimal
        values = [p.metrics[key] for p in problem_results if p.optimal_program == optimal_program]
    else
        values = [p.metrics[key] for p in problem_results]
    end

    return mean(values), std(values)
end

"""
    compute_termination_causes(problem_results::Vector{ProblemResult})::Dict{TerminationCause, Number}
    
A helper function compute how many times each TerminationCause has occured.
Returns a Dict mapping each TerminationCause to its amount of occurences.
"""
function compute_termination_causes(problem_results::Vector{ProblemResult})::Dict{TerminationCause, Number}
    dict = Dict(
        optimal_program_found => 0,
        max_enumerations_reached => 0,
        max_time_reached => 0,
        enumeration_exhausted => 0,
    )

    for problem_result in problem_results
        dict[problem_result.metrics["termination_cause"]] += 1
    end

    return dict
end