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

    ExprNum = maximum(ExprArr)              := (length(y) == 1, length(x1) >= 1, maximum(y) == maximum(x1), minimum(y) >= minimum(x1))
    ExprNum = minimum(ExprArr)              := (length(y) == 1, length(x1) >= 1, maximum(y) <= maximum(x1), minimum(y) == minimum(x1))
    ExprNum = sum(ExprArr)                  := (length(y) == 1, length(x1) > 1)
    ExprNum = first(ExprArr)                := (length(y) == 1, length(x1) >= 1, maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == first(x1), last(y) == first(x1))
    ExprNum = last(ExprArr)                 := (length(y) == 1, length(x1) >= 1, maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == last(x1), last(y) == last(x1))
    ExprNum = getindex(ExprArr, ExprNum)    := (length(x1) > 1, length(y) == 1, maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), x2 > 0, length(x1) < x2)
    ExprNum = count(UnopBool, ExprArr)      := (length(x2) > 1, length(y) == 1, length(y) <= length(x2))

    ExprArr = _arg_1[1]
    ExprArr = _arg_1[2]
    ExprArr = drop(ExprArr, ExprNum)        := (length(x1) > 1, maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), last(y) == last(x1), x2 > 0, length(x1) < x2)
    ExprArr = take(ExprArr, ExprNum)        := (length(x1) > 1, maximum(y) <= maximum(x1), minimum(y) >= minimum(x1), first(y) == first(x1), x2 > 0, length(x1) < x2)
    ExprArr = sort(ExprArr)                 := (length(y) == length(x1), maximum(y) == maximum(x1), minimum(y) == minimum(x1), first(y) == minimum(x1), last(y) == maximum(x1))
    ExprArr = reverse(ExprArr)              := (length(y) == length(x1), maximum(y) == maximum(x1), minimum(y) == minimum(x1), first(y) == last(x1), last(y) == first(x1))

    ExprArr = filter(UnopBool, ExprArr)     := (length(y) <= length(x2), maximum(y) <= maximum(x2), minimum(y) >= minimum(x2))

    ExprArr = map(UnopPlus, ExprArr)        := (length(y) == length(x2), first(y) == UnopPlus(first(x2)), last(y) == UnopPlus(last(x2)))
    ExprArr = map(UnopMult, ExprArr)        := (length(y) == length(x2), first(y) == UnopMult(first(x2)), last(y) == UnopMult(last(x2)))
    ExprArr = map(UnopDiv, ExprArr)         := (length(y) == length(x2), first(y) == UnopDiv(first(x2)), last(y) == UnopDiv(last(x2)))
    ExprArr = map(UnopPow, ExprArr)         := (length(y) == length(x2), first(y) == UnopPow(first(x2)), last(y) == UnopPow(last(x2)))

    ExprArr = zipwith(BinopPlus, ExprArr, ExprArr)  := (length(y) == length(x2), length(y) == length(x3), first(y) <= first(x2) + first(x3), last(y) <= last(x2) + last(x3))
    ExprArr = zipwith(BinopMinus, ExprArr, ExprArr) := (length(y) == length(x2), length(y) == length(x3), first(y) <= first(x2) - first(x3), last(y) <= last(x2) - last(x3))
    ExprArr = zipwith(BinopMult, ExprArr, ExprArr)  := (length(y) == length(x2), length(y) == length(x3), first(y) <= first(x2) * first(x3), last(y) <= last(x2) * last(x3))
    ExprArr = zipwith(BinopMax, ExprArr, ExprArr)   := (length(y) == length(x2), length(y) == length(x3), first(y) <= max(first(x2), first(x3)), last(y) <= max(last(x2), last(x3)))
    ExprArr = zipwith(BinopMin, ExprArr, ExprArr)   := (length(y) == length(x2), length(y) == length(x3), first(y) <= min(first(x2), first(x3)), last(y) <= min(last(x2), last(x3)))

    ExprArr = scanl1(BinopPlus, ExprArr)    := (length(y) == length(x2), first(y) == first(x2))
    ExprArr = scanl1(BinopMinus, ExprArr)   := (length(y) == length(x2), first(y) == first(x2))
    ExprArr = scanl1(BinopMult, ExprArr)    := (length(y) == length(x2), first(y) == first(x2))
    ExprArr = scanl1(BinopMax, ExprArr)     := (length(y) == length(x2), first(y) == first(x2), maximum(y) == maximum(x2), minimum(y) >= minimum(x2), last(y) == maximum(x2))
    ExprArr = scanl1(BinopMin, ExprArr)     := (length(y) == length(x2), first(y) == first(x2), maximum(y) <= maximum(x2), minimum(y) == minimum(x2), last(y) == minimum(x2))
end