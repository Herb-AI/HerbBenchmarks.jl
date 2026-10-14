# Measurement harness.
#
# Protocol, per (benchmark, depth):
#
#  1. sample candidate programs of exactly that depth and evaluate each one once,
#     outside the measured region. That run doubles as warm-up (it forces the
#     specialisations of the runtime-generated interpreter) and as a filter:
#     random programs routinely raise `BoundsError`, `OverflowError`, ... and
#     throwing is an order of magnitude more expensive than interpreting, so
#     by default only programs that evaluate cleanly are timed. The discard
#     rates are reported, and `error_policy = :allow` keeps the failing ones.
#  2. repeat the whole set `reps` times. Every repetition gets a freshly prepared
#     input bundle (prepared *before* the timer starts), so mutating
#     interpreters never see an input twice.
#  3. time each program individually with `time_ns`, which costs ~20ns against
#     per-program times in the microsecond range and gives a distribution rather
#     than a single aggregate.

"""
    BenchConfig

Parameters of a benchmark run.

# Fields
- `depths`: program depths to measure (the task asks for 5-15).
- `n_programs`: programs per depth.
- `n_examples`: input examples each program is evaluated on.
- `reps`: how often the whole set of programs is re-evaluated.
- `seed`: RNG seed; a run is fully reproducible from it.
- `side_slack`: bushiness of sampled programs, see [`sample_program`](@ref).
- `max_nodes`: candidates with more nodes than this are discarded.
- `nesting_limit`: maximum nesting of `WHILE` rules, see [`DepthTable`](@ref).
- `attempt_factor`: give up after `attempt_factor * n_programs` candidates.
- `error_policy`: `:filter` to time only programs that evaluate cleanly,
  `:allow` to time every sampled program (failures included).
- `max_program_seconds`: candidates slower than this are discarded, so that a
  single pathological loop cannot dominate a cell.
- `baselines`: also measure the two informational comparison points: the
  `HerbInterpret.interpret` generic evaluator, and literal `Core.eval` of the
  same `rulenode2expr`-produced expression. See `benchmark/README.md` for what
  each one actually runs.
- `baseline_programs`: programs used for the (much slower) comparison baselines.
"""
struct BenchConfig
    depths::Vector{Int}
    n_programs::Int
    n_examples::Int
    reps::Int
    seed::Int
    side_slack::Int
    max_nodes::Int
    nesting_limit::Int
    attempt_factor::Int
    error_policy::Symbol
    max_program_seconds::Float64
    baselines::Bool
    baseline_programs::Int
end

function BenchConfig(;
    depths::AbstractVector{<:Integer} = 5:15,
    n_programs::Int = 500,
    n_examples::Int = 5,
    reps::Int = 3,
    seed::Int = 20261013,
    side_slack::Int = 1,
    max_nodes::Int = 2000,
    nesting_limit::Int = 1,
    attempt_factor::Int = 40,
    error_policy::Symbol = :filter,
    max_program_seconds::Float64 = 0.05,
    baselines::Bool = false,
    baseline_programs::Int = 100,
)
    error_policy in (:filter, :allow) ||
        error("error_policy must be :filter or :allow, got $error_policy")
    return BenchConfig(
        collect(Int, depths), n_programs, n_examples, reps, seed, side_slack,
        max_nodes, nesting_limit, attempt_factor, error_policy,
        max_program_seconds, baselines, baseline_programs,
    )
end

"""
    PassStats

Outcome of one timed pass over all programs of a depth.
"""
struct PassStats
    total_ns::UInt64
    times_ns::Vector{UInt64}
    errors::Int
    allocd_bytes::Int64
    gc_ns::Int64
end

"""
    DepthResult

Everything measured for one (benchmark, depth) cell.
"""
struct DepthResult
    depth::Int
    reachable::Bool
    n_candidates::Int
    n_errored::Int
    n_oversized::Int
    n_slow::Int
    n_programs::Int
    node_counts::Vector{Int}
    has_loop::Vector{Bool}
    passes::Vector{PassStats}

    # "custom v1": the exact same `programs` as `passes`, run through the
    # pre-optimization interpreter (see `BenchTarget.v1_interpret`). Unlike the
    # eval/interpret comparison points below, this needs no supported-subset
    # restriction, so it is measured on the full set regardless of `cfg.baselines`.
    v1_passes::Vector{PassStats}

    # Three-way comparison (eval / HerbInterpret.interpret / custom), computed
    # over a smaller subset: eval in particular pays full compiler latency on
    # every call, so timing all `n_programs` would make the suite far slower.
    cmp_n_programs::Int                        # size of the eval-baseline subset
    eval_passes::Vector{PassStats}
    cmp_custom_times_ns::Vector{UInt64}         # custom interpreter, same subset (sliced out of `passes`, not re-measured)
    cmp_v1_times_ns::Vector{UInt64}             # custom v1, same subset (sliced out of `v1_passes`, not re-measured)
    interpret_n_supported::Int                  # of cmp_n_programs, how many HerbInterpret.interpret can even attempt
    interpret_passes::Vector{PassStats}          # over just the supported ones
    cmp_custom_supported_times_ns::Vector{UInt64}  # custom interpreter, supported-only subset
end

"""
    TargetResult

All depths measured for one benchmark, plus `cold_seconds`: the wall time to
generate an interpreter for a grammar the process has not seen before *and* run
its first program. Empty for the benchmarks that share one interpreter across all
their problems.
"""
struct TargetResult
    name::String
    grammar_id::String
    n_grammar_rules::Int
    n_examples::Int
    needs_copy::Bool
    cold_seconds::Vector{Float64}
    depths::Vector{DepthResult}
end

# ---------------------------------------------------------------------------

"""
    timed_pass!(evaluate, programs, inputs, times) -> PassStats

Evaluate every program once, recording its wall time, allocations and GC time.
`evaluate` is called as `evaluate(program, input_bundle)`.
"""
function timed_pass!(evaluate, programs::Vector, inputs::Vector, times::Vector{UInt64})
    n = length(programs)
    sink = Ref{Any}(nothing)
    errors = 0
    GC.gc()
    gc_before = Base.gc_num()
    start = time_ns()
    for k in 1:n
        t0 = time_ns()
        result = try
            evaluate(programs[k], inputs[k])
        catch
            errors += 1
            nothing
        end
        times[k] = time_ns() - t0
        sink[] = result   # keep the result alive so nothing can be elided
    end
    total = time_ns() - start
    diff = Base.GC_Diff(Base.gc_num(), gc_before)
    return PassStats(total, copy(times), errors, diff.allocd, diff.total_time)
end

"""
    collect_programs(target, tab, depth, cfg, rng)

Sample programs of exactly `depth`, discarding oversized, failing (unless
`cfg.error_policy == :allow`) and pathologically slow candidates. Returns
`nothing` when the depth is unreachable for this grammar.
"""
function collect_programs(
    t::BenchTarget,
    tab::DepthTable,
    depth::Int,
    cfg::BenchConfig,
    rng::AbstractRNG,
)
    isreachable(tab, t.start_symbol, depth) || return nothing

    programs = AbstractRuleNode[]
    n_candidates = 0
    n_errored = 0
    n_oversized = 0
    n_slow = 0
    max_attempts = cfg.n_programs * cfg.attempt_factor

    while length(programs) < cfg.n_programs && n_candidates < max_attempts
        program = sample_program(
            t.grammar, t.start_symbol, depth, tab, rng; side_slack = cfg.side_slack
        )
        n_candidates += 1

        if count_nodes(program) > cfg.max_nodes
            n_oversized += 1
            continue
        end

        # This run warms the interpreter up and tells us whether the program is
        # usable; both have to happen outside the measured region.
        bundle = prepare_inputs(t, 1)[1]
        t0 = time_ns()
        failed = false
        try
            t.interpret(program, bundle)
        catch
            failed = true
        end
        elapsed = (time_ns() - t0) / 1e9

        failed && (n_errored += 1)
        if elapsed > cfg.max_program_seconds
            n_slow += 1
            continue
        end
        if failed && cfg.error_policy === :filter
            continue
        end
        push!(programs, program)
    end

    return (
        programs = programs,
        n_candidates = n_candidates,
        n_errored = n_errored,
        n_oversized = n_oversized,
        n_slow = n_slow,
    )
end

"""
    measure_cold(probe, cfg) -> Vector{Float64}

Time, for each probed problem, generating an interpreter for its grammar and
running one program through it. Sampling the program and loading the problem
happen before the timer starts, so the figure is interpreter generation plus the
first-call compilation only.
"""
function measure_cold(probe::ColdProbe, cfg::BenchConfig)
    timings = Float64[]
    for (i, id) in enumerate(probe.ids)
        grammar, inputs = probe.setup(id)
        limited = loop_rules(grammar)
        tab = DepthTable(grammar; maxdepth = 5, limited = limited,
            nesting_limit = cfg.nesting_limit)
        depth = findfirst(d -> isreachable(tab, :Start, d), 1:5)
        depth === nothing && continue
        program = sample_program(grammar, :Start, depth, tab, MersenneTwister(cfg.seed + i))
        elapsed = @elapsed begin
            interpreter = probe.build(grammar)
            try
                interpreter(program, inputs)
            catch
            end
        end
        push!(timings, elapsed)
    end
    return timings
end

"""
    measure(target, cfg; verbose=true) -> TargetResult

Run the full depth sweep for one benchmark.
"""
function measure(t::BenchTarget, cfg::BenchConfig; verbose::Bool = true)
    cold_seconds = t.cold === nothing ? Float64[] : measure_cold(t.cold, cfg)

    tab = DepthTable(
        t.grammar;
        maxdepth = maximum(cfg.depths),
        limited = t.loop_rules,
        nesting_limit = cfg.nesting_limit,
    )

    results = DepthResult[]
    for depth in cfg.depths
        rng = MersenneTwister(cfg.seed + depth)     # one depth == one reproducible cell
        sampled = collect_programs(t, tab, depth, cfg, rng)

        if sampled === nothing
            verbose && @info "  depth $depth: unreachable for $(t.name)"
            push!(results, DepthResult(
                depth, false, 0, 0, 0, 0, 0, Int[], Bool[], PassStats[], PassStats[],
                0, PassStats[], UInt64[], UInt64[], 0, PassStats[], UInt64[],
            ))
            continue
        end

        programs = sampled.programs
        if isempty(programs)
            verbose && @warn "  depth $depth: no usable program found for $(t.name)" sampled.n_candidates sampled.n_errored
            push!(results, DepthResult(
                depth, true, sampled.n_candidates, sampled.n_errored,
                sampled.n_oversized, sampled.n_slow, 0, Int[], Bool[],
                PassStats[], PassStats[], 0, PassStats[], UInt64[], UInt64[], 0, PassStats[], UInt64[],
            ))
            continue
        end

        node_counts = count_nodes.(programs)
        has_loop = [contains_rule(p, t.loop_rules) for p in programs]
        times = Vector{UInt64}(undef, length(programs))

        passes = PassStats[]
        for _ in 1:cfg.reps
            inputs = prepare_inputs(t, length(programs))
            push!(passes, timed_pass!(t.interpret, programs, inputs, times))
        end

        v1_passes = PassStats[]
        for _ in 1:cfg.reps
            inputs = prepare_raw_inputs(t, length(programs))
            push!(v1_passes, timed_pass!(t.v1_interpret, programs, inputs, times))
        end

        cmp_n = 0
        eval_passes = PassStats[]
        interpret_passes = PassStats[]
        interpret_n_supported = 0
        cmp_custom_times = UInt64[]
        cmp_v1_times = UInt64[]
        cmp_custom_supported_times = UInt64[]

        if cfg.baselines
            cmp_n = min(cfg.baseline_programs, length(programs))
            cmp_programs = programs[1:cmp_n]

            # The custom interpreter's times on this exact subset: sliced out of
            # the sweep already run above, not re-measured.
            cmp_custom_times = reduce(vcat, (p.times_ns[1:cmp_n] for p in passes))
            cmp_v1_times = reduce(vcat, (p.times_ns[1:cmp_n] for p in v1_passes))

            if t.eval_baseline !== nothing
                eval_times = Vector{UInt64}(undef, cmp_n)
                t.eval_baseline(cmp_programs[1], prepare_raw_inputs(t, 1)[1])  # warm up / compile
                for _ in 1:cfg.reps
                    inputs = prepare_raw_inputs(t, cmp_n)
                    push!(eval_passes, timed_pass!(t.eval_baseline, cmp_programs, inputs, eval_times))
                end
            end

            if t.interpret_baseline !== nothing
                # `HerbInterpret.interpret` cannot run a `WHILE` (no `:while`
                # case), so the stateful benchmarks' comparison is restricted to
                # the loop-free programs within `cmp_programs`; this is a
                # structural gap, not a random failure, so it is excluded before
                # timing rather than counted as an error.
                supported_mask = .!(t.interpret_unsupported.(cmp_programs))
                interpret_n_supported = count(supported_mask)
                cmp_custom_supported_times =
                    cmp_custom_times[repeat(supported_mask, cfg.reps)]

                if interpret_n_supported > 0
                    interpret_programs = cmp_programs[supported_mask]
                    interpret_times = Vector{UInt64}(undef, interpret_n_supported)
                    t.interpret_baseline(interpret_programs[1], prepare_raw_inputs(t, 1)[1])  # warm up
                    for _ in 1:cfg.reps
                        inputs = prepare_raw_inputs(t, interpret_n_supported)
                        push!(interpret_passes,
                            timed_pass!(t.interpret_baseline, interpret_programs, inputs, interpret_times))
                    end
                end
            end
        end

        push!(results, DepthResult(
            depth, true, sampled.n_candidates, sampled.n_errored,
            sampled.n_oversized, sampled.n_slow, length(programs), node_counts,
            has_loop, passes, v1_passes,
            cmp_n, eval_passes, cmp_custom_times, cmp_v1_times,
            interpret_n_supported, interpret_passes, cmp_custom_supported_times,
        ))

        if verbose
            us = median(vcat((p.times_ns for p in passes)...)) / 1e3
            @info @sprintf("  depth %2d: %4d programs, %6.1f nodes avg, %8.2f us/program (median)",
                depth, length(programs), mean(node_counts), us)
        end
    end

    return TargetResult(
        t.name, t.grammar_id, length(t.grammar.rules), cfg.n_examples,
        t.needs_copy, cold_seconds, results,
    )
end

"""
    run_suite(cfg; targets=DEFAULT_TARGETS, verbose=true) -> Vector{TargetResult}
"""
function run_suite(
    cfg::BenchConfig;
    targets::AbstractVector{<:AbstractString} = DEFAULT_TARGETS,
    verbose::Bool = true,
)
    out = TargetResult[]
    for name in targets
        verbose && @info "measuring $name"
        target = build_target(name; n_examples = cfg.n_examples)
        push!(out, measure(target, cfg; verbose = verbose))
    end
    return out
end
