using HerbGrammar, HerbInterpret


input_gcd = @csgrammar begin
    Int = input1
    Int = input2
    State = Dict(:x => Int, :y => Int)
    Int = Var[:x] | Var[:y]
    Int = Int % Int
    Var = merge!(Var, State)
    Int = get(Var, :x, "key not found")
    Int = let Var = State; Int; Int end
    Bool = Int > Int
    Int = Var -> while Bool; Var end
    output1 = Int
    Int = 0
    Var = state
end

function program_gcd(input1, input2)
    let state = Dict(:x => input1, :y => input2)
        while state[:y] > 0
            merge!(state, Dict(:x => state[:y], :y => state[:x] % state[:y]))
        end
        get(state, :x, "Key not found")
    end
end

rulenode_gcd = begin 
    rulenode2expr(
               RuleNode(9, [
                   RuleNode(14),
                   RuleNode(3, [
                       RuleNode(1)
                       RuleNode(2)
                   ]),
                   RuleNode(11, [
                       RuleNode(14),
                       RuleNode(10, [
                           RuleNode(5, [RuleNode(14)]),
                           RuleNode(13)
                       ]),
                       RuleNode(7, [
                           RuleNode(14),
                           RuleNode(3, [
                               RuleNode(5, [RuleNode(14)]),
                               RuleNode(6, [RuleNode(4, [RuleNode(14)]), RuleNode(5, [RuleNode(14)])])
                           ])
                       ]),
                   ]),RuleNode(8, [
                       RuleNode(14)
                   ])
               ]), input_gcd)
end

# TODO do we want the symbols to be flexible?
# TODO move dict/state rules to a separate base grammar
# TODO let should have flexible number of arguments
input_symbol_gcd = @csgrammar begin
    Int = input1
    Int = input2
    State = Dict(:x => Int, :y => Int)
    Int = Var[:x] | Var[:y]
    Int = Int % Int
    Var = merge(Var, State)
    Int = get(Var, :x, "key not found")
    Expr = begin Int; Expr end | Int
    Int = let Var = State; Expr end
    Bool = Int > Int
    Int = Var -> while Bool; Var end
    output1 = Int
    Int = 0
    Var = state
end


input1 = 32
input2 = 16

println("Builtin eval: ", eval(rulenode_gcd))

# Should be 16
# interpret(SymbolTable(input_gcd), rulenode_gcd)