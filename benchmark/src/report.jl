# Turning `TargetResult`s into tables, and into JSON for later comparison.

"""
Names of the benchmarks whose grammar needs [`stateful_expr`](@ref) to become
runnable at all, i.e. where `rulenode2expr`'s own output (`moveRight()`, zero
arguments) is not directly usable by `eval` or `HerbInterpret.interpret`.
"""
const STATEFUL_NAMES = ("Robots_2020", "Pixels_2020", "String_transformations_2020")

"""
    all_times_ns(result::DepthResult) -> Vector{UInt64}

Per-program wall times from every repetition, pooled.
"""
all_times_ns(d::DepthResult) =
    isempty(d.passes) ? UInt64[] : reduce(vcat, (p.times_ns for p in d.passes))

total_ns(passes::Vector{PassStats}) = sum(Int128(p.total_ns) for p in passes; init = Int128(0))

"""
    cell_stats(result::DepthResult, n_examples::Int) -> NamedTuple

Derived statistics for one (benchmark, depth) cell:

- `median_us`, `mean_us`, `p95_us`, `max_us`: per-program wall time,
- `programs_per_s`: program evaluations per second (one program = `n_examples`
  input evaluations),
- `evals_per_s`: program-example pairs per second,
- `ns_per_node`: time per `RuleNode` per example, the size-normalised cost,
- `kib_per_program`: bytes allocated per program evaluation,
- `gc_fraction`: share of the measured time spent in GC,
- `rep_spread`: relative spread of the per-repetition totals, a noise indicator,
- `error_rate`: share of sampled candidates that raised,
- `loop_rate`: share of timed programs that contain a bounded loop,
- `loopfree` / `loop`: program count, mean time and share of the measured time,
  split by whether the program contains a bounded loop. This is where the gap
  between `median_us` and `mean_us` comes from: most loops exit immediately, a
  few run their 1000-iteration bound and cost four orders of magnitude more.
- `v1_median_us`: "custom v1" (the pre-optimization interpreter, see
  `BenchTarget.v1_interpret`) median per-program time, over the exact same
  `programs` as `median_us` -- so `v1_speedup = v1_median_us / median_us` is a
  direct, same-subset comparison, unlike the three-way table below.
"""
function cell_stats(d::DepthResult, n_examples::Int)
    times = all_times_ns(d)
    isempty(times) && return nothing
    total = total_ns(d.passes)
    reps = length(d.passes)
    nodes = sum(d.node_counts)
    rep_totals = [Float64(p.total_ns) for p in d.passes]
    v1_median_us = _pass_median_us(d.v1_passes)
    median_us = median(times) / 1e3
    return (
        median_us = median_us,
        mean_us = mean(times) / 1e3,
        p95_us = quantile(Float64.(times), 0.95) / 1e3,
        max_us = maximum(times) / 1e3,
        programs_per_s = (d.n_programs * reps) / (Float64(total) / 1e9),
        evals_per_s = (d.n_programs * reps * n_examples) / (Float64(total) / 1e9),
        ns_per_node = Float64(total) / (nodes * reps * n_examples),
        kib_per_program = sum(p.allocd_bytes for p in d.passes) / (d.n_programs * reps * 1024),
        gc_fraction = sum(p.gc_ns for p in d.passes) / Float64(total),
        rep_spread = reps > 1 ? (maximum(rep_totals) - minimum(rep_totals)) / minimum(rep_totals) : 0.0,
        error_rate = d.n_candidates == 0 ? 0.0 : d.n_errored / d.n_candidates,
        nodes_mean = mean(d.node_counts),
        nodes_max = maximum(d.node_counts),
        loop_rate = isempty(d.has_loop) ? 0.0 : count(d.has_loop) / length(d.has_loop),
        loopfree = _subset_stats(d, .!d.has_loop, total),
        loop = _subset_stats(d, d.has_loop, total),
        v1_median_us = v1_median_us,
        v1_speedup = v1_median_us === nothing ? nothing : v1_median_us / median_us,
    )
end

"""
    _subset_stats(result, mask, total_ns) -> Union{Nothing,NamedTuple}

Count, mean time and share of the measured time for the programs selected by
`mask`, pooled across repetitions.
"""
function _subset_stats(d::DepthResult, mask::AbstractVector{Bool}, total::Int128)
    any(mask) || return nothing
    pooled = Float64[]
    for pass in d.passes
        append!(pooled, Float64.(pass.times_ns[mask]))
    end
    return (
        n = count(mask),
        mean_us = mean(pooled) / 1e3,
        median_us = median(pooled) / 1e3,
        time_share = sum(pooled) / Float64(total),
    )
end

"""
    _pass_median_us(passes) -> Union{Nothing,Float64}

Median per-program time across every repetition in `passes`, in microseconds.
"""
function _pass_median_us(passes::Vector{PassStats})
    isempty(passes) && return nothing
    times = reduce(vcat, (p.times_ns for p in passes))
    isempty(times) && return nothing
    return median(times) / 1e3
end

"""
    _times_median_us(times) -> Union{Nothing,Float64}
"""
_times_median_us(times::Vector{UInt64}) = isempty(times) ? nothing : median(times) / 1e3

"""
    comparison_stats(result, n_examples) -> Union{Nothing,NamedTuple}

The three-way comparison for one (benchmark, depth) cell, all computed over the
same `cmp_n_programs`-sized subset (see [`DepthResult`](@ref)):

- `eval_us`: `rulenode2expr` (+ `stateful_expr` for stateful grammars) run
  through literal `Core.eval` -- real Julia semantics, full compiler latency
  every call.
- `interpret_us`: the same expression run through `HerbInterpret.interpret`,
  over `interpret_n`/`interpret_n_supported` programs: for the stateful
  benchmarks this excludes programs containing a `WHILE`, which that generic
  interpreter cannot run (no `:while` case).
- `custom_us` / `custom_us_supported`: the custom interpreter's own median,
  sliced from the *same* run as the main sweep (not re-measured) -- over the
  full `cmp_n_programs` subset, and over just the `interpret`-supported subset,
  respectively, so each baseline is compared against a matching denominator.
- `v1_us`: "custom v1" (the pre-optimization interpreter, see
  `BenchTarget.v1_interpret`), sliced the same way as `custom_us` -- over the
  full `cmp_n_programs` subset, so it is directly comparable to `eval_us` and
  `custom_us`. Unlike `interpret_us` it has no supported-subset restriction.
"""
function comparison_stats(d::DepthResult, n_examples::Int)
    d.cmp_n_programs == 0 && return nothing
    return (
        n = d.cmp_n_programs,
        eval_us = _pass_median_us(d.eval_passes),
        v1_us = _times_median_us(d.cmp_v1_times_ns),
        custom_us = _times_median_us(d.cmp_custom_times_ns),
        interpret_n = d.interpret_n_supported,
        interpret_us = _pass_median_us(d.interpret_passes),
        custom_us_supported = _times_median_us(d.cmp_custom_supported_times_ns),
    )
end

const HEADER = ("depth", "progs", "nodes", "median us", "mean us", "p95 us",
    "progs/s", "evals/s", "ns/node", "KiB/prog", "GC%", "rep±", "err%", "loop%",
    "v1 us", "v1 speed-up")

function print_target(io::IO, r::TargetResult)
    println(io)
    println(io, "### ", r.name)
    println(io)
    println(io, "grammar `", r.grammar_id, "` (", r.n_grammar_rules, " rules), ",
        r.n_examples, " examples/program")
    println(io)
    if isempty(r.cold_seconds)
        println(io, "- one interpreter is generated at module load and shared by all problems")
    else
        println(io, @sprintf(
            "- cold interpreter (generate one for an unseen grammar + run its first program): %.1f ms median over %d problems, range %.1f-%.1f ms",
            1e3 * median(r.cold_seconds), length(r.cold_seconds),
            1e3 * minimum(r.cold_seconds), 1e3 * maximum(r.cold_seconds)))
    end
    r.needs_copy && println(io, "- inputs are deep-copied per evaluation (mutable state)")
    discarded = sum(d.n_oversized + d.n_slow for d in r.depths; init = 0)
    candidates = sum(d.n_candidates for d in r.depths; init = 0)
    discarded > 0 && println(io, @sprintf(
        "- discarded %d of %d candidates as oversized or pathologically slow (%.1f%%)",
        discarded, candidates, 100 * discarded / max(candidates, 1)))
    println(io)

    println(io, "| ", join(HEADER, " | "), " |")
    println(io, "|", repeat("---|", length(HEADER)))
    for d in r.depths
        if !d.reachable
            println(io, "| ", d.depth, " | _unreachable_ |", repeat(" |", length(HEADER) - 2))
            continue
        end
        s = cell_stats(d, r.n_examples)
        if s === nothing
            println(io, "| ", d.depth, " | _no usable program_ |", repeat(" |", length(HEADER) - 2))
            continue
        end
        v1_us_cell = s.v1_median_us === nothing ? "-" : @sprintf("%.2f", s.v1_median_us)
        v1_speedup_cell = s.v1_speedup === nothing ? "-" : @sprintf("%.1fx", s.v1_speedup)
        println(io, @sprintf(
            "| %d | %d | %.0f | %.2f | %.2f | %.2f | %.0f | %.0f | %.1f | %.2f | %.1f | %.1f%% | %.0f%% | %.0f%% | %s | %s |",
            d.depth, d.n_programs, s.nodes_mean, s.median_us, s.mean_us, s.p95_us,
            s.programs_per_s, s.evals_per_s, s.ns_per_node, s.kib_per_program,
            100 * s.gc_fraction, 100 * s.rep_spread, 100 * s.error_rate,
            100 * s.loop_rate, v1_us_cell, v1_speedup_cell))
    end

    if any(d.reachable && any(d.has_loop) for d in r.depths)
        println(io)
        println(io, "Split by whether the program contains a bounded loop (`WHILE`), whose body runs up to 1000 times:")
        println(io)
        println(io, "| depth | loop-free progs | mean us | % of time | loop progs | mean us | % of time |")
        println(io, "|---|---|---|---|---|---|---|")
        for d in r.depths
            s = d.reachable ? cell_stats(d, r.n_examples) : nothing
            s === nothing && continue
            (s.loopfree === nothing || s.loop === nothing) && continue
            println(io, @sprintf("| %d | %d | %.2f | %.1f%% | %d | %.2f | %.1f%% |",
                d.depth, s.loopfree.n, s.loopfree.mean_us, 100 * s.loopfree.time_share,
                s.loop.n, s.loop.mean_us, 100 * s.loop.time_share))
        end
    end

    if any(d.cmp_n_programs > 0 for d in r.depths)
        println(io)
        println(io, "Three-way comparison (informational -- see \"Reading the table\" below):")
        println(io)
        println(io, "- eval = `rulenode2expr`",
            r.name in STATEFUL_NAMES ? " + a state-threading rewrite (`stateful_expr`)" : "",
            " + literal `Core.eval` (fresh compile every call)")
        println(io, "- interpret = the same expression + `HerbInterpret.interpret` (the generic, non-generated evaluator)")
        println(io, "- custom = this benchmark's generated interpreter, same programs")
        println(io, "- v1 = \"custom v1\", the generated interpreter as it stood before the optimization pass this benchmark was built to drive (see README's \"custom v1\" section), same programs")
        println(io)
        println(io, "| depth | progs | eval us | v1 us | custom us | interpret progs | interpret us | custom us | eval speed-up | v1 speed-up | interpret speed-up |")
        println(io, "|---|---|---|---|---|---|---|---|---|---|---|")
        for d in r.depths
            c = comparison_stats(d, r.n_examples)
            c === nothing && continue
            eval_cell = c.eval_us === nothing ? "-" : @sprintf("%.2f", c.eval_us)
            eval_speedup = (c.eval_us === nothing || c.custom_us === nothing) ? "-" :
                @sprintf("%.0fx", c.eval_us / c.custom_us)
            v1_cell = c.v1_us === nothing ? "-" : @sprintf("%.2f", c.v1_us)
            v1_speedup = (c.v1_us === nothing || c.custom_us === nothing) ? "-" :
                @sprintf("%.1fx", c.v1_us / c.custom_us)
            custom_cell = c.custom_us === nothing ? "-" : @sprintf("%.2f", c.custom_us)
            interpret_cell = c.interpret_us === nothing ? "-" : @sprintf("%.2f", c.interpret_us)
            custom_supported_cell = c.custom_us_supported === nothing ? "-" : @sprintf("%.2f", c.custom_us_supported)
            interpret_speedup = (c.interpret_us === nothing || c.custom_us_supported === nothing) ? "-" :
                @sprintf("%.1fx", c.interpret_us / c.custom_us_supported)
            println(io, @sprintf("| %d | %d | %s | %s | %s | %d | %s | %s | %s | %s | %s |",
                d.depth, c.n, eval_cell, v1_cell, custom_cell,
                c.interpret_n, interpret_cell, custom_supported_cell,
                eval_speedup, v1_speedup, interpret_speedup))
        end
        if r.name in STATEFUL_NAMES
            println(io)
            println(io, "`interpret progs` is the subset of `progs` without a `WHILE` -- `HerbInterpret.interpret` ",
                "has no `:while` case, so loop-containing programs cannot be run through it at all; its own ",
                "`custom us` column is therefore the custom interpreter's median over *that* subset, not over ",
                "the `progs`-wide one used for the `eval` comparison.")
        end
    end
end

"""
    print_report(io, results, cfg)

Human-readable markdown report of a whole suite run.
"""
function print_report(io::IO, results::Vector{TargetResult}, cfg::BenchConfig)
    println(io, "# Custom interpreter performance")
    println(io)
    println(io, "- julia: ", VERSION, " on ", Sys.MACHINE)
    println(io, "- cpu: ", Sys.cpu_info()[1].model, " (", Sys.CPU_THREADS, " threads)")
    println(io, "- depths: ", join(cfg.depths, ", "))
    println(io, "- programs/depth: ", cfg.n_programs, ", examples/program: ", cfg.n_examples,
        ", repetitions: ", cfg.reps)
    println(io, "- sampler: side_slack=", cfg.side_slack, ", max_nodes=", cfg.max_nodes,
        ", WHILE nesting limit=", cfg.nesting_limit, ", seed=", cfg.seed)
    println(io, "- error policy: ", cfg.error_policy)

    println(io)
    println(io, "## Summary: program evaluations per second")
    println(io)
    probe = [d for d in cfg.depths if d in (first(cfg.depths), 10, last(cfg.depths))]
    println(io, "| benchmark | ", join(("depth $d" for d in probe), " | "), " |")
    println(io, "|", repeat("---|", length(probe) + 1))
    for r in results
        cells = String[]
        for d in probe
            idx = findfirst(x -> x.depth == d, r.depths)
            s = idx === nothing ? nothing : cell_stats(r.depths[idx], r.n_examples)
            push!(cells, s === nothing ? "-" : @sprintf("%.0f", s.programs_per_s))
        end
        println(io, "| ", r.name, " | ", join(cells, " | "), " |")
    end

    println(io)
    println(io, "## Per-benchmark detail")
    for r in results
        print_target(io, r)
    end

    println(io)
    println(io, """
    ## Reading the table

    - `nodes` is the mean number of `RuleNode`s per sampled program; it grows with
      depth, so `ns/node` is the measure to compare across depths and benchmarks.
    - `progs/s` counts one program evaluated on all its examples; `evals/s` counts
      program-example pairs.
    - `err%` is the share of *sampled* programs that raised. Those are excluded from
      the timings under the default `:filter` policy, but the figure itself says how
      often a search over this grammar hits an exception.
    - `rep±` is the spread between repetitions. Above ~10% treat the cell as noisy.
    - `loop%` is the share of timed programs containing a `WHILE`. Those dominate
      the mean and `p95`, which is why `median` and `mean` diverge so far on the
      stateful benchmarks.
    - `v1 us` / `v1 speed-up` is "custom v1" -- the pre-optimization interpreter
      (see `BenchTarget.v1_interpret`), run on the exact same programs as the
      main `median us` column, so `v1 speed-up` is a direct same-subset ratio
      (current custom interpreter's speed relative to v1), not informational
      like the three-way comparison below.
    - The three-way comparison is informational, not a second verdict on the
      custom interpreter: `eval` pays full compiler latency every call because
      each sampled program is a structurally distinct `Expr` with no method
      cache to reuse, which is not what a real workload would do with this
      amount of code. `interpret` is the fair comparison (the generic,
      non-generated evaluator the custom interpreters replace), except that it
      cannot run a `WHILE` at all.
    """)
    return nothing
end

print_report(results::Vector{TargetResult}, cfg::BenchConfig) =
    print_report(stdout, results, cfg)

# ---------------------------------------------------------------------------
# JSON, so that runs can be compared across interpreter versions
# ---------------------------------------------------------------------------

# The per-program times are deliberately left out: they make result files tens of
# megabytes, and `stats` already carries the summary of their distribution.
pass_to_dict(p::PassStats) = Dict(
    "total_ns" => Int(p.total_ns),
    "errors" => p.errors,
    "allocd_bytes" => p.allocd_bytes,
    "gc_ns" => p.gc_ns,
)

function depth_to_dict(d::DepthResult, n_examples::Int)
    s = cell_stats(d, n_examples)
    out = Dict{String,Any}(
        "depth" => d.depth,
        "reachable" => d.reachable,
        "n_candidates" => d.n_candidates,
        "n_errored" => d.n_errored,
        "n_oversized" => d.n_oversized,
        "n_slow" => d.n_slow,
        "n_programs" => d.n_programs,
        "node_counts" => d.node_counts,
        "has_loop" => d.has_loop,
        "passes" => pass_to_dict.(d.passes),
        "v1_passes" => pass_to_dict.(d.v1_passes),
        "cmp_n_programs" => d.cmp_n_programs,
        "eval_passes" => pass_to_dict.(d.eval_passes),
        "cmp_custom_times_ns" => Int.(d.cmp_custom_times_ns),
        "cmp_v1_times_ns" => Int.(d.cmp_v1_times_ns),
        "interpret_n_supported" => d.interpret_n_supported,
        "interpret_passes" => pass_to_dict.(d.interpret_passes),
        "cmp_custom_supported_times_ns" => Int.(d.cmp_custom_supported_times_ns),
    )
    if s !== nothing
        flat = Dict{String,Any}()
        for (k, v) in pairs(s)
            if v isa NamedTuple
                for (k2, v2) in pairs(v)
                    flat["$(k)_$(k2)"] = v2
                end
            else
                flat[string(k)] = v
            end
        end
        out["stats"] = flat
    end
    c = comparison_stats(d, n_examples)
    c !== nothing && (out["comparison_stats"] = Dict(string(k) => v for (k, v) in pairs(c)))
    return out
end

target_to_dict(r::TargetResult) = Dict{String,Any}(
    "name" => r.name,
    "grammar_id" => r.grammar_id,
    "n_grammar_rules" => r.n_grammar_rules,
    "n_examples" => r.n_examples,
    "needs_copy" => r.needs_copy,
    "cold_seconds" => r.cold_seconds,
    "depths" => [depth_to_dict(d, r.n_examples) for d in r.depths],
)

config_to_dict(cfg::BenchConfig) = Dict{String,Any}(
    string(f) => (f === :error_policy ? string(getfield(cfg, f)) : getfield(cfg, f))
    for f in fieldnames(BenchConfig)
)

"""
    save_results(path, results, cfg; label="")

Write a run to `path` as JSON, including the environment, so two runs can be
compared with `benchmark/compare.jl`.
"""
function save_results(
    path::AbstractString,
    results::Vector{TargetResult},
    cfg::BenchConfig;
    label::AbstractString = "",
)
    mkpath(dirname(path))
    payload = Dict{String,Any}(
        "label" => label,
        "timestamp" => string(Dates.now()),
        "julia_version" => string(VERSION),
        "machine" => Sys.MACHINE,
        "cpu" => Sys.cpu_info()[1].model,
        "config" => config_to_dict(cfg),
        "targets" => target_to_dict.(results),
    )
    open(path, "w") do io
        JSON.print(io, payload)
    end
    return path
end
