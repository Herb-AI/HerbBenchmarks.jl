@testitem "Hacker's Delight: SMT-LIB primitive semantics" begin
    import HerbBenchmarks.PBE_BV_Track_2018.Hackers_Delight as HD

    ones = typemax(UInt64)
    minint = 0x8000000000000000        # typemin(Int64)

    # division and remainder are total in SMT-LIB
    @test HD.bvudiv(0x000000000000002a, 0x0000000000000000) === ones
    @test HD.bvudiv(0x0000000000000000, 0x0000000000000000) === ones
    @test HD.bvurem(0x000000000000002a, 0x0000000000000000) === 0x000000000000002a
    @test HD.bvsdiv(0x000000000000002a, 0x0000000000000000) === ones            #  42 / 0 == -1
    @test HD.bvsdiv(ones, 0x0000000000000000) === 0x0000000000000001            #  -1 / 0 ==  1
    @test HD.bvsrem(ones, 0x0000000000000000) === ones
    # typemin / -1 wraps instead of overflowing
    @test HD.bvsdiv(minint, ones) === minint
    @test HD.bvsrem(minint, ones) === 0x0000000000000000

    # signed division truncates towards zero, the remainder follows the dividend
    @test HD.bvsdiv(reinterpret(UInt64, Int64(-7)), 0x0000000000000002) === reinterpret(UInt64, Int64(-3))
    @test HD.bvsrem(reinterpret(UInt64, Int64(-7)), 0x0000000000000002) === reinterpret(UInt64, Int64(-1))
    @test HD.bvsrem(0x0000000000000007, reinterpret(UInt64, Int64(-2))) === 0x0000000000000001
    # bvsmod follows the divisor instead
    @test HD.bvsmod(reinterpret(UInt64, Int64(-7)), 0x0000000000000002) === 0x0000000000000001

    # shift distances are bit-vectors; >= 64 shifts everything out
    @test HD.bvshl(0x0000000000000001, 0x0000000000000040) === 0x0000000000000000
    @test HD.bvlshr(ones, 0x00000000000000ff) === 0x0000000000000000
    @test HD.bvashr(ones, 0x0000000000000040) === ones                 # negative -> all ones
    @test HD.bvashr(0x7fffffffffffffff, 0x0000000000000040) === 0x0000000000000000

    # bvashr is arithmetic; Julia's `>>` on a UInt64 would be logical
    @test HD.bvashr(minint, 0x0000000000000001) === 0xc000000000000000
    @test HD.bvlshr(minint, 0x0000000000000001) === 0x4000000000000000

    # signed vs unsigned comparison
    @test HD.bvult(0x0000000000000001, ones)
    @test HD.bvslt(ones, 0x0000000000000001)
    @test HD.bvsle(minint, 0x0000000000000000)
    @test !HD.bvule(ones, 0x0000000000000001)

    @test HD.bvneg(0x0000000000000000) === 0x0000000000000000
    @test HD.bvneg(minint) === minint
    @test HD.bvredor(0x0000000000000000) === false
    @test HD.bvredor(minint) === true
    @test HD.ite(true, 0x0000000000000001, 0x0000000000000002) === 0x0000000000000001
end

@testitem "Hacker's Delight: problems, grammars and reference implementations" begin
    import HerbBenchmarks.PBE_BV_Track_2018.Hackers_Delight as HD

    @test HerbBenchmarks.get_all_identifiers(HD) == HD.HD_IDENTIFIERS
    @test length(HerbBenchmarks.get_benchmark(HD).problem_grammar_pairs) == 27

    bool_problems = ["hd_10", "hd_11", "hd_12", "hd_18"]
    for id in HD.HD_IDENTIFIERS
        pgp = HerbBenchmarks.get_problem_grammar_pair(HD, id)
        spec = pgp.problem.spec
        @test length(spec) == 10
        @test length(unique(ex.in for ex in spec)) == 10     # no duplicate inputs

        # the recorded outputs are exactly what the original `define-fun` produces
        f = HD.solution(id)
        for ex in spec
            args = [ex.in[Symbol("_arg_$i")] for i in 1:length(ex.in)]
            @test f(args...) == ex.out
        end

        # every grammar has both sorts, `Start` first
        @test pgp.grammar.types[1] == :Start
        @test length(unique(pgp.grammar.types)) == 2
        @test all(o -> o isa (id in bool_problems ? Bool : UInt64), (ex.out for ex in spec))
    end

    # both truth values occur for the predicate problems
    for id in bool_problems
        outs = Set(ex.out for ex in HerbBenchmarks.get_problem(HD, id).spec)
        @test outs == Set([true, false])
    end
end

@testitem "Hacker's Delight: grammar + interpreter reproduce a reference program" begin
    import HerbCore: RuleNode
    import HerbGrammar: expr2rulenode
    import HerbBenchmarks.PBE_BV_Track_2018.Hackers_Delight as HD

    # hd-01: (bvand x (bvsub x #x0000000000000001))
    g = HD.grammar_hd_01
    interpret = HD.make_hd_interpreter(g)
    rn = expr2rulenode(:(bvand(_arg_1, bvsub(_arg_1, 0x0000000000000001))), g)
    @test all(interpret(rn, ex) == ex.out for ex in HD.problem_hd_01.spec)

    # hd-18 exercises the Bool sort and the mixed-sort grammar:
    # (and (not (bvredor (bvand (bvsub x #x1) x))) (bvredor x))
    g18 = HD.grammar_hd_18
    interpret18 = HD.make_hd_interpreter(g18)
    rn18 = expr2rulenode(
        :(booland(boolnot(bvredor(bvand(bvsub(_arg_1, 0x0000000000000001), _arg_1))),
                  bvredor(_arg_1))), g18)
    @test all(interpret18(rn18, ex) == ex.out for ex in HD.problem_hd_18.spec)

    # hd-27 is signed min, and the grammar's `ite`/comparison rules type-check
    g27 = HD.grammar_hd_27
    interpret27 = HD.make_hd_interpreter(g27)
    rn27 = expr2rulenode(:(ite(bvslt(_arg_1, _arg_2), _arg_1, _arg_2)), g27)
    @test all(interpret27(rn27, ex) == ex.out for ex in HD.problem_hd_27.spec)
end
