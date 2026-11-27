# Checks the generated files in Julia: for every (non-benched) problem, the solution's
# RuleNode round-trips to its expression in the problem's grammar, its size is right, and
# its output, computed with this module's functions (by evaluating the expression and with
# the generated interpreter), has the same contents as the expected table (`same_table`).
#
#   julia --project=<HerbBenchmarks> src/data/Morpheus_Neo_PLDI18/verify.jl
using HerbBenchmarks, HerbCore, HerbGrammar

const M = HerbBenchmarks.Morpheus_Neo_PLDI18

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
        interpret = M.make_morpheus_interpreter(g)
        for (i, ex) in enumerate(p.spec)
            bindings = [:($k = $v) for (k, v) in ex.in]
            for (how, run) in [("expression", () -> Core.eval(M, :(let $(bindings...); $(sol.expr) end))),
                               ("interpreter", () -> interpret(sol.rulenode, ex.in))]
                got = try
                    run()
                catch err
                    err
                end
                M.same_table(got, ex.out) || push!(failures, "$id: example $i, $how gives\n$got\nexpected\n$(ex.out)")
            end
        end
    end
    println("checked $(length(ids)) solutions, $(length(failures)) failures")
    foreach(println, failures)
    return isempty(failures)
end

check() || exit(1)
