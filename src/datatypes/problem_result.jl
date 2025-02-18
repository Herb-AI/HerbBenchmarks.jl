"""
    ProblemResult

A struct containg the result of the synthesis of a program for a certain problem. It conatins the problem's identifier, the program (if found), whether this program is optimal and metric about the search.
The metric include at least the amount of programs evaluated, execution time (s), memory usage (bytes) and the cause of termination.
Note the benchmark/module or origin is contained within a BenchmarkResult in which this struct appears.
"""
struct ProblemResult
    problem_identifier::String
    program::Union{RuleNode, Nothing}
    optimal_program::SynthResult
    metrics::Dict{String, Any}
end