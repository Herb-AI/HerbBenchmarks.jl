@testitem "SyGuS-Comp 2019 formal tracks" begin
    import HerbBenchmarks.General_Track_2019 as GT
    import HerbBenchmarks.CLIA_Track_2019 as CT
    import HerbBenchmarks.Inv_Track_2019 as IT
    import HerbBenchmarks.SyGuSComp2019Common as Common
    import HerbCore: AbstractGrammar, RuleNode
    import HerbGrammar: rulenode2expr, expr2rulenode
    import HerbSpecification
    using Random

    modules = [GT, CT, IT]

    @testset "Problem and grammar counts" begin
        # problems: all source .sl files of the three tracks are shipped
        @test length(get_all_identifiers(GT)) == 945
        @test length(get_all_identifiers(CT)) == 88
        @test length(get_all_identifiers(IT)) == 858
        # grammar names: one per problem, plus per-synth-fun grammars
        # `grammar_<id>__<fname>` for the multi-synth-fun problems
        n_grammars(mod) = count(v -> startswith(String(v), "grammar_"), names(mod; all=true))
        @test n_grammars(GT) == 1101
        @test n_grammars(CT) == 155
        @test n_grammars(IT) == 858
    end

    @testset "Problem/grammar pairs ($mod)" for mod in modules
        ids = get_all_identifiers(mod)
        rng = MersenneTwister(42)
        sample = ids[randperm(rng, length(ids))[1:12]]
        for id in sample
            pair = get_problem_grammar_pair(mod, id)
            @test pair.problem isa HerbSpecification.Problem
            @test pair.problem.spec isa HerbSpecification.SMTSpecification
            @test pair.grammar isa AbstractGrammar
            @test get_grammar(mod, id) isa AbstractGrammar
            f = pair.problem.spec.formula
            @test isfile(f.spec_file)
            @test !isempty(f.synth_funs)
        end
    end

    @testset "All grammars are well-formed ($mod)" for mod in modules
        for v in names(mod; all=true)
            startswith(String(v), "grammar_") || continue
            g = getfield(mod, v)
            @test g isa AbstractGrammar
            @test :Start in g.types
        end
    end

    @testset "Grammar spot checks" begin
        # woosuk depth grammar: 9 nonterminals Start, depth7..depth0
        g = GT.grammar_woosuk_sygus_iter_14_1
        @test :depth7 in g.types && :depth0 in g.types
        @test any(r -> r == :(and(depth6, depth6)), g.rules)
        @test any(r -> r == :(xor(depth7, depth7)), g.rules)
        # bv-conditional-inverses grammar: params s/t and BV ops over Start
        g = GT.grammar_bv_conditional_inverses_find_inv_bvsge_bvmul_4bit
        @test any(r -> r == :s, g.rules) && any(r -> r == :t, g.rules)
        @test any(r -> r == :(bvadd(Start, Start)), g.rules)
        @test any(r -> r == 0x0000000000000008, g.rules)
        # multi-synth-fun problems get one grammar per synth-fun
        @test GT.grammar_cegist_cav18_inv_danger_loop40 === GT.grammar_cegist_cav18_inv_danger_loop40__D
        @test isdefined(GT, :grammar_cegist_cav18_inv_danger_loop40__R)
        @test isdefined(GT, :grammar_cegist_cav18_inv_danger_loop40__S)
    end

    @testset "parse_spec_file round-trip on every shipped .sl" begin
        for mod in modules
            specdir = joinpath(dirname(pathof(HerbBenchmarks)), "data", "SyGuS",
                String(nameof(mod)), "specifications")
            @test isdir(specdir)
            n_ok = 0
            for f in readdir(specdir)
                spec = Common.parse_spec_file(joinpath(specdir, f))
                n_ok += !isempty(spec.constraints) && !isempty(spec.synth_funs)
            end
            @test n_ok == length(get_all_identifiers(mod))
        end
    end

    @testset "expr_to_smt from hand-built rule nodes" begin
        # (HerbSearch is not a test dependency, so instead of enumerating we
        # build rule nodes by hand and run them through the expr -> SMT path.)
        g = CT.grammar_from_2018_jmbl_fg_max2
        rn = expr2rulenode(:(ite(x < y, y, x)), g)
        @test rn isa RuleNode
        expr = rulenode2expr(rn, g)
        @test Common.expr_to_smt(expr) == "(ite (< x y) y x)"
        rn2 = expr2rulenode(:(eq(x, 1)), g)
        @test Common.expr_to_smt(rulenode2expr(rn2, g)) == "(= x 1)"
        # BV grammar: hex literals print at the problem's width via nt_sorts
        gbv = GT.grammar_bv_conditional_inverses_find_inv_bvsge_bvmul_4bit
        nts = GT.problem_bv_conditional_inverses_find_inv_bvsge_bvmul_4bit.spec.formula.nt_sorts
        rn3 = expr2rulenode(:(bvadd(s, 0x0000000000000008)), gbv)
        @test Common.expr_to_smt(rulenode2expr(rn3, gbv); nt_sorts=nts) == "(bvadd s #x8)"
    end

    if Sys.which("z3") === nothing
        @warn "z3 binary not found on PATH — skipping the z3 end-to-end tests"
    else
        @testset "z3 end-to-end: CLIA" begin
            spec = CT.problem_from_2018_jmbl_fg_max2.spec.formula
            res = Common.check_program(spec, :x)           # max2(x, y) = x
            @test res.verified == false
            @test res.counterexample isa Dict{Symbol,Any}
            @test haskey(res.counterexample, :x) && haskey(res.counterexample, :y)
            clauses = Common.check_clauses(spec, :x)
            @test clauses isa Vector{Bool}
            @test length(clauses) == spec.n_constraints == 3
            @test clauses == [true, false, true]           # x >= x holds, x >= y does not
            @test Common.check_program(spec, :(ite(x < y, y, x))).verified == true
        end

        @testset "z3 end-to-end: General woosuk" begin
            spec = GT.problem_woosuk_sygus_iter_14_1.spec.formula
            # candidate = the origCir body in the grammar's call syntax
            ref = :(not(and(and(not(and(n136, n129)), n89), n158)))
            @test Common.check_program(spec, ref).verified == true
            res = Common.check_program(spec, true)
            @test res.verified == false
            @test res.counterexample isa Dict{Symbol,Any}
        end

        @testset "z3 end-to-end: General from_2018 BV" begin
            spec = GT.problem_from_2018_icfp_105_1000.spec.formula
            res = Common.check_program(spec, :x)           # identity candidate
            @test res.verified isa Bool
            if !res.verified                               # BV model values parse as UInt64
                @test all(v isa UInt64 for v in values(res.counterexample))
            end
        end

        @testset "z3 end-to-end: Inv" begin
            spec = IT.problem_From2018_brett.spec.formula
            res = Common.check_program(spec, true)
            @test res.verified isa Bool
            clauses = Common.check_clauses(spec, false)    # pre => false must fail
            @test length(clauses) == 3
            @test clauses[1] == false
        end

        @testset "z3 end-to-end: multi-synth-fun (cegist)" begin
            spec = GT.problem_cegist_cav18_inv_danger_loop40.spec.formula
            @test length(spec.synth_funs) == 3
            res = Common.check_program(spec,
                Dict{Symbol,Any}(:D => true, :R => :x, :S => :y))
            @test res.verified isa Bool
            @test res.verified == false                    # trivial candidates violate the spec
        end
    end
end
