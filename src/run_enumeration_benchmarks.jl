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

header = ["Grammar", "max program size", "Elapsed Time (s)", "Memory Allocated (MB)", "GC Time (s)", "GC Time (%)"]
formatter = (v, i, j) -> 
    if j == 1
        return @sprintf("%s", v)
    elseif j == 2
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


function run_enumeration(get_enumerator, add_constraints=nothing)
    max_sizes = [1, 3, 5, 7]
    results = Array{Any}(undef, length(header), length(tests) * length(max_sizes))
    i = 1
    for (index, (g, description, _, root_type)) ∈ enumerate(tests)
        grammar = deepcopy(g)
        if !isnothing(add_constraints) add_constraints(grammar, index) end
        for max_size ∈ max_sizes 
            enumerator = get_enumerator(grammar, typemax(Int), max_size, root_type) 
            timing = time_enumerate(enumerator)
            results[:,i] = [description, max_size, timing.time, timing.bytes/1e6, timing.gctime, timing.gctime/timing.time*100.0]
            i += 1
        end
    end
    
    results = permutedims(results)
    pretty_table(results; header=header, formatters=formatter)    
end

function add_constraints(grammar, index) 
    if index == 1 
        addconstraint!(grammar, Forbidden(MatchNode(1, [MatchVar(:x), MatchVar(:y)]))) # forbid x + y
        addconstraint!(grammar, Forbidden(MatchNode(2, [MatchVar(:y), MatchVar(:z)]))) # forbid y - z
        addconstraint!(grammar, Forbidden(MatchNode(3, [MatchVar(:x), MatchVar(:z)]))) # forbid x * z
    end
end

# println("Running enumeration tests with heuristic_smallest_domain")
# get_enumerator_with_heuristic_smallest_domain(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type, heuristic_smallest_domain)
# run_enumeration(get_enumerator_with_heuristic_smallest_domain)

println("Running enumeration tests without heuristic_smallest_domain")
get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type)
run_enumeration(get_enumerator)

# println("Running enumeration tests with forbidden constraints")
# get_enumerator(grammar, max_depth, max_size, root_type) = get_bfs_enumerator(grammar, max_depth, max_size, root_type)
# run_enumeration(get_enumerator, add_contraints)

end