using HerbGrammar, HerbInterpret

# Given a vector of positive integers, divide each by 3, round the result down to the nearest integer, and subtract 2. Return the sum of all of the new integers in the vector
input_fuel_cost = @csgrammar begin
    List = input1
    Int = 0 | 1 | 2 | 3
    # Int = rand(6:100000)
    Int = 4
    Float = Int / 3
    Int = floor(Float)
    Int = Int - 2
    Int = sum(List)
    Func = Div | floor | Sub 
    List = map(Func, List)
    Func = x -> Int
    Int = x
    output1 = Int
end


#:(sum(map((x->begin
#                  floor(x / 3) - 2
#              end), input1)))
rulenode_version_fuel_cost = begin
    rulenode2expr(
        RuleNode(10, [
            RuleNode(14, [
                RuleNode(15, [
                    RuleNode(9, [
                        RuleNode(8, [RuleNode(7, [RuleNode(16)])])
                    ])
                ]),
                RuleNode(1)
            ])
        ]
        ),
        input_fuel_cost
    )
end

input1 = [32, 32]

println("Builtin eval: ", eval(rulenode_version_fuel_cost))

# Should be 16
# interpret(SymbolTable(input_fuel_cost), rulenode_version_fuel_cost)