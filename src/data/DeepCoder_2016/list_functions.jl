using MLStyle

@inline function drop(xs::AbstractArray, n::Int)
    if n >= length(xs)
        return []
    else
        return xs[n+1:end]
    end
end

@inline function take(xs::AbstractArray, n::Int)
    return first(n, xs)
end

"""
    zipwith(f::Function, xs::AbstractArray, ys::AbstractArray) -> Vector{Int}

Element-wise binary operation `f` on two arrays `xs` and `ys`.
"""
@inline function zipwith(f::Function, xs::AbstractArray, ys::AbstractArray)
    n = min(length(xs), length(ys))
    return [f(xs[i], ys[i]) for i in 1:n]
end

"""
    scanl1_int(f, xs::AbstractVector{<:Integer}) -> Vector{Int}

Scan (left) using binary function `f` over the integer array `xs`.
"""
@inline function scanl1_int(f::F, xs::AbstractVector{<:Integer}) where {F<:Function}
    isempty(xs) && return Int[]
    ys = Vector{Int}(undef, length(xs))
    ys[1] = xs[1]
    @inbounds for i in 2:length(xs)
        ys[i] = f(ys[i-1], xs[i])
    end
    return ys
end

"""
    map2(f, arr::AbstractVector{<:Integer}, k::Integer) -> Vector{Int}

Apply a binary function `f(x, k)` to each element `x` in `arr`, using the bound integer `k`.
"""
@inline function map2(f::F, arr::AbstractVector{<:Integer}, k::Integer) where {F<:Function}
    out = Vector{Int}(undef, length(arr))
    @inbounds @simd for i in eachindex(arr)
        out[i] = f(arr[i], k)
    end
    return out
end

"""
    filter2(pred, arr::AbstractVector{<:Integer}, k::Integer) -> Vector{Int}

Keep elements `x` from `arr` for which `pred(x, k)` is true.
"""
@inline function filter2(pred::F, arr::AbstractVector{<:Integer}, k::Integer) where {F<:Function}
    out = Int[]
    @inbounds for x in arr
        pred(x, k) && push!(out, Int(x))
    end
    return out
end

"""
    count2(pred, arr::AbstractVector{<:Integer}, k::Integer) -> Int

Count elements `x` in `arr` for which `pred(x, k)` is true.
"""
@inline function count2(pred::F, arr::AbstractVector{<:Integer}, k::Integer) where {F<:Function}
    c = 0
    @inbounds for x in arr
        c += pred(x, k)
    end
    return c
end

@inline binopPlus(x::Integer, y::Integer) = x + y
@inline binopMinus(x::Integer, y::Integer) = x - y
@inline binopMult(x::Integer, y::Integer) = x * y
@inline binopMax(x::Integer, y::Integer) = max(x, y)
@inline binopMin(x::Integer, y::Integer) = min(x, y)
@inline binopDiv(x::Integer, y::Integer)  = div(x, y)
@inline binopPow(x::Integer, y::Integer)  = x ^ y

@inline binopBoolSt(x::Integer, y::Integer)  = x > y
@inline binopBoolGt(x::Integer, y::Integer)  = x < y
@inline binopBoolEq(x::Integer, y::Integer)  = x == y
@inline binopBoolNeq(x::Integer, y::Integer) = x != y
@inline binopBoolMod(x::Integer, y::Integer)  = (y == 0) ? false : (x % y == 0)
@inline binopBoolNmod(x::Integer, y::Integer) = (y == 0) ? true  : (x % y != 0)

# -------------------------------------------------
# Concrete wrappers for the grammar (lambda plugged)
# -------------------------------------------------

# map with arithmetic ops
@inline mapPlus(arr::AbstractVector{<:Integer}, k::Integer)  = map2(binopPlus,  arr, k)
@inline mapMult(arr::AbstractVector{<:Integer}, k::Integer)  = map2(binopMult,  arr, k)
@inline mapDiv(arr::AbstractVector{<:Integer}, k::Integer)   = map2(binopDiv,    arr, k)
@inline mapPow(arr::AbstractVector{<:Integer}, k::Integer)   = map2(binopPow,    arr, k)

# filter with boolean predicates
@inline filterSt(arr::AbstractVector{<:Integer}, k::Integer)   = filter2(binopBoolSt,   arr, k)
@inline filterGt(arr::AbstractVector{<:Integer}, k::Integer)   = filter2(binopBoolGt,   arr, k)
@inline filterEq(arr::AbstractVector{<:Integer}, k::Integer)   = filter2(binopBoolEq,   arr, k)
@inline filterNeq(arr::AbstractVector{<:Integer}, k::Integer) = filter2(binopBoolNeq, arr, k)
@inline filterMod(arr::AbstractVector{<:Integer}, k::Integer)  = filter2(binopBoolMod,  arr, k)
@inline filterNmod(arr::AbstractVector{<:Integer}, k::Integer) = filter2(binopBoolNmod, arr, k)

# count with boolean predicates
@inline countSt(arr::AbstractVector{<:Integer}, k::Integer)   = count2(binopBoolSt,   arr, k)
@inline countGt(arr::AbstractVector{<:Integer}, k::Integer)   = count2(binopBoolGt,   arr, k)
@inline countEq(arr::AbstractVector{<:Integer}, k::Integer)   = count2(binopBoolEq,   arr, k)
@inline countNeq(arr::AbstractVector{<:Integer}, k::Integer)  = count2(binopBoolNeq,  arr, k)
@inline countMod(arr::AbstractVector{<:Integer}, k::Integer)  = count2(binopBoolMod,  arr, k)
@inline countNmod(arr::AbstractVector{<:Integer}, k::Integer) = count2(binopBoolNmod, arr, k)

# concrete scanl1 wrappers
@inline scanl1Plus(arr::AbstractVector{<:Integer})  = scanl1_int(binopPlus,  arr)
@inline scanl1Minus(arr::AbstractVector{<:Integer}) = scanl1_int(binopMinus, arr)
@inline scanl1Mult(arr::AbstractVector{<:Integer})  = scanl1_int(binopMult,  arr)
@inline scanl1Max(arr::AbstractVector{<:Integer})   = scanl1_int(binopMax,   arr)
@inline scanl1Min(arr::AbstractVector{<:Integer})   = scanl1_int(binopMin,   arr)

# --- zipwith: concrete wrappers ---
@inline zipwithPlus(xs::AbstractVector{<:Integer}, ys::AbstractVector{<:Integer})  = zipwith(binopPlus,  xs, ys)
@inline zipwithMinus(xs::AbstractVector{<:Integer}, ys::AbstractVector{<:Integer}) = zipwith(binopMinus, xs, ys)
@inline zipwithMult(xs::AbstractVector{<:Integer}, ys::AbstractVector{<:Integer})  = zipwith(binopMult,  xs, ys)
@inline zipwithMax(xs::AbstractVector{<:Integer}, ys::AbstractVector{<:Integer})   = zipwith(binopMax,   xs, ys)
@inline zipwithMin(xs::AbstractVector{<:Integer}, ys::AbstractVector{<:Integer})   = zipwith(binopMin,   xs, ys)


function interpret_deepcoder(prog::AbstractRuleNode, grammar_tags::Dict{Int, Any}, input::Dict{Symbol, Any})
    r = get_rule(prog)
    c = get_children(prog)

    if haskey(input, grammar_tags[r])
        return input[grammar_tags[r]]
    end

    MLStyle.@match grammar_tags[r] begin
        :maximum => maximum(interpret_deepcoder(c[1], grammar_tags, input))
        :minimum => minimum(interpret_deepcoder(c[1], grammar_tags, input))
        :sum => sum(interpret_deepcoder(c[1], grammar_tags, input))
        :first => first(interpret_deepcoder(c[1], grammar_tags, input))
        :last => last(interpret_deepcoder(c[1], grammar_tags, input))
        :getindex => getindex(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countSt => countSt(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countGt => countGt(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countEq => countEq(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countNeq => countNeq(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countMod => countMod(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :countNmod => countNmod(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :drop => drop(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :take => take(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :sort => sort(interpret_deepcoder(c[1], grammar_tags, input))
        :reverse => reverse(interpret_deepcoder(c[1], grammar_tags, input))
        :filterSt => filterSt(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :filterGt => filterGt(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :filterEq => filterEq(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :filterNeq => filterNeq(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :filterMod => filterMod(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :filterNmod => filterNmod(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :mapDiv => mapDiv(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :mapMul => mapMult(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :mapPlus => mapPlus(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :mapPow => mapPow(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwithMax => zipwithMax(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwithMin => zipwithMin(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwithPlus => zipwithPlus(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwithMinus => zipwithMinus(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwithMult => zipwithMult(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :scanl1Max => scanl1Max(interpret_deepcoder(c[1], grammar_tags, input))
        :scanl1Min => scanl1Min(interpret_deepcoder(c[1], grammar_tags, input))
        :scanl1Plus => scanl1Plus(interpret_deepcoder(c[1], grammar_tags, input))
        :scanl1Minus => scanl1Minus(interpret_deepcoder(c[1], grammar_tags, input))
        :scanl1Mult => scanl1Mult(interpret_deepcoder(c[1], grammar_tags, input))
        _ => grammar_tags[r]
    end
end