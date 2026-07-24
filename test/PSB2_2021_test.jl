@testitem "PSB2_2021 grammars" begin
    import HerbBenchmarks: PSB2_2021
    import HerbBenchmarks.PSB2_2021: PSB2_NONTERMINALS, _mentioned_types

    identifiers = get_all_identifiers(PSB2_2021)
    @test length(identifiers) == 25

    @testset "$id" for id in identifiers
        grammar = get_grammar(PSB2_2021, id)
        problem = get_problem(PSB2_2021, id)

        @test !isempty(grammar.rules)
        @test haskey(grammar.bytype, :Return)
        @test length(problem.spec) >= 10

        @testset "every non-terminal can be expanded" begin
            # A rule with a non-terminal that has no production can never be
            # completed into a program. That includes non-terminals that are
            # *not* a type of this grammar: those parse as a variable and would
            # throw an UndefVarError when the program is run.
            for rule in grammar.rules
                for type in _mentioned_types(rule, PSB2_NONTERMINALS)
                    @test haskey(grammar.bytype, type)
                end
            end
        end

        @testset "inputs of the grammar are the inputs of the problem" begin
            arguments = Set(keys(problem.spec[1].in))
            input_rules = Set(filter(r -> occursin("_arg_", string(r)), grammar.rules))
            @test input_rules == arguments
            # All examples of a problem have the same inputs
            @test all(Set(keys(example.in)) == arguments for example in problem.spec)
        end
    end
end

@testitem "PSB2_2021 example solutions" begin
    import HerbBenchmarks: PSB2_2021
    import HerbBenchmarks.PSB2_2021: PSB2_SOLUTIONS, PSB2_MINIMAL_SOLUTIONS,
        make_psb2_interpreter, get_interpreter
    import HerbGrammar: rulenode2expr

    @testset "$id" for (id, solution) in PSB2_SOLUTIONS
        problem = get_problem(PSB2_2021, id)
        grammar = get_grammar(PSB2_2021, id)

        @testset "solution of the full grammar solves every example" begin
            interpreter = get_interpreter(id)
            @test all(interpreter(solution, copy(example.in)) == example.out
                      for example in problem.spec)
        end

        @testset "solution of the minimal grammar solves every example" begin
            minimal_grammar = getfield(PSB2_2021, Symbol("get_grammar_" * id))(minimal=true)
            interpreter = make_psb2_interpreter(minimal_grammar)
            minimal_solution = PSB2_MINIMAL_SOLUTIONS[id]
            @test all(interpreter(minimal_solution, copy(example.in)) == example.out
                      for example in problem.spec)
        end

        @testset "the Julia reference program solves every example" begin
            program = getfield(PSB2_2021, Symbol("program_" * id))
            @test all(program([example.in[Symbol("_arg_$i")] for i in 1:length(example.in)]...) == example.out
                      for example in problem.spec)
        end

        @testset "the rule node is the example expression" begin
            expression = getfield(PSB2_2021, Symbol("expression_" * id))
            @test rulenode2expr(solution, grammar) == Base.remove_linenums!(deepcopy(expression))
        end
    end

    @testset "interpreters are cached per problem" begin
        @test get_interpreter("gcd") === get_interpreter("gcd")
        @test_throws KeyError get_interpreter("not_a_problem")
    end
end

@testitem "PSB2_2021 primitives" begin
    import HerbBenchmarks: PSB2_2021
    import HerbBenchmarks.PSB2_2021 as P
    import HerbGrammar: @csgrammar, rulenode2expr
    import HerbCore: RuleNode

    @testset "arithmetic is total" begin
        @test P.safe_div(7, 2) == 3
        @test P.safe_div(-7, 2) == -4      # floors, as the PSB2 fuel cost does
        @test P.safe_div(1, 0) == 0
        @test P.safe_mod(7, 3) == 1
        @test P.safe_mod(1, 0) == 0
        @test P.safe_pow(2, 10) == 1024
        @test P.safe_pow(2, -1) == 0
        @test P.safe_pow(2, 10^6) == 2^32  # the exponent is capped, no overflow
        @test P.safe_fdiv(1, 0) == 0.0
        @test P.safe_sqrt(-4) == 2.0
        @test P.safe_log(0) == 0.0
    end

    @testset "conversions never throw" begin
        @test P.to_int("12") == 12
        @test P.to_int("twelve") == 0
        @test P.to_int(2.7) == 2
        @test P.to_int(true) == 1
        @test P.to_float("no number") == 0.0
        @test P.to_bool(0) == false
        @test P.to_bool("") == false
        @test P.to_bool("x") == true
    end

    @testset "list and string access is clamped" begin
        @test P.sublist([1, 2, 3], 2, 10) == [2, 3]
        @test P.sublist([1, 2, 3], -5, 0) == []
        @test P.list_ref([1, 2, 3], 9) == 0
        @test P.list_first([], 7) == 7
        @test P.substring("herb", 2, 100) == "erb"
        @test P.char_at("herb", 99) == ' '
        @test P.replace_in_string("test101", 4, 'T') == "tesT101"
        @test P.replace_in_string("test", 99, 'T') == "test"
        @test P.str_count("aaaa", "aa") == 3      # counts overlapping matches
        @test P.str_index_of("herb", "rb") == 3
        @test P.str_index_of("herb", "xy") == 0
        @test P.range_list(1, 4) == [1, 2, 3, 4]
        @test P.range_list(4, 1) == []
    end

    @testset "lambda variables" begin
        P.clear_vars!()
        @test P.int_var(:x) == 0          # unbound variables read as neutral
        @test P.string_var(:x) == ""
        @test P.list_var(:x) == []
        P.bind_var!(:x, 3)
        @test P.int_var(:x) == 3
        @test P.float_var(:x) == 3.0
        @test P.string_var(:x) == "3"     # converted, never a type error
        @test P.list_var(:x) == []
        P.clear_vars!()
    end

    @testset "while_loop terminates" begin
        @test P.while_loop(0, s -> s < 5, s -> s + 1) == 5
        @test P.while_loop(0, s -> true, s -> s + 1) == 1000   # bounded
        @test P.while_loop(0, s -> false, s -> s + 1) == 0
    end

    @testset "merge_grammar" begin
        g1 = @csgrammar begin
            Rule = 1
            Rule = Rule + Rule
        end
        g2 = @csgrammar begin
            Rule = 2
        end
        g3 = @csgrammar begin
            Rule = 1
        end
        merged = P.merge_grammar([g1, g2, g3])
        @test length(merged.rules) == 3      # the duplicate `Rule = 1` is dropped
        @test eval(rulenode2expr(RuleNode(2, [RuleNode(1), RuleNode(3)]), merged)) == 3
    end

    @testset "prune_grammar" begin
        g = @csgrammar begin
            Return = IntRule
            IntRule = 1
            IntRule = IntRule + IntRule
            IntRule = to_int(Float)          # Float has no productions
            Boolean = true                   # not reachable from Return
        end
        pruned = P.prune_grammar(g, :Return; known_types=P.PSB2_NONTERMINALS)
        @test length(pruned.rules) == 3
        @test !haskey(pruned.bytype, :Boolean)
        @test all(!occursin("Float", string(r)) for r in pruned.rules)
    end

    @testset "rule_index and expr_to_rulenode" begin
        grammar = get_grammar(PSB2_2021, "coin_sums")
        index = P.rule_index(grammar, :(safe_mod(IntRule, IntRule)))
        @test grammar.rules[index] == :(safe_mod(IntRule, IntRule))
        @test_throws ArgumentError P.rule_index(grammar, :(no_such_function(IntRule)))

        node = P.expr_to_rulenode(grammar, :IntRule, :(safe_mod(_arg_1, 25)))
        @test rulenode2expr(node, grammar) == :(safe_mod(_arg_1, 25))
        # A program outside the grammar is rejected, which is what makes
        # `expr_to_rulenode` a check that a solution is in the grammar.
        @test_throws ArgumentError P.expr_to_rulenode(grammar, :IntRule, :(sqrt(_arg_1)))
    end
end

@testitem "PSB2_2021 search with BFS and make_interpreter" begin
    import HerbBenchmarks: PSB2_2021
    import HerbBenchmarks.PSB2_2021: make_psb2_interpreter, PSB2_SOLUTIONS
    import HerbSearch: BFSIterator
    import HerbConstraints: freeze_state
    import HerbSpecification: IOExample
    import HerbGrammar: rulenode2expr

    """
    Enumerate at most `budget` programs of `iterator`, evaluating each of them
    with `interpreter` on `examples`. Returns the best program, the number of
    examples it solves, and the errors thrown along the way.
    """
    function search(iterator, grammar, interpreter, examples; budget=1000)
        best, best_score, enumerated = nothing, -1, 0
        errors = []
        for candidate in iterator
            enumerated += 1
            enumerated > budget && break
            program = freeze_state(candidate)
            score = 0
            for example in examples
                try
                    interpreter(program, copy(example.in)) == example.out && (score += 1)
                catch e
                    push!(errors, (rulenode2expr(program, grammar), e))
                    break
                end
            end
            if score > best_score
                best, best_score = program, score
            end
        end
        return (program=best, score=best_score, enumerated=enumerated, errors=errors)
    end

    @testset "BFS finds a sub-program of the coin sums solution" begin
        # The complete solutions are far too deep for breadth first search, so
        # this searches for a part of one: the cents not covered by quarters.
        grammar = PSB2_2021.get_grammar_coin_sums(minimal=true)
        interpreter = make_psb2_interpreter(grammar)
        examples = [IOExample(Dict{Symbol,Any}(:_arg_1 => n), n % 25) for n in [1, 26, 60, 99, 137]]

        result = search(BFSIterator(grammar, :IntRule, max_depth=3), grammar, interpreter,
            examples; budget=5000)
        @test result.score == length(examples)
        @test rulenode2expr(result.program, grammar) == :(safe_mod(_arg_1, 25))
        @test isempty(result.errors)
    end

    @testset "enumerating the minimal grammar of $id never throws" for id in keys(PSB2_SOLUTIONS)
        grammar = getfield(PSB2_2021, Symbol("get_grammar_" * id))(minimal=true)
        problem = get_problem(PSB2_2021, id)
        interpreter = make_psb2_interpreter(grammar)

        result = search(BFSIterator(grammar, :Return, max_depth=4), grammar, interpreter,
            problem.spec; budget=500)
        @test result.enumerated > 1
        @test result.score >= 0
        # Every program of a grammar has to evaluate to something: the
        # primitives are total, so a search can score any candidate it
        # generates instead of having to handle exceptions.
        @test isempty(result.errors)
    end

    @testset "enumerating the grammar of $id never throws" for id in get_all_identifiers(PSB2_2021)
        grammar = get_grammar(PSB2_2021, id)
        problem = get_problem(PSB2_2021, id)
        interpreter = make_psb2_interpreter(grammar)

        result = search(BFSIterator(grammar, :Return, max_depth=3), grammar, interpreter,
            problem.spec[1:min(5, end)]; budget=200)
        @test result.enumerated > 1
        @test isempty(result.errors)
    end
end
