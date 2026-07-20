@testitem "SyGuS generator" begin
    using HerbCore: AbstractGrammar
    using HerbGrammar
    using HerbBenchmarks: sanitize_name

    include(joinpath(@__DIR__, "..", "gen", "sygus_artifacts.jl"))

    const EXAMPLES = joinpath(@__DIR__, "example_sygus_files")
    const SLIA_FILE = joinpath(EXAMPLES, "euphony_11604909.sl")
    const BV_FILE = joinpath(EXAMPLES, "if0_70_1000.sl")

    @testset "sanitize_name strips only the extension" begin
        # `split(file, '.')[1]` truncated `PRE_icfp_gen_1.15.sl` to `PRE_icfp_gen_1`, collapsing 20
        # distinct problems onto one name and unpairing them from their grammars.
        @test sanitize_name(first(splitext("PRE_icfp_gen_1.15.sl"))) == "PRE_icfp_gen_1_15"
        @test sanitize_name(first(splitext("PRE_100_10.sl"))) == "PRE_100_10"
        @test sanitize_name(first(splitext("phone-5-short.sl"))) == "phone_5_short"

        # Problems and grammars are paired by exact equality on this, so both writers must agree.
        @test sanitize_name("a-b.c=d e") == "a_b_c_d_e"
        @test sanitize_name(sanitize_name("a-b.c")) == sanitize_name("a-b.c")
    end

    @testset "operators in head position parse" begin
        # `polish_function_calls` rendered `(= ntInt ntInt)` as the string "=(ntInt, ntInt)" and gave
        # it to Meta.parse, which threw ParseError on 101 of the 210 SLIA files.
        grammar = SyGuS.parse_sygus_grammar(SLIA_FILE)
        @test grammar isa AbstractGrammar
        @test any(r -> r isa Expr && r.head == :call && r.args[1] === Symbol("="), grammar.rules)
        @test any(r -> r isa Expr && r.head == :call && r.args[1] === Symbol("str.++"), grammar.rules)
    end

    @testset "parameters are read off the synth-fun signature" begin
        # The declared name differs per track (`x` for BV, `_arg_0` for SLIA) and must line up with
        # the `_arg_1`-based names parse_example_constraint gives the inputs.
        for file in (SLIA_FILE, BV_FILE)
            sexpr = first(filter(e -> e.car == Symbol("synth-fun"),
                                 collect(HerbBenchmarks.SExpressionParser.parsefile(file))))
            @test collect(values(SyGuS.synth_fun_argmap(sexpr))) == [:_arg_1]
        end
        @test !any(r -> r === :x, SyGuS.parse_sygus_grammar(BV_FILE).rules)
        @test any(r -> r === :_arg_1, SyGuS.parse_sygus_grammar(BV_FILE).rules)
    end

    @testset "sygus_value converts SMT-LIB literals" begin
        # BV inputs are 64-bit; anything lossy here corrupts the data silently.
        @test SyGuS.sygus_value(Symbol("#xb3cac86be739e234")) === 0xb3cac86be739e234
        @test SyGuS.sygus_value(Symbol("#xb3cac86be739e234")) isa UInt64
        @test SyGuS.sygus_value(Symbol("#b1010")) === UInt64(10)
        @test SyGuS.sygus_value(Symbol("true")) === true
        @test SyGuS.sygus_value(Symbol("2")) === 2
        @test SyGuS.sygus_value("a string") == "a string"
        @test SyGuS.sygus_value(:ntString) === :ntString
    end

    @testset "translate_rule renames operators" begin
        @test translate_rule(Expr(:call, :bvnot, :Start), BV_FUNCTIONS) ==
              Expr(:call, :bvnot_cvc, :Start)
        # if0_cvc exists in bit_functions.jl but `if0` was missing from the legacy rewriter's map,
        # so regenerating with it emitted calls to an undefined `if0`.
        @test haskey(BV_FUNCTIONS, :if0)
        @test translate_rule(Expr(:call, :if0, :Start, :Start, :Start), BV_FUNCTIONS) ==
              Expr(:call, :if0_cvc, :Start, :Start, :Start)
        # ite is a conditional, not a call
        @test translate_rule(Expr(:call, :ite, :ntBool, :ntInt, :ntInt), SLIA_FUNCTIONS) ==
              Expr(:if, :ntBool, :ntInt, :ntInt)
        @test translate_rule(Expr(:call, Symbol("="), :ntInt, :ntInt), SLIA_FUNCTIONS) ==
              Expr(:call, :(==), :ntInt, :ntInt)
    end

    @testset "render_rule emits ternaries, not if-blocks" begin
        # `string(Expr(:if, ...))` renders a multi-line `if ... end`, which re-parses to
        # Expr(:if, cond, Expr(:block, ...), Expr(:block, ...)) — block-wrapped, and so not == to the
        # ternary AST, despite printing identically.
        rendered = render_rule(Expr(:if, :ntBool, :ntString, :ntString))
        @test !occursin("\n", rendered)
        @test rendered == "ntBool ? ntString : ntString"
        @test Meta.parse(rendered) == Expr(:if, :ntBool, :ntString, :ntString)
        @test render_rule(0x000000000000000a) == "0x000000000000000a"
        @test render_rule("") == "\"\""
    end

    @testset "generated grammar round-trips" begin
        parsed = SyGuS.parse_sygus_grammar(SLIA_FILE)
        rebuilt = include_string(@__MODULE__, grammar_source(parsed, SLIA_FUNCTIONS))
        @test rebuilt.types == parsed.types
        @test any(r -> r == Expr(:if, :ntBool, :ntString, :ntString), rebuilt.rules)
        @test any(r -> r == Expr(:call, :concat_cvc, :ntString, :ntString), rebuilt.rules)
        @test !any(r -> r isa Expr && r.head == :if && any(a -> a isa Expr && a.head == :block, r.args),
                   rebuilt.rules)
    end

    @testset "generated problem round-trips exactly" begin
        problem = SyGuS.parse_sygus_problem(BV_FILE)
        rebuilt = include_string(@__MODULE__, problem_source("if0_70_1000", problem))
        @test rebuilt.spec == problem.spec
        @test rebuilt.name == "problem_if0_70_1000"
        @test all(v -> v isa UInt64, (v for e in rebuilt.spec for v in values(e.in)))
    end

    @testset "resolve_identifiers qualifies collisions" begin
        # euphony/phone-5-short.sl and from_2018/phone-5_short.sl differ only by a hyphen versus an
        # underscore; both sanitize to phone_5_short. They are different problems, and appending both
        # to one data.jl silently kept only the last.
        mktempdir() do root
            a = joinpath(root, "euphony"); b = joinpath(root, "from_2018")
            mkpath(a); mkpath(b)
            write(joinpath(a, "phone-5-short.sl"), "")
            write(joinpath(b, "phone-5_short.sl"), "")
            write(joinpath(a, "unique.sl"), "")

            resolved = Dict(basename(p) * "@" * basename(dirname(p)) => id
                            for (p, id) in resolve_identifiers([a, b]))
            @test resolved["phone-5-short.sl@euphony"] == "euphony_phone_5_short"
            @test resolved["phone-5_short.sl@from_2018"] == "from_2018_phone_5_short"
            # non-colliding identifiers are left alone
            @test resolved["unique.sl@euphony"] == "unique"
        end
    end
end
