# Checks the generated files in Julia: for every (non-benched) problem, the solution's
# RuleNode round-trips to its expression in the problem's grammar, its size is right,
# and it reproduces every example's output with this module's own functions.
#
#   julia --project=<HerbBenchmarks> src/data/Neo_PLDI18/verify.jl
using HerbBenchmarks, HerbCore, HerbGrammar

const M = HerbBenchmarks.Neo_PLDI18

function check()
    ids = sort([string(n)[10:end] for n in names(M; all=true) if startswith(string(n), "solution_")])
    failures = String[]
    for id in ids
        sol = getfield(M, Symbol("solution_", id))
        g = getfield(M, Symbol("grammar_", id))
        p = getfield(M, Symbol("problem_", id))
        expr = rulenode2expr(sol.rulenode, g)
        expr == sol.expr || push!(failures, "$id: rulenode2expr gives $expr, expected $(sol.expr)")
        length(sol.rulenode) == sol.size || push!(failures, "$id: size $(length(sol.rulenode)) != $(sol.size)")
        for (i, ex) in enumerate(p.spec)
            bindings = [:($k = $(v isa AbstractVector ? Int[v...] : v)) for (k, v) in ex.in]
            got = try
                Core.eval(M, :(let $(bindings...); $(sol.expr) end))
            catch err
                err
            end
            got == ex.out || push!(failures, "$id: example $i gives $got, expected $(ex.out)")
        end
    end
    println("checked $(length(ids)) solutions, $(length(failures)) failures")
    foreach(println, failures)
    return isempty(failures)
end

check() || exit(1)
