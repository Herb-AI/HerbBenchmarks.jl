using MLStyle

UnopPlus1 = x -> x + 1
UnopPlus2 = x -> x - 1
UnopMult1 = x -> x * 2
UnopMult2 = x -> x * -1
UnopMult3 = x -> x * 3
UnopMult4 = x -> x * 4
UnopDiv1 = x -> x / 2
UnopDiv2 = x -> x / 3
UnopDiv3 = x -> x / 4
UnopPow = x -> x ^ 2

UnopBool1 = x -> x > 0
UnopBool2 = x -> x < 0
UnopBool3 = x -> x % 2 == 0
UnopBool4 = x -> x % 2 == 1

UnopBool5 = x -> x < Int
UnopBool6 = x -> x > Int
UnopBool7 = x -> x == Int
UnopBool8 = x -> x != Int
UnopBool9 = x -> x %= Int

BinopPlus = (x, y) -> x + y
BinopMinus = (x, y) -> x - y
BinopMult = (x, y) -> x * y
BinopMax = (x, y) -> max(x, y)
BinopMin = (x, y) -> min(x, y)

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
    isempty(xs) && return Any[]
    ys = Array{Any}(undef, length(xs))
    ys[1] = xs[1]
    for i ∈ Iterators.drop(eachindex(xs), 1)
        ys[i] = f(ys[i-1], xs[i])
    end
    return ys
end

function interpret_deepcoder(prog::AbstractRuleNode, grammar_tags::Dict{Int, Any}, input::Dict{Symbol, T})::Any where T
    r = get_rule(prog)
    c = get_children(prog)

    if grammar_tags[r] in input
        return input[grammar_tags[r]]
    end

    MLStyle.@match grammar_tags[r] begin
        :maximum => maximum(interpret_deepcoder(c[1], grammar_tags, input))
        :minimum => minimum(interpret_deepcoder(c[1], grammar_tags, input))
        :sum => sum(interpret_deepcoder(c[1], grammar_tags, input))
        :first => first(interpret_deepcoder(c[1], grammar_tags, input))
        :last => last(interpret_deepcoder(c[1], grammar_tags, input))
        :getindex => getindex(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :count => count(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :drop => drop(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :take => take(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :sort => sort(interpret_deepcoder(c[1], grammar_tags, input))
        :reverse => reverse(interpret_deepcoder(c[1], grammar_tags, input))
        :filter => filter(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :map => map(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :map => map(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :map => map(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :map => map(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :zipwith => zipwith(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input), interpret_deepcoder(c[3], grammar_tags, input))
        :zipwith => zipwith(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input), interpret_deepcoder(c[3], grammar_tags, input))
        :zipwith => zipwith(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input), interpret_deepcoder(c[3], grammar_tags, input))
        :zipwith => zipwith(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input), interpret_deepcoder(c[3], grammar_tags, input))
        :zipwith => zipwith(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input), interpret_deepcoder(c[3], grammar_tags, input))
        :scanl1 => scanl1(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :scanl1 => scanl1(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :scanl1 => scanl1(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :scanl1 => scanl1(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        :scanl1 => scanl1(interpret_deepcoder(c[1], grammar_tags, input), interpret_deepcoder(c[2], grammar_tags, input))
        _ => grammar_tags[r]
    end
end