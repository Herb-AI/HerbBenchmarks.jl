module dev

include("Herb.jl")

using .Herb
using Revise

using .Herb.HerbConstraints
using .Herb.HerbGrammar
using .Herb.HerbSearch
using .Herb.HerbData
using .Herb.HerbEvaluation

using Serialization
using PrettyTables
using Printf

tests = try
    tests = open(deserialize, "tests.bin")
catch e
    println("generate the tests first (tests.bin)")
end

header = ["Origial Program", "Resulting Program", "Elapsed Time (s)", "Memory Allocated (MB)", "GC Time (s)", "GC Time (%)"]
formatter = (v, i, j) -> 
    if j <= 2
        return @sprintf("%s", v)
    else
        return @sprintf("%.3f", v)
    end

function time_search(grammar, examples, root_type, enumerator=enumerator)
    results = Array{Any}(undef, length(header), length(examples))
    i = 1

    for (original_program, ioexamples) in examples
        problem = Problem(ioexamples, "")

        timing = @timed search(grammar, problem, root_type, max_depth=typemax(Int), max_size=typemax(Int), enumerator=enumerator)
        result = timing.value
        original_expr = rulenode2expr(original_program, grammar)

        println("Original program: $original_expr\t| Number of IOExamples: $(length(ioexamples))\t| Resulting program: $result")

        results[:,i] = [string(original_expr), string(result), timing.time, timing.bytes/1e6, timing.gctime, timing.gctime/timing.time*100.0]
        i += 1
    end

    return permutedims(results)
end

println("Running tests with heuristic_smallest_domain")

for (grammar, example, root_type) ∈ tests
    get_enumerator(grammar, max_depth, max_size, start_symbol) = get_bfs_enumerator(grammar, max_depth, max_size, start_symbol, heuristic_smallest_domain)
    results = time_search(grammar, example, root_type, get_enumerator)

    # Print the results using PrettyTables
    pretty_table(results; header=header, formatters=formatter)
end

println("Running tests without heuristic_smallest_domain")

for (grammar, example, root_type) ∈ tests
    get_enumerator(grammar, max_depth, max_size, start_symbol) = get_bfs_enumerator(grammar, max_depth, max_size, start_symbol)
    results = time_search(grammar, example, root_type, get_enumerator)
    # Print the results using PrettyTables
    pretty_table(results; header=header, formatters=formatter)
end


end