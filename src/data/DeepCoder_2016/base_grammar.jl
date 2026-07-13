base_grammar_deepcoder = @csgrammar begin
    Int = |(-3:3)

    ExprNum = Int

    ExprNum = maximum(ExprArr)              := (maximum(y) == maximum(x1), minimum(y) >= minimum(x1))
    ExprNum = minimum(ExprArr)              := (maximum(y) <= maximum(x1), minimum(y) == minimum(x1))
    ExprNum = sum(ExprArr)                  := (maximum(y) <= length(x1) * maximum(x1), minimum(y) >= length(x1) * minimum(x1))
    ExprNum = first(ExprArr)                := (maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == first(x1), last(y) == first(x1))
    ExprNum = last(ExprArr)                 := (maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == last(x1), last(y) == last(x1))
    ExprNum = getindex(ExprArr, ExprNum)    := (maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))

    ExprNum = countSt(ExprArr, Int)         := (y <= length(x1))
    ExprNum = countGt(ExprArr, Int)         := (y <= length(x1))
    ExprNum = countEq(ExprArr, Int)         := (y <= length(x1))
    ExprNum = countNeq(ExprArr, Int)        := (y <= length(x1))
    ExprNum = countMod(ExprArr, Int)        := (y <= length(x1))
    ExprNum = countNmod(ExprArr, Int)       := (y <= length(x1))

    ExprArr = drop(ExprArr, ExprNum)        := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), last(y) == last(x1))
    ExprArr = take(ExprArr, ExprNum)        := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == first(x1))
    ExprArr = sort(ExprArr)                 := (length(y) == length(x1), maximum(y) == maximum(x1), minimum(y) == minimum(x1), first(y) == minimum(x1), last(y) == maximum(x1))
    ExprArr = reverse(ExprArr)              := (length(y) == length(x1), maximum(y) == maximum(x1), minimum(y) == minimum(x1), first(y) == last(x1), last(y) == first(x1))

    ExprArr = filterSt(ExprArr, Int)        := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))
    ExprArr = filterGt(ExprArr, Int)        := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))
    ExprArr = filterEq(ExprArr, Int)        := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))
    ExprArr = filterNeq(ExprArr, Int)       := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))
    ExprArr = filterMod(ExprArr, Int)       := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))
    ExprArr = filterNmod(ExprArr, Int)      := (length(y) < length(x1), maximum(y) <= maximum(x1), minimum(y) >= minimum(x1))

    ExprArr = mapPlus(ExprArr, Int)         := (length(y) == length(x1))
    ExprArr = mapMult(ExprArr, Int)         := (length(y) == length(x1))
    ExprArr = mapDiv(ExprArr, Int)          := (length(y) == length(x1))
    ExprArr = mapPow(ExprArr, Int)          := (length(y) == length(x1))

    ExprArr = zipwithMax(ExprArr, ExprArr)      := (length(y) == length(x1), length(y) == length(x2))
    ExprArr = zipwithMin(ExprArr, ExprArr)      := (length(y) == length(x1), length(y) == length(x2))
    ExprArr = zipwithPlus(ExprArr, ExprArr)     := (length(y) == length(x1), length(y) == length(x2))
    ExprArr = zipwithMinus(ExprArr, ExprArr)    := (length(y) == length(x1), length(y) == length(x2))
    ExprArr = zipwithMult(ExprArr, ExprArr)     := (length(y) == length(x1), length(y) == length(x2))

    ExprArr = scanl1Plus(ExprArr)           := (length(y) == length(x1), first(y) == first(x1))
    ExprArr = scanl1Minus(ExprArr)          := (length(y) == length(x1), first(y) == first(x1))
    ExprArr = scanl1Mult(ExprArr)           := (length(y) == length(x1), first(y) == first(x1))
    ExprArr = scanl1Max(ExprArr)            := (length(y) == length(x1), first(y) == first(x1), maximum(y) == maximum(x1), minimum(y) >= minimum(x1), last(y) == maximum(x1))
    ExprArr = scanl1Min(ExprArr)            := (length(y) == length(x1), first(y) == first(x1), maximum(y) <= maximum(x1), minimum(y) == minimum(x1), last(y) == minimum(x1))
end