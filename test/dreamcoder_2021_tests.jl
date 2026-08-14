@testitem "DreamCoder 2021 — structure" begin
    import HerbBenchmarks.DreamCoder_2021
    import HerbBenchmarks.DreamCoder_2021: List_2021, Text_2021, LOGO_2021, Tower_2021, Physics_2021
    import HerbCore: AbstractGrammar
    import HerbSpecification

    expected = Dict(List_2021 => 217, Text_2021 => 128, LOGO_2021 => 160,
        Tower_2021 => 113, Physics_2021 => 61)

    @test Set(DreamCoder_2021.SUB_BENCHMARKS) == Set(keys(expected))

    @testset "$(nameof(mod))" for mod in DreamCoder_2021.SUB_BENCHMARKS
        identifiers = get_all_identifiers(mod)
        @test length(identifiers) == expected[mod]

        # Every problem must resolve to a grammar, and inputs must line up with
        # the grammar's `_arg_` rules.
        input_rules(g::AbstractGrammar) =
            findall(rule -> occursin("_arg_", string(rule)), g.rules)

        for pair in get_all_problem_grammar_pairs(mod)
            @test pair.problem isa HerbSpecification.Problem
            @test pair.problem.spec[1] isa HerbSpecification.IOExample
            @test length(pair.problem.spec[1].in) == length(input_rules(pair.grammar))
        end
    end

    # DreamCoder's sub-benchmarks are reachable through the top-level fetcher.
    names_of = Set(nameof(b.module_name) for b in get_all_benchmarks())
    @test issubset(Set(nameof(m) for m in DreamCoder_2021.SUB_BENCHMARKS), names_of)
end

@testitem "DreamCoder 2021 — List" begin
    import HerbBenchmarks.DreamCoder_2021.List_2021 as L
    import HerbGrammar: expr2rulenode

    g = L.grammar_000_add_k_with_k_0
    interpret = L.make_list_interpreter(g)
    outputs(p) = [e.out for e in p.spec]
    run(p, e) = interpret(expr2rulenode(e, g), p.spec)

    @testset "primitives" begin
        @test L.dc_cons(1, [2, 3]) == [1, 2, 3]
        @test L.dc_car([1, 2, 3]) == 1
        @test L.dc_cdr([1, 2, 3]) == [2, 3]
        @test L.dc_index(0, [7, 8, 9]) == 7          # 0-based, as in DreamCoder
        @test L.dc_range(4) == [0, 1, 2, 3]
        @test L.dc_fold([1, 2, 3], 0, L.dc_add2) == 6
        # `dc_fold` is a *right* fold, so cons rebuilds the list unchanged
        # while `dc_snoc` reverses it.
        @test L.dc_fold([1, 2, 3], Int[], L.dc_cons) == [1, 2, 3]
        @test L.dc_fold([1, 2, 3], Int[], L.dc_snoc) == [3, 2, 1]
        @test L.dc_is_prime(7) && !L.dc_is_prime(8)
        @test L.dc_is_square(9) && !L.dc_is_square(8)
    end

    @testset "known solutions" begin
        @test run(L.problem_000_add_k_with_k_0, :(dc_map(dc_identity, _arg_1))) ==
              outputs(L.problem_000_add_k_with_k_0)
        @test run(L.problem_001_add_k_with_k_1, :(dc_map(dc_add(1), _arg_1))) ==
              outputs(L.problem_001_add_k_with_k_1)
        @test run(L.problem_178_reverse, :(dc_fold(_arg_1, dc_empty, dc_snoc))) ==
              outputs(L.problem_178_reverse)
        @test run(L.problem_210_sum, :(dc_fold(_arg_1, 0, dc_add2))) ==
              outputs(L.problem_210_sum)
        @test run(L.problem_122_len, :(dc_length(_arg_1))) == outputs(L.problem_122_len)
        @test run(L.problem_089_head, :(dc_car(_arg_1))) == outputs(L.problem_089_head)
        @test run(L.problem_211_tail, :(dc_cdr(_arg_1))) == outputs(L.problem_211_tail)
        @test run(L.problem_103_is_primes, :(dc_all(dc_is_prime, _arg_1))) ==
              outputs(L.problem_103_is_primes)
        @test run(L.problem_080_evens, :(dc_filter(dc_divisible_by(1 + 1), _arg_1))) ==
              outputs(L.problem_080_evens)
        @test run(L.problem_123_max, :(dc_fold(dc_cdr(_arg_1), dc_car(_arg_1), dc_max2))) ==
              outputs(L.problem_123_max)
        @test run(L.problem_006_append_index_k_with_k_1,
            :(dc_append(_arg_1, dc_cons(dc_index(0, _arg_1), dc_empty)))) ==
              outputs(L.problem_006_append_index_k_with_k_1)
    end

    @testset "integer-input tasks get an integer-typed input rule" begin
        g_range = L.grammar_155_range
        interpret_range = L.make_list_interpreter(g_range)
        @test interpret_range(expr2rulenode(:(dc_range(_arg_1)), g_range),
            L.problem_155_range.spec) == outputs(L.problem_155_range)
    end
end

@testitem "DreamCoder 2021 — Text" begin
    import HerbBenchmarks.DreamCoder_2021.Text_2021 as T
    import HerbGrammar: expr2rulenode

    function solves(ident, expr)
        g = getfield(T, Symbol("grammar_", ident))
        p = getfield(T, Symbol("problem_", ident))
        interpret = T.make_text_interpreter(g)
        return interpret(expr2rulenode(expr, g), p.spec) == [e.out for e in p.spec]
    end

    @testset "primitives" begin
        @test T.take_word("a.b.c", '.') == "a"
        @test T.drop_first_word("a.b.c", '.') == "b.c"
        @test T.last_word("a.b.c", '.') == "c"
        @test T.word_at("a.b.c", '.', 2) == "b"
        @test T.first_letters("Allen Newell", ' ') == "AN"
        @test T.take_first("abcdef", 3) == "abc"
        @test T.drop_last("abcdef", 2) == "abcd"
        @test T.ensure_suffix("ab", "cd") == "abcd"
        @test T.ensure_suffix("abcd", "cd") == "abcd"
        @test T.replace_character("a.b", '.', ',') == "a,b"
        @test T.str_capitalize("hELLO") == "Hello"
        @test_throws BoundsError T.take_first("ab", 5)
    end

    @testset "known solutions" begin
        @test solves("000_replace_w", :(replace_character(_arg_1, ',', '(')))
        @test solves("017_drop_first_word_delimited_by_3", :(drop_first_word(_arg_1, ' ')))
        @test solves("046_drop_last_2_characters", :(drop_last(_arg_1, 2)))
        @test solves("049_take_first_3_characters", :(take_first(_arg_1, 3)))
        @test solves("060_first_letters_of_words_i", :(first_letters(_arg_1, ' ')))
        @test solves("084_append_2_strings_i", :(str_concat(_arg_1, _arg_2)))
        @test solves("113_parentheses_around_first_word",
            :(str_concat(str_concat(char_str('('), take_word(_arg_1, ' ')), char_str(')'))))
    end

    @testset "metadata" begin
        @test length(T.PROBLEM_NAMES) == 128
        @test T.PROBLEM_NAMES["000_replace_w"] == "Replace ',' w/ '('"
        # Tasks that prepend or append a fixed word need that word as a constant.
        prepend_ids = [id for (id, n) in T.PROBLEM_NAMES if startswith(n, "Prepend '")]
        @test !isempty(prepend_ids)
        @test all(!isempty(T.PROBLEM_CONSTANTS[id]) for id in prepend_ids)
    end
end

@testitem "DreamCoder 2021 — Tower" begin
    import HerbBenchmarks.DreamCoder_2021.Tower_2021 as T

    @testset "reference programs rebuild their target" begin
        identifiers = sort(collect(keys(T.REFERENCE_PROGRAMS)))
        @test length(identifiers) == 113
        failures = String[]
        for id in identifiers
            problem = getfield(T, Symbol("problem_", id))
            built = T.interpret(T.reference_program(id), problem.spec[1])
            built == problem.spec[1].out || push!(failures, id)
        end
        @test isempty(failures)
    end

    @testset "semantics" begin
        # A single upright block: 1x3, stored with doubled dimensions and
        # settled onto the ground.
        @test T.run_tower(T.place_v, T.TowerState()) == [(0, 3, 2, 6)]
        # `tower_embed` keeps the blocks but restores the hand, so the two
        # blocks below land in the same column.
        stacked = T.run_tower(T.seq(T.tower_embed(T.seq(T.move_right(4), T.place_h)), T.place_h),
            T.TowerState())
        @test length(stacked) == 2
        # `tower_loop` repeats its body.
        @test length(T.run_tower(T.tower_loop(3, T.place_v), T.TowerState())) == 3
    end

    @testset "visualiser" begin
        target = T.problem_000_arch_leg_1.spec[1].out
        art = T.tower_ascii(target)
        lines = split(art, '\n')
        filled(line) = count(c -> c != ' ', line)

        # An arch: two legs with a gap between them, capped by a solid lintel,
        # standing on the ground line. Adjacent blocks alternate '#' and '%',
        # so test for "not empty" rather than for one particular glyph.
        @test all(==('='), last(lines))
        @test filled(first(lines)) == length(first(lines))   # lintel spans the width
        @test filled(lines[end-1]) < length(lines[end-1])    # gap between the legs

        grid = T.tower_grid(target)
        @test size(grid) == (length(lines) - 1, length(first(lines)))
        @test length(unique(filter(!=(0), vec(grid)))) == 3  # three blocks
    end
end

@testitem "DreamCoder 2021 — LOGO" begin
    import HerbBenchmarks.DreamCoder_2021.LOGO_2021 as L

    @testset "reference programs redraw their target" begin
        identifiers = sort(collect(keys(L.REFERENCE_PROGRAMS)))
        @test length(identifiers) == 160
        failures = String[]
        for id in identifiers
            problem = getfield(L, Symbol("problem_", id))
            drawn = L.interpret(L.reference_program(id), problem.spec[1])
            drawn == problem.spec[1].out || push!(failures, id)
        end
        @test isempty(failures)
    end

    @testset "semantics" begin
        # Angles are whole turns: four quarter-turns of unit length close a
        # square, so the pen returns to where it started.
        square = L.logo_loop(4, L.move(L.unit_length, L.div_angle(L.unit_angle, 4)))
        final = square(L.TurtleState())
        @test isapprox(final.x, 0.0; atol=1e-9)
        @test isapprox(final.y, 0.0; atol=1e-9)
        @test length(final.segments) == 4

        # `pen_toggle` moves without drawing.
        @test isempty(L.pen_toggle(L.move(L.unit_length, L.zero_angle))(L.TurtleState()).segments)

        # `logo_embed` keeps what was drawn but restores the pen's position.
        embedded = L.logo_embed(L.move(L.unit_length, L.zero_angle))(L.TurtleState())
        @test length(embedded.segments) == 1
        @test embedded.x == 0.0
    end

    @testset "rendering" begin
        image = L.problem_002_5_gon_1l.spec[1].out
        @test size(image) == (L.LOGO_RESOLUTION, L.LOGO_RESOLUTION)
        @test any(image)

        art = L.logo_ascii(image)
        @test occursin('#', art)
        @test length(split(art, '\n')) == L.LOGO_RESOLUTION

        # A picture compared against itself shows no disagreement.
        diff = L.logo_ascii_diff(image, image)
        @test !occursin('+', diff) && !occursin('-', diff)

        svg = L.logo_svg(L.reference_program("002_5_gon_1l"))
        @test startswith(svg, "<svg")
        @test occursin("<line", svg)
    end
end

@testitem "DreamCoder 2021 — Physics" begin
    import HerbBenchmarks.DreamCoder_2021.Physics_2021 as P
    import HerbGrammar: expr2rulenode

    function solves(ident, expr)
        g = getfield(P, Symbol("grammar_", ident))
        p = getfield(P, Symbol("problem_", ident))
        return P.solves(P.make_physics_interpreter(g), expr2rulenode(expr, g), p)
    end

    @testset "primitives" begin
        @test P.vec_add([1.0, 2.0], [3.0, 4.0]) == [4.0, 6.0]
        @test P.vec_dot([1.0, 2.0], [3.0, 4.0]) == 11.0
        @test P.vec_norm([3.0, 4.0]) == 5.0
        @test P.vec_cross([1.0, 0.0, 0.0], [0.0, 1.0, 0.0]) == [0.0, 0.0, 1.0]
        @test P.reals_reciprocal_sum([2.0, 2.0]) == 1.0
        # The data was generated with scientificLaws.py's literal 3.14.
        @test P.dc_pi == 3.14
    end

    @testset "known laws" begin
        @test solves("000_vector_addition_2", :(vec_add(_arg_1, _arg_2)))
        @test solves("001_vector_addition_many", :(vec_add_many(_arg_1)))
        @test solves("002_vector_norm", :(vec_norm(_arg_1)))
        @test solves("003_freefall_velocity",
            :(real_sqrt(real_mul(real_mul(2.0, dc_g), _arg_1))))
        @test solves("007_e_mc_2", :(real_mul(_arg_1, real_mul(_arg_2, _arg_2))))
        @test solves("021_a_sum_f_m",
            :(vec_scale(real_reciprocal(_arg_1), vec_add_many(_arg_2))))
        @test solves("022_work_f_d", :(vec_dot(_arg_1, _arg_2)))
        @test solves("026_tau_rxf_3d", :(vec_cross(_arg_1, _arg_2)))
        @test solves("057_parallel_capacitors", :(reals_sum(_arg_1)))
        @test solves("059_a_pir_2", :(real_mul(dc_pi, real_mul(_arg_1, _arg_1))))
    end

    @testset "solves rejects wrong and throwing programs" begin
        g = P.grammar_022_work_f_d
        interpret = P.make_physics_interpreter(g)
        # The wrong law.
        @test !P.solves(interpret, expr2rulenode(:(vec_norm(_arg_1)), g), P.problem_022_work_f_d)
        # A program that throws on a vector-valued argument must not "solve" it.
        @test !P.solves(interpret, expr2rulenode(:(real_reciprocal(vec_dot(_arg_1, _arg_2))), g),
            P.problem_022_work_f_d)
    end
end
