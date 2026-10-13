#!/usr/bin/env julia
#
# Compare two benchmark runs produced by benchmark/run.jl.
#
#     julia --project=benchmark benchmark/compare.jl before.json after.json
#
# Prints, per benchmark and depth, the change in median per-program time and in
# throughput. Negative "median" and positive "speed-up" mean the second run is
# faster.

using JSON
using Printf

length(ARGS) == 2 || error("usage: compare.jl <before.json> <after.json>")
before = JSON.parsefile(ARGS[1])
after = JSON.parsefile(ARGS[2])

index(run) = Dict(t["name"] => t for t in run["targets"])
depth_index(target) = Dict(d["depth"] => d for d in target["depths"])

println("# ", get(before, "label", "before"), "  ->  ", get(after, "label", "after"))

b_targets, a_targets = index(before), index(after)
for name in sort(collect(keys(a_targets)))
    haskey(b_targets, name) || continue
    println("\n### ", name)
    println("| depth | before us | after us | change | before progs/s | after progs/s | speed-up |")
    println("|---|---|---|---|---|---|---|")
    bd, ad = depth_index(b_targets[name]), depth_index(a_targets[name])
    for depth in sort(collect(keys(ad)))
        haskey(bd, depth) || continue
        bs, as = get(bd[depth], "stats", nothing), get(ad[depth], "stats", nothing)
        (bs === nothing || as === nothing) && continue
        bm, am = bs["median_us"], as["median_us"]
        bp, ap = bs["programs_per_s"], as["programs_per_s"]
        @printf("| %d | %.2f | %.2f | %+.1f%% | %.0f | %.0f | %.2fx |\n",
            depth, bm, am, 100 * (am - bm) / bm, bp, ap, ap / bp)
    end
end
