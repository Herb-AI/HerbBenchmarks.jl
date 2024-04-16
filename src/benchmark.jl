abstract type AbstractBenchmark end

struct Benchmark <: AbstractBenchmark
    name::String
    problems::AbstractVector{Tuple{AbstractGrammar, Problem}}
end