@testitem "Morpheus 2017" begin
    import HerbBenchmarks.Morpheus_2017 as Morpheus
    import HerbGrammar: AbstractGrammar

    input_rules(grammar::AbstractGrammar) =
        findall(rule -> occursin("_arg_", string(rule)), grammar.rules)
    grammar_rules(grammar::AbstractGrammar) = string.(grammar.rules)

    pairs = HerbBenchmarks.get_all_problem_grammar_pairs(Morpheus)
    @test length(pairs) == 79
    @test !("033" in Morpheus.morpheus_identifiers())
    @test last(Morpheus.morpheus_identifiers()) == "080"

    first_problem = HerbBenchmarks.get_problem(Morpheus, "001")
    first_example = only(first_problem.spec)
    @test occursin("round var1 var2 nam", first_example.in[:_arg_1].raw)
    @test first_example.in[:_arg_1].columns == [:round, :var1, :var2, :nam, :val]
    @test first_example.in[:_arg_1].data[1] == ["round1", "round2", "round1", "round2"]
    @test first_example.in[:_arg_1].colindex[:round] == 1
    @test Morpheus.morpheus_input_count("001") == 1
    @test first(Morpheus.morpheus_identifiers()) == "001"

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
    @test spaced_example.in[:_arg_1].rows[2] == Any["2012-07-13", 6.0, "Stats Winter school", "R|regression"]
    @test spaced_example.out.rows[2] == Any["2012-07-13", 6.0, "Stats Winter school", "R"]

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

    two_input_problem = HerbBenchmarks.get_problem(Morpheus, "026")
    @test Morpheus.morpheus_input_count("026") == 2
    @test sort(collect(keys(only(two_input_problem.spec).in))) == [:_arg_1, :_arg_2]
    @test length(input_rules(HerbBenchmarks.get_grammar(Morpheus, "026"))) == 2
    @test length(input_rules(HerbBenchmarks.get_grammar(Morpheus, "001"))) == 1
    @test any(occursin("gather", string(rule)) for rule in HerbBenchmarks.get_grammar(Morpheus, "001").rules)
    @test any(occursin("inner_join", string(rule)) for rule in HerbBenchmarks.get_grammar(Morpheus, "026").rules)
end
