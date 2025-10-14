using HerbBenchmarks.Abstract_Reasoning_2019
using HerbBenchmarks.Abstract_Reasoning_2019.ARC_Hodel

@testset verbose = true "interpret grid operations" begin
    grammar = grammar_hodel
    prog = @rulenode 7{5}
    grammartags = get_relevant_tags(grammar)

    a = [1 1 1; 1 1 1; 1 1 1]
    res = ARC_Hodel.interpret(prog, grammartags, a)

    @test size(res) == (3, 6)
    @test all(x -> x == 1, res) == true
end