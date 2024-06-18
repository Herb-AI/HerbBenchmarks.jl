"""
    EvaluationResult
    
A struct containg the BenchmarkResults for one or more Benchmark evaluations and every environment or run details to reproduce the evaluation.
Note the latter are not currently implemented.
"""
struct EvaluationResult
    benchmark_results::Vector{BenchmarkResult}
    environment::Dict{String, Any}
end

"""
    EvaluationResult(benchmark_results::Vector{BenchmarkResult})
    
A constructor for the EvaluationResult struct that creates the environment variables automatically.
Note environment variables are not implemented yet.
"""
EvaluationResult(benchmark_results::Vector{BenchmarkResult}) = EvaluationResult(
    benchmark_results,
    Dict(
        # TODO: someway to include all iterator settings
        # TODO: random random_seed
        # TODO: environment
    )
)