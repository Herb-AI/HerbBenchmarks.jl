grammar_000 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_001 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_002 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_003 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_004 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_005 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_006 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_007 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_008 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_009 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_010 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_011 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_012 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_013 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_014 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_015 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_016 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_017 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_018 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_019 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_020 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprNum = :_arg_1
    ExprArr = :_arg_2
end

grammar_021 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_022 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_023 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_024 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_025 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_026 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_027 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_028 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_029 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_030 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_031 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_032 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_033 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_034 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_035 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_036 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_037 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_038 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_039 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_040 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_041 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_042 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_043 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_044 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_045 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_046 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_047 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_048 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_049 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_050 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_051 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprNum = :_arg_2
end

grammar_052 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_053 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_054 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_055 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_056 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_057 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_058 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_059 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_060 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprNum = :_arg_1
    ExprArr = :_arg_2
end

grammar_061 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_062 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprNum = :_arg_2
end

grammar_063 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_064 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_065 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_066 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_067 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_068 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_069 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_070 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_071 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_072 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_073 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_074 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_075 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_076 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_077 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_078 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_079 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_080 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_081 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_082 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_083 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_084 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_085 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_086 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprNum = :_arg_1
    ExprArr = :_arg_2
end

grammar_087 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_088 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_089 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprNum = :_arg_2
end

grammar_090 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_091 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_092 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprNum = :_arg_1
    ExprArr = :_arg_2
end

grammar_093 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
end

grammar_094 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
end

grammar_095 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_096 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_097 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_098 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprArr
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end

grammar_099 = @csgrammar begin
    Int = -3
    Int = -2
    Int = -1
    Int = 0
    Int = 1
    Int = 2
    Int = 3
    UnopPlus = x -> begin
        x + 1
    end
    UnopPlus = x -> begin
        x - 1
    end
    UnopMult = x -> begin
        x * 2
    end
    UnopMult = x -> begin
        x * -1
    end
    UnopMult = x -> begin
        x * 3
    end
    UnopMult = x -> begin
        x * 4
    end
    UnopDiv = x -> begin
        x / 2
    end
    UnopDiv = x -> begin
        x / 3
    end
    UnopDiv = x -> begin
        x / 4
    end
    UnopPow = x -> begin
        x^2
    end
    UnopBool = x -> begin
        x > 0
    end
    UnopBool = x -> begin
        x < 0
    end
    UnopBool = x -> begin
        x % 2 == 0
    end
    UnopBool = x -> begin
        x % 2 == 1
    end
    UnopBool = x -> begin
        x < Int
    end
    UnopBool = x -> begin
        x > Int
    end
    UnopBool = x -> begin
        x == Int
    end
    UnopBool = x -> begin
        x != Int
    end
    UnopBool = x -> begin
        x %= Int
    end
    BinopPlus = (x, y) -> begin
        x + y
    end
    BinopMinus = (x, y) -> begin
        x - y
    end
    BinopMult = (x, y) -> begin
        x * y
    end
    BinopMax = (x, y) -> begin
        max(x, y)
    end
    BinopMin = (x, y) -> begin
        min(x, y)
    end
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
    ExprArr = map(UnopPlus, ExprArr)
    ExprArr = map(UnopMult, ExprArr)
    ExprArr = map(UnopDiv, ExprArr)
    ExprArr = map(UnopPow, ExprArr)
    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)
    ExprArr = scanl1(BinopPlus, ExprArr)
    ExprArr = scanl1(BinopMinus, ExprArr)
    ExprArr = scanl1(BinopMult, ExprArr)
    ExprArr = scanl1(BinopMax, ExprArr)
    ExprArr = scanl1(BinopMin, ExprArr)
    Start = :ExprNum
    ExprArr = :_arg_1
    ExprArr = :_arg_2
end
