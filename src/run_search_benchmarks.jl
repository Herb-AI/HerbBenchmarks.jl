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

print_latext_format = false
println("Do you want to print in latex format? y/n")
s = readline()
print_latext_format = lowercase(s) == "y" || lowercase(s) == "yes"

header = ["Origial Program", "Resulting Program", "Elapsed Time (s)", "Memory Allocated (MB)", "GC Time (s)", "GC Time (%)", "Constraint Propagations", "Local Constraint Propagations"]
formatter = (v, i, j) -> 
    if j <= 2
        return @sprintf("%s", v)
    elseif j == 7 || j == 8
        return @sprintf("%d", v)
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

        # println("Original program: $original_expr\t| Number of IOExamples: $(length(ioexamples))\t| Resulting program: $result")

        benchmarking_propagations_counter, benchmarking_propagations_counter_local = get_benchmarking_counters()
        results[:,i] = [string(original_expr), string(result), timing.time, timing.bytes/1e6, timing.gctime, timing.gctime/timing.time*100.0, benchmarking_propagations_counter, benchmarking_propagations_counter_local]
        benchmarking_propagations_counter = 0
        benchmarking_propagations_counter_local = 0
        i += 1
    end

    return permutedims(results)
end

# println("Running search tests with heuristic_smallest_domain")

# for (grammar, grammar_description, example, root_type) ∈ tests
#     get_enumerator(grammar, max_depth, max_size, start_symbol) = get_bfs_enumerator(grammar, max_depth, max_size, start_symbol, heuristic_smallest_domain)
#     results = time_search(grammar, example, root_type, get_enumerator)

#     # Print the results using PrettyTables
#     pretty_table(results; header=header, formatters=formatter)
# end

println("Running search tests without heuristic_smallest_domain")

for (grammar, description, example, _, root_type) ∈ tests
    println("\n$description")
    get_enumerator(grammar, max_depth, max_size, start_symbol) = get_bfs_enumerator(grammar, max_depth, max_size, start_symbol)
    results = time_search(grammar, example, root_type, get_enumerator)

    avg_time = sum(results[:,4]) / length(results[:,4])
    println("average elapsed time (s): $(round(avg_time, digits=3))")
    avg_mem = sum(results[:,5]) / length(results[:,5])
    println("average memory allocated (MB): $(round(avg_mem, digits=3))")

    # Print the results using PrettyTables
    if print_latext_format
        pretty_table(results; backend = Val(:latex), header=header, formatters=formatter)    
    else
        pretty_table(results; header=header, formatters=formatter)
    end
end


end