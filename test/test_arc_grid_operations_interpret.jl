@testset verbose = true "interpret grid operations" begin
    grammar = ARC_DSL.grammar_arcdsl
    prog = @rulenode 7{5}
    grammartags = ARC_DSL.get_relevant_tags(grammar)

    a = [1 1 1; 1 1 1; 1 1 1]
    res = ARC_DSL.interpret(prog, grammartags, a)

    @test size(res) == (3, 6)
    @test all(x -> x == 1, res) == true
end