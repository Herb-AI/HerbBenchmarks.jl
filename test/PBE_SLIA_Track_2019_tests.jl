@testitem "PBE SLIA Track 2019" begin
    import HerbBenchmarks.PBE_SLIA_Track_2019 as SLIA
    import HerbGrammar: expr2rulenode
    import HerbCore: @rulenode

    pgp = first(HerbBenchmarks.get_all_problem_grammar_pairs(SLIA))
    g = pgp.grammar
    spec = pgp.problem.spec

    args1 = [s.in[:_arg_1] for s in spec]

    interpret = SLIA.make_SLIA_interpreter(g)

    const_expected(x) = fill(x, length(spec))

    function expected_indexof(str::String, substring::String)
        for (position, byte_index) in enumerate(eachindex(str))
            position == 1 && continue
            startswith(SubString(str, byte_index), substring) && return position - 1
        end
        return -1
    end

    # String typed
    concat_rn = expr2rulenode(:(concat_cvc(_arg_1, "US")), g)
    replace_rn = expr2rulenode(:(replace_cvc(_arg_1, "US", "CAN")), g)
    at_rn = expr2rulenode(:(at_cvc(_arg_1, 1)), g)
    int_to_str_rn = expr2rulenode(:(int_to_str_cvc(1)), g)
    substr_rn = expr2rulenode(:(substr_cvc(_arg_1, 1, 1)), g)

    @test interpret(concat_rn, spec) == [str * "US" for str in args1]
    @test interpret(replace_rn, spec) == [replace(str, "US" => "CAN"; count=1) for str in args1]
    @test interpret(at_rn, spec) == [string(collect(str)[2]) for str in args1]
    @test interpret(int_to_str_rn, spec) == const_expected("1")
    @test interpret(substr_rn, spec) == [string(collect(str)[2]) for str in args1]

    # Int typed
    len_rn = expr2rulenode(:(len_cvc(_arg_1)), g)
    str_to_int_rn = expr2rulenode(:(str_to_int_cvc(int_to_str_cvc(1))), g)
    indexof_us_rn = expr2rulenode(:(indexof_cvc(_arg_1, "US", 1)), g)
    indexof_can_rn = expr2rulenode(:(indexof_cvc(_arg_1, "CAN", 1)), g)

    @test interpret(len_rn, spec) == length.(args1)
    @test interpret(str_to_int_rn, spec) == const_expected(1)
    @test interpret(indexof_us_rn, spec) == [expected_indexof(str, "US") for str in args1]
    @test interpret(indexof_can_rn, spec) == [expected_indexof(str, "CAN") for str in args1]

    # Bool typed
    prefixof_rn = expr2rulenode(:(prefixof_cvc("US", _arg_1)), g)
    suffixof_rn = expr2rulenode(:(suffixof_cvc("US", _arg_1)), g)
    contains_rn = expr2rulenode(:(contains_cvc(_arg_1, "CAN")), g)

    @test interpret(prefixof_rn, spec) == [startswith(str, "US") for str in args1]
    @test interpret(suffixof_rn, spec) == [endswith(str, "US") for str in args1]
    @test interpret(contains_rn, spec) == [contains(str, "CAN") for str in args1]

    # If expressions

    # if contains_cvc(_arg_1, "US")
    #     "US"
    # else
    #     "CAN"
    # end
    if_string_rn = @rulenode 11{27{2,5},5,6}

    # if contains_cvc(_arg_1, "US")
    #     1
    # else
    #     0
    # end
    if_int_rn = @rulenode 20{27{2,5},13,14}

    @test interpret(if_string_rn, spec) ==
        [contains(str, "US") ? "US" : "CAN" for str in args1]

    @test interpret(if_int_rn, spec) ==
        [contains(str, "US") ? 1 : 0 for str in args1]
end

@testitem "SyGuS string operator names" begin
    import HerbBenchmarks.PBE_SLIA_Track_2019 as SLIA

    mktemp() do path, _
        for (production, expected) in (
            ("str.from_int ntInt", "int_to_str_cvc(ntInt)"),
            ("int.to.str ntInt", "int_to_str_cvc(ntInt)"),
            ("str.to_int ntString", "str_to_int_cvc(ntString)"),
            ("str.to.int ntString", "str_to_int_cvc(ntString)"),
            ("str.is_digit ntString", "isdigit_cvc(ntString)"),
            ("str.isdigit ntString", "isdigit_cvc(ntString)"),
            ("str.< ntString ntString", "lt_cvc(ntString, ntString)"),
            ("str.<= ntString ntString", "leq_cvc(ntString, ntString)"),
        )
            write(path, "    Start = ($production)\n")
            SLIA.format_string_grammars(path)
            @test read(path, String) == "    Start = $expected\n"
        end
    end
end

@testitem "SyGuS SMT-LIB string edge cases" begin
    import HerbBenchmarks.PBE_SLIA_Track_2019 as SLIA

    @test SLIA.replace_cvc("ééé", "é", "x") == "xéé"
    @test SLIA.replace_cvc("ééé", "", "x") == "xééé"
    @test SLIA.replace_cvc("ééé", "a", "x") == "ééé"
    @test SLIA.at_cvc("é🙂", 0) == "é"
    @test SLIA.at_cvc("é🙂", 1) == "🙂"
    @test SLIA.at_cvc("é🙂", -1) == SLIA.at_cvc("é🙂", 2) == ""
    @test SLIA.substr_cvc("é🙂a", 1, 1) == "🙂"
    @test SLIA.substr_cvc("é🙂a", 1, typemax(Int)) == "🙂a"
    @test SLIA.substr_cvc("é🙂a", 1, -1) == SLIA.substr_cvc("é🙂a", 1, 0) == ""
    @test SLIA.len_cvc("é🙂a") == 3
    @test SLIA.indexof_cvc("é🙂é🙂", "🙂", 2) == 3
    @test SLIA.indexof_cvc("é🙂é🙂", "é🙂", 0) == 0
    @test SLIA.indexof_cvc("é🙂", "", 2) == 2
    @test SLIA.indexof_cvc("", "", 0) == 0
    @test SLIA.indexof_cvc("é🙂", "é", 2) == -1
    @test SLIA.indexof_cvc("é🙂", "", -1) == SLIA.indexof_cvc("é🙂", "", 3) == -1
    @test SLIA.int_to_str_cvc(-1) == ""
    @test SLIA.int_to_str_cvc(0) == "0"
    @test SLIA.str_to_int_cvc("00042") == 42
    @test SLIA.str_to_int_cvc("000") == 0
    @test SLIA.str_to_int_cvc("100000000000000000000") == big(10)^20
    @test SLIA.int_to_str_cvc(big(10)^20) == "100000000000000000000"
    for str in ("", "-1", "+1", " 1", "1 ", "1_2", "１")
        @test SLIA.str_to_int_cvc(str) == -1
        @test !SLIA.isdigit_cvc(str)
    end
    @test SLIA.isdigit_cvc("0")
    @test !SLIA.isdigit_cvc("12")
end
