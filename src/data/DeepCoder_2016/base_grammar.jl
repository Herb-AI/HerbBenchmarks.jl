base_grammar_deepcoder = @csgrammar begin
    Int = |(-3:3)

    UnopInt = UnopPlus1 | UnopPlus2 | UnopMult1 | UnopMult2 | UnopMult3 | UnopMult4 | UnopDiv1 | UnopDiv2 | UnopDiv3 | UnopPow
    UnopBool = UnopBool1 | UnopBool2 | UnopBool3 | UnopBool4 | UnopBool5 | UnopBool6 | UnopBool7 | UnopBool8 | UnopBool9
    Binop = BinopPlus | BinopMinus | BinopMult | BinopMax | BinopMin

    ExprNum = Int

    ExprNum = maximum(ExprArr)
    ExprNum = minimum(ExprArr)
    ExprNum = sum(ExprArr)
    ExprNum = first(ExprArr)
    ExprNum = last(ExprArr)
    ExprNum = getindex(ExprArr, ExprNum)
    ExprNum = count(UnopBool, ExprArr)

    ExprArr = drop(ExprArr, ExprNum)
    ExprArr = take(ExprArr, ExprNum)
    ExprArr = sort(ExprArr)
    ExprArr = reverse(ExprArr)

    ExprArr = filter(UnopBool, ExprArr)

    ExprArr = map(UnopInt, ExprArr)

    ExprArr = zipwith(Binop, ExprArr, ExprArr)

    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
end
