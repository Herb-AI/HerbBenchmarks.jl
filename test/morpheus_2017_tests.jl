@testitem "Morpheus 2017" begin
    import HerbBenchmarks.Morpheus_2017 as Morpheus
    import HerbGrammar: AbstractGrammar, expr2rulenode

    input_rules(grammar::AbstractGrammar) =
        findall(rule -> occursin("_arg_", string(rule)), grammar.rules)
    grammar_rules(grammar::AbstractGrammar) = string.(grammar.rules)

    pairs = HerbBenchmarks.get_all_problem_grammar_pairs(Morpheus)
    @test length(pairs) == 72
    @test Morpheus.morpheus_identifiers() == [lpad(string(i), 3, '0') for i in 1:72]

    first_problem = HerbBenchmarks.get_problem(Morpheus, "001")
    first_example = only(first_problem.spec)
    @test occursin("round var1 var2 nam", first_example.in[:_arg_1].raw)
    @test Morpheus.morpheus_columns(first_example.in[:_arg_1]) == [:round, :var1, :var2, :nam, :val]
    @test Morpheus.morpheus_data(first_example.in[:_arg_1])[1] == ["round1", "round2", "round1", "round2"]
    @test Morpheus.morpheus_colindex(first_example.in[:_arg_1])[:round] == 1

    first_grammar_rules = grammar_rules(HerbBenchmarks.get_grammar(Morpheus, "001"))
    @test all(c -> "col(:$c)" in first_grammar_rules, Morpheus.MORPHEUS_TEMPORARY_COLUMNS)
    @test all(c -> "newcol(:$c)" in first_grammar_rules, Morpheus.MORPHEUS_TEMPORARY_COLUMNS)
    @test "col(:round)" in first_grammar_rules
    @test !("newcol(:round)" in first_grammar_rules)
    @test "newcol(:val_round1)" in first_grammar_rules

    ratio_grammar_rules = grammar_rules(HerbBenchmarks.get_grammar(Morpheus, "009"))
    @test "col(:High)" in ratio_grammar_rules
    @test "col(:Low)" in ratio_grammar_rules
    @test !("newcol(:High)" in ratio_grammar_rules)
    spaced_problem = HerbBenchmarks.get_problem(Morpheus, "010")
    spaced_example = only(spaced_problem.spec)
    @test Morpheus.table_rows(spaced_example.in[:_arg_1])[2] == Any["2012-07-13", 6.0, "Stats Winter school", "R|regression"]
    @test Morpheus.table_rows(spaced_example.out)[2] == Any["2012-07-13", 6.0, "Stats Winter school", "R"]

    expected = first_example.out
    input = first_example.in[:_arg_1]
    actual = Morpheus.spread(
        Morpheus.unite(
            Morpheus.gather(input, :key, :value, Morpheus.not_cols2(:round, :nam)),
            :tmp,
            :key,
            :round,
        ),
        :tmp,
        :value,
    )
    @test actual == expected

    @test Morpheus.MorpheusTable([:x], Any[[missing]]) != Morpheus.MorpheusTable([:x], Any[["missing"]])
    @test Morpheus.MorpheusTable([:x], Any[[1]]) != Morpheus.MorpheusTable([:x], Any[["1"]])
    @test Morpheus.MorpheusTable([:x], Any[[:a]]) == Morpheus.MorpheusTable([:x], Any[["a"]])

    simple = Morpheus.MorpheusTable([:id, :a], Any[[1, 10]])
    @test_throws ArgumentError Morpheus.select(simple, Morpheus.cols(:missing_col))
    @test_throws ArgumentError Morpheus.gather(simple, :key, :value, Morpheus.cols2(:a, :a))

    duplicate_spread = Morpheus.MorpheusTable([:id, :key, :value], Any[[1, "a", 10], [1, "a", 20]])
    @test_throws ArgumentError Morpheus.spread(duplicate_spread, :key, :value)

    empty_grouped = Morpheus.group_by(Morpheus.MorpheusTable([:g, :x], Any[]), Morpheus.cols(:g))
    empty_summary = Morpheus.summarise(empty_grouped, :sum_x, Morpheus.sum_agg(:x))
    @test Morpheus.morpheus_columns(empty_summary) == [:g, :sum_x]
    @test length(empty_summary) == 0

    numeric = Morpheus.MorpheusTable([:x], Any[[2], [10], [1]])
    @test Morpheus.morpheus_data(Morpheus.arrange(numeric, Morpheus.cols(:x)))[1] == [1, 2, 10]

    interp = Morpheus.make_morpheus_interpreter(HerbBenchmarks.get_grammar(Morpheus, "001"))
    rn = expr2rulenode(
        :(spread(
            unite(
                gather(_arg_1, newcol(:tmp1), newcol(:tmp2), not_cols2(col(:round), col(:nam))),
                newcol(:tmp3),
                col(:tmp1),
                col(:round),
            ),
            col(:tmp3),
            col(:tmp2),
        )),
        HerbBenchmarks.get_grammar(Morpheus, "001"),
    )
    @test only(interp(rn, first_problem.spec)) == expected
end
