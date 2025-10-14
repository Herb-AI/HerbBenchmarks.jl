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