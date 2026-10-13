#!/usr/bin/env julia
#
# Correctness checks for the benchmark itself. A performance number is only worth
# as much as the claim that the thing measured is doing the right work, so this
# asserts the invariants the harness relies on:
#
#   1. sampled programs have exactly the requested depth,
#   2. the loop-nesting cap is respected,
#   3. every target builds and its interpreter evaluates sampled programs,
#   4. the custom interpreter and the two comparison baselines (`eval` and
#      `HerbInterpret.interpret`) agree on every program both can evaluate --
#      without this, the comparison columns of the report would be comparing
#      different work,
#   5. interpreters that mutate their input get a fresh one per evaluation.
#
#     julia --project=benchmark benchmark/selftest.jl

include(joinpath(@__DIR__, "setup.jl"))
include(joinpath(@__DIR__, "src", "InterpreterBenchmarks.jl"))
using .InterpreterBenchmarks

using HerbCore
using HerbGrammar
using Printf
using Random
using Test

const DEPTHS = 5:15

"""
    loop_nesting(node, rules) -> Int

Deepest chain of `rules` applications on any root-to-leaf path.
"""
function loop_nesting(node::AbstractRuleNode, rules::Set{Int})
    here = (get_rule(node) in rules) ? 1 : 0
    return here + maximum(c -> loop_nesting(c, rules), get_children(node); init = 0)
end

@testset "InterpreterBenchmarks" begin
    for name in DEFAULT_TARGETS
        target = build_target(name; n_examples = 3)
        table = DepthTable(
            target.grammar;
            maxdepth = maximum(DEPTHS),
            limited = target.loop_rules,
            nesting_limit = 1,
        )
        rng = MersenneTwister(4242)

        @testset "$name" begin
            programs = AbstractRuleNode[]
            for depth in DEPTHS
                isreachable(table, target.start_symbol, depth) || continue
                for _ in 1:40
                    program = sample_program(
                        target.grammar, target.start_symbol, depth, table, rng;
                        side_slack = 1,
                    )
                    @test tree_depth(program) == depth
                    @test loop_nesting(program, target.loop_rules) <= 1
                    push!(programs, program)
                end
            end
            @test !isempty(programs)

            # A random program may legitimately raise from a primitive, but a
            # usable share of them has to evaluate -- otherwise the inputs are
            # not shaped the way the interpreter expects.
            evaluated = 0
            for program in programs
                try
                    target.interpret(program, prepare_inputs(target, 1)[1])
                    evaluated += 1
                catch
                end
            end
            @test evaluated >= 0.1 * length(programs)
            @printf("  %s: %d/%d sampled programs evaluate cleanly\n",
                name, evaluated, length(programs))

            # `eval_baseline` runs real Julia, including `while`, so it has to
            # agree with the custom interpreter on every program.
            if target.eval_baseline !== nothing
                agreements = 0
                for program in programs
                    custom = try
                        (true, target.interpret(program, target.inputs))
                    catch
                        (false, nothing)
                    end
                    base = try
                        (true, target.eval_baseline(program, target.inputs))
                    catch
                        (false, nothing)
                    end
                    @test custom[1] == base[1]
                    if custom[1] && base[1]
                        @test custom[2] == base[2]
                        agreements += 1
                    end
                end
                @test agreements > 0
                @printf("  %s: eval baseline agrees on %d/%d evaluable programs\n",
                    name, agreements, length(programs))
            end

            # `interpret_baseline` cannot run a `WHILE` at all (no `:while` case
            # in `HerbInterpret.interpret`), so those programs are skipped
            # rather than counted as a disagreement.
            if target.interpret_baseline !== nothing
                supported = filter(!target.interpret_unsupported, programs)
                @test !isempty(supported)
                agreements = 0
                for program in supported
                    custom = try
                        (true, target.interpret(program, target.inputs))
                    catch
                        (false, nothing)
                    end
                    base = try
                        (true, target.interpret_baseline(program, target.inputs))
                    catch
                        (false, nothing)
                    end
                    @test custom[1] == base[1]
                    if custom[1] && base[1]
                        @test custom[2] == base[2]
                        agreements += 1
                    end
                end
                @test agreements > 0
                @printf("  %s: interpret baseline agrees on %d/%d evaluable programs (%d/%d support WHILE-free)\n",
                    name, agreements, length(supported), length(supported), length(programs))
            end

            if target.needs_copy
                # Two bundles must be independent objects, or one program would
                # inherit the state another one left behind.
                first_bundle, second_bundle = prepare_inputs(target, 2)
                @test first_bundle !== second_bundle
                @test all(a !== b for (a, b) in zip(first_bundle, second_bundle))
            end

            # `prepare_inputs` uses `prepared_inputs` (already run through
            # `HerbInterpret.prepare_input`) when there is one; it must give
            # exactly the same results as the raw `inputs` it was derived from.
            if target.prepared_inputs !== nothing
                @test eltype(target.prepared_inputs) <: NamedTuple
                raw_bundle = prepare_raw_inputs(target, 1)[1]
                prepared_bundle = prepare_inputs(target, 1)[1]
                @test prepared_bundle !== raw_bundle
                matched = 0
                for program in programs
                    raw = try
                        (true, target.interpret(program, raw_bundle))
                    catch
                        (false, nothing)
                    end
                    prepared = try
                        (true, target.interpret(program, prepared_bundle))
                    catch
                        (false, nothing)
                    end
                    @test raw == prepared
                    raw[1] && (matched += 1)
                end
                @test matched > 0
                @printf("  %s: prepared inputs agree with raw inputs on %d/%d programs\n",
                    name, matched, length(programs))
            end
        end
    end

    @testset "harness end to end" begin
        cfg = BenchConfig(; depths = 5:6, n_programs = 10, n_examples = 2, reps = 2,
            baselines = true, baseline_programs = 5)
        results = run_suite(cfg; targets = ["PBE_BV_Track_2018", "Robots_2020"],
            verbose = false)
        @test length(results) == 2
        for result in results
            for depth in result.depths
                stats = cell_stats(depth, result.n_examples)
                @test stats !== nothing
                @test stats.median_us > 0
                @test stats.programs_per_s > 0
                @test stats.ns_per_node > 0

                cmp = comparison_stats(depth, result.n_examples)
                @test cmp !== nothing
                @test cmp.eval_us === nothing || cmp.eval_us > 0
                @test cmp.custom_us === nothing || cmp.custom_us > 0
            end
        end
    end
end
