using .Abstract_Reasoning_2019.ARC_Hodel

@testset verbose = true "interpret grid operations" begin
    grammar = grammar_arcdsl
    prog = @rulenode 7{5}
    grammartags = get_relevant_tags(grammar)

    a = [1 1 1; 1 1 1; 1 1 1]
    res = interpret(prog, grammartags, a)

    @test size(res) == (3, 6)
    @test all(x -> x == 1, res) == true
end