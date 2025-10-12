function drop(xs::AbstractArray, n::Int)
    if n >= length(xs)
        return []
    else
        return xs[n+1:end]
    end
end

function take(xs::AbstractArray, n::Int)
    return first(n, xs)
end

function zipwith(f::Function, xs::AbstractArray, ys::AbstractArray)
    n = min(length(xs), length(ys))
    return [f(xs[i], ys[i]) for i in 1:n]
end

function scanl1(f::Function, xs::AbstractArray)
    isempty(xs) && return Any[]  # edge case: return empty if input is empty
    ys = Array{Any}(undef, length(xs))
    ys[1] = xs[1]
    for i ∈ Iterators.drop(eachindex(xs), 1)
        ys[i] = f(ys[i-1], xs[i])
    end
    return ys
end

grammar_deepcoder = @csgrammar begin
    UnopPlus = x -> x + 1
    UnopPlus = x -> x - 1
    UnopMult = x -> x * 2
    UnopMult = x -> x * -1
    UnopMult = x -> x * 3
    UnopMult = x -> x * 4
    UnopDiv = x -> x / 2
    UnopDiv = x -> x / 3
    UnopDiv = x -> x / 4
    UnopPow = x -> x ^ 2

    UnopBool = x -> x > 0
    UnopBool = x -> x < 0
    UnopBool = x -> x % 2 == 0
    UnopBool = x -> x % 2 == 1

    BinopPlus = (x, y) -> x + y
    BinopMinus = (x, y) -> x - y
    BinopMult = (x, y) -> x * y
    BinopMax = (x, y) -> max(x, y)
    BinopMin = (x, y) -> min(x, y)

    ExprNum = |(-3:3)

    ExprNum = maximum(ExprArr)
    ExprNum = minimum(ExprArr)
    ExprNum = sum(ExprArr)
    ExprNum = first(ExprArr)
    ExprNum = last(ExprArr)
    ExprNum = getindex(ExprArr, ExprNum)
    ExprNum = count(UnopBool, ExprArr)

    ExprArr = _arg_1[1]
    ExprArr = _arg_1[2]
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
end