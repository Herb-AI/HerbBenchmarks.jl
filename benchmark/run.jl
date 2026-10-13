#!/usr/bin/env julia
#
# Benchmark the custom interpreters of all HerbBenchmarks benchmarks.
#
#     julia --project=benchmark benchmark/run.jl [options]
#
# Options (all optional):
#
#     --depths=5:15              depths to measure (range or comma list)
#     --programs=500             programs per depth
#     --examples=5               input examples per program
#     --reps=3                   repetitions of the whole program set
#     --seed=20261013            RNG seed
#     --side-slack=1             sampler bushiness
#     --max-nodes=2000           discard larger candidates
#     --nesting-limit=1          max nesting of WHILE rules
#     --error-policy=filter      filter | allow
#     --targets=A,B              restrict to these benchmarks
#     --baselines                also measure rulenode2expr + HerbInterpret.interpret
#     --baseline-programs=100    programs used for the baseline
#     --label=name               label stored in the result file
#     --out=path.json            where to write the results (default: benchmark/results/)
#     --no-save                  do not write a result file

include(joinpath(@__DIR__, "setup.jl"))

include(joinpath(@__DIR__, "src", "InterpreterBenchmarks.jl"))
using .InterpreterBenchmarks

using Dates

function parse_args(args)
    opts = Dict{String,String}()
    flags = Set{String}()
    for a in args
        if startswith(a, "--") && occursin('=', a)
            k, v = split(a[3:end], '='; limit = 2)
            opts[k] = v
        elseif startswith(a, "--")
            push!(flags, a[3:end])
        else
            error("unrecognised argument: $a")
        end
    end
    return opts, flags
end

function parse_depths(s::AbstractString)
    if occursin(':', s)
        parts = parse.(Int, split(s, ':'))
        return length(parts) == 2 ? collect(parts[1]:parts[2]) :
               collect(parts[1]:parts[2]:parts[3])
    end
    return parse.(Int, split(s, ','))
end

opts, flags = parse_args(ARGS)
getopt(k, default) = haskey(opts, k) ? opts[k] : default

cfg = BenchConfig(;
    depths = parse_depths(getopt("depths", "5:15")),
    n_programs = parse(Int, getopt("programs", "500")),
    n_examples = parse(Int, getopt("examples", "5")),
    reps = parse(Int, getopt("reps", "3")),
    seed = parse(Int, getopt("seed", "20261013")),
    side_slack = parse(Int, getopt("side-slack", "1")),
    max_nodes = parse(Int, getopt("max-nodes", "2000")),
    nesting_limit = parse(Int, getopt("nesting-limit", "1")),
    error_policy = Symbol(getopt("error-policy", "filter")),
    baselines = "baselines" in flags,
    baseline_programs = parse(Int, getopt("baseline-programs", "100")),
)

targets = haskey(opts, "targets") ? split(opts["targets"], ',') : DEFAULT_TARGETS

results = run_suite(cfg; targets = targets)

println()
print_report(stdout, results, cfg)

if !("no-save" in flags)
    label = getopt("label", "run")
    stamp = Dates.format(Dates.now(), "yyyy-mm-dd-HHMMSS")
    path = getopt("out", joinpath(@__DIR__, "results", "$stamp-$label.json"))
    save_results(path, results, cfg; label = label)

    # The markdown report lands next to the JSON, so a recorded run is readable
    # without re-deriving the tables.
    report_path = replace(path, r"\.json$" => "") * ".md"
    open(report_path, "w") do io
        print_report(io, results, cfg)
    end
    println("\nresults written to ", path, "\nreport written to  ", report_path)
end
