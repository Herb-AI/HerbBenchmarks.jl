module dev

include("Herb.jl")

using Revise

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

header = ["Grammar", "count", "max program size", "Elapsed Time (s)", "Memory Allocated (MB)", "GC Time (s)", "GC Time (%)", "Constraint Propagations", "Local Constraint Propagations"]
formatter = (v, i, j) -> 
    if j == 1
        return @sprintf("%s", v)
    elseif j == 2 || j == 8 || j == 9
        return @sprintf("%d", v)
    else
        return @sprintf("%.3f", v)
    end

function count_enumerator(enumerator):: Int
    count = 0
    for _ ∈ enumerator
        count += 1
    end
    return count
end

function time_enumerate(enumerator)
    return @timed count_enumerator(enumerator)
end


function run_enumeration(get_enumerator, add_constraints=false)
    max_sizes = [1, 3, 5, 7]
    results = Array{Any}(undef, length(header), length(tests) * length(max_sizes))
    i = 1
    for (g, description, _, constraints, root_type) ∈ tests
        grammar = deepcopy(g)
        if add_constraints 
            for c ∈ constraints addconstraint!(grammar, c) end        
        end

        for max_size ∈ max_sizes 
            enumerator = get_enumerator(grammar, typemax(Int), max_size, root_type) 
            timing = time_enumerate(enumerator)

            benchmarking_propagations_counter, benchmarking_propagations_counter_local = get_benchmarking_counters()
            results[:,i] = [description, timing.value, max_size, timing.time, timing.bytes/1e6, timing.gctime, timing.gctime/timing.time*100.0, benchmarking_propagations_counter, benchmarking_propagations_counter_local]
            benchmarking_propagations_counter = 0
            benchmarking_propagations_counter_local = 0
            i += 1
        end
    end
    
    results = permutedims(results)
    if print_latext_format
        pretty_table(results; backend = Val(:latex), header=header, formatters=formatter)    
    else
        pretty_table(results; header=header, formatters=formatter)
    end

    avg_time = sum(results[:,4]) / length(results[:,4])
    println("average elapsed time (s): $(round(avg_time, digits=3))")
    avg_mem = sum(results[:,5]) / length(results[:,5])
    println("average memory allocated (MB): $(round(avg_mem, digits=3))")
end

println("\nRunning enumeration tests - smallest domain, no constraints")
get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type, heuristic_smallest_domain)
run_enumeration(get_enumerator)

println("\nRunning enumeration tests - DFS, no constraints")
get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type)
run_enumeration(get_enumerator)

println("\nRunning enumeration tests - smallest domain, with constraints")
get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type, heuristic_smallest_domain)
run_enumeration(get_enumerator, true)

println("Running enumeration tests - DFS, with constraints")
get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type)
run_enumeration(get_enumerator, true)

end

# TODO:
# - count propagations