"""
Primitives for DreamCoder's list-processing domain.

These mirror `bootstrapTarget_extra()` from
`dreamcoder/domains/list/listPrimitives.py`. DreamCoder's DSL is a typed
lambda calculus over `int`, `bool` and `list`; indices are **0-based**, so
`dc_index` and `dc_range` keep that convention rather than Julia's 1-based one.

Partial primitives (`dc_car` of an empty list, `dc_index` out of bounds, ...)
throw, which the search treats as "this program does not solve the task" —
the same role `None` plays in the Python implementation.
"""

"""
    dc_empty

The empty list. DreamCoder's `empty` primitive.
"""
const dc_empty = Int[]

"""
    dc_cons(x, xs)

Prepend `x` to `xs`. DreamCoder's `cons`.
"""
dc_cons(x, xs::AbstractVector) = vcat([x], xs)

"""
    dc_car(xs)

First element of `xs`. Throws on an empty list, like DreamCoder's `car`.
"""
dc_car(xs::AbstractVector) = xs[begin]

"""
    dc_cdr(xs)

All but the first element of `xs`. DreamCoder's `cdr`.
"""
dc_cdr(xs::AbstractVector) = xs[(begin+1):end]

"""
    dc_is_empty(xs)

Is `xs` empty? DreamCoder's `empty?`.
"""
dc_is_empty(xs::AbstractVector) = isempty(xs)

"""
    dc_length(xs)

Number of elements of `xs`. DreamCoder's `length`.
"""
dc_length(xs::AbstractVector) = length(xs)

"""
    dc_index(n, xs)

`n`-th element of `xs`, **0-based**, matching DreamCoder's `index`.
"""
dc_index(n::Integer, xs::AbstractVector) = xs[n+1]

"""
    dc_range(n)

`[0, 1, ..., n-1]`, matching DreamCoder's `range`. DreamCoder refuses to build
ranges of 100 or more elements to keep enumeration cheap; that bound is kept.
"""
function dc_range(n::Integer)
    n < 100 || throw(ArgumentError("dc_range refuses n >= 100 (got $n)"))
    return collect(0:(n-1))
end

"""
    dc_map(f, xs)

Apply `f` to each element of `xs`. DreamCoder's `map`.
"""
dc_map(f, xs::AbstractVector) = [f(x) for x in xs]

"""
    dc_filter(f, xs)

Keep the elements of `xs` satisfying `f`. DreamCoder's `filter`.
"""
dc_filter(f, xs::AbstractVector) = [x for x in xs if f(x)]

"""
    dc_fold(xs, x0, f)

Right fold: `f(x_1, f(x_2, ... f(x_n, x0)))`. Argument order and direction
match DreamCoder's `fold`, whose Python definition folds over the reversed
list applying `f(element)(accumulator)`.
"""
function dc_fold(xs::AbstractVector, x0, f)
    acc = x0
    for x in Iterators.reverse(xs)
        acc = f(x, acc)
    end
    return acc
end

"""
    dc_unfold(x0, stop, out, next)

Build a list by iterating `next` from `x0`, emitting `out` at each step, until
`stop` holds. DreamCoder's `unfold`, including its recursion limit of 50.
"""
function dc_unfold(x0, stop, out, next)
    result = Any[]
    x = x0
    for _ in 1:50
        stop(x) && return [r for r in result]
        push!(result, out(x))
        x = next(x)
    end
    throw(ArgumentError("dc_unfold exceeded its recursion limit of 50"))
end

"""
    dc_append(xs, ys)

Concatenation of `xs` and `ys`.

Not one of DreamCoder's starting primitives: DreamCoder *derives* concatenation
during library learning, using recursion that a context-free Herb grammar
cannot express. It is provided here so that the tasks in this benchmark stay
reachable — see the README's "Deviations from the original DSL".
"""
dc_append(xs::AbstractVector, ys::AbstractVector) = vcat(xs, ys)

"""
    dc_all(f, xs)

Does `f` hold for every element of `xs`?
"""
dc_all(f, xs::AbstractVector) = all(f, xs)

"""
    dc_any(f, xs)

Does `f` hold for at least one element of `xs`?
"""
dc_any(f, xs::AbstractVector) = any(f, xs)

"""
    dc_gt(x, y)

`x > y`. DreamCoder's `gt?`.
"""
dc_gt(x::Integer, y::Integer) = x > y

"""
    dc_eq(x, y)

`x == y`. DreamCoder's `eq?`.
"""
dc_eq(x::Integer, y::Integer) = x == y

"""
    dc_mod(x, y)

`x mod y`, following Python's `%` (result takes the sign of `y`), as in
DreamCoder's `mod`.
"""
dc_mod(x::Integer, y::Integer) = mod(x, y)

"""
    dc_is_prime(n)

Is `n` prime? DreamCoder hard-codes the primes below 200; `dc_is_prime` keeps
that range so that programs behave identically on the benchmark's data.
"""
const _DC_PRIMES = Set([
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67,
    71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149,
    151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
])

dc_is_prime(n::Integer) = n in _DC_PRIMES

"""
    dc_is_square(n)

Is `n` a perfect square? DreamCoder's `is-square`.
"""
dc_is_square(n::Integer) = n >= 0 && isqrt(n)^2 == n

# ---------------------------------------------------------------------------
# Function-valued combinators
#
# DreamCoder passes arbitrary lambdas to `map`, `filter`, `fold` and `unfold`.
# A Herb grammar is context-free over first-order Julia expressions, so the
# lambdas are reached through combinators: `dc_add(3)` *is* the function
# `x -> x + 3`, and the grammar draws the `3` from its own `Num` nonterminal.
# `dc_compose` keeps the family closed under composition, so the reachable
# functions are still an open-ended set rather than a fixed menu.
# ---------------------------------------------------------------------------

"""
    dc_identity

The function `x -> x`.
"""
const dc_identity = identity

"""
    dc_add(n)

The function `x -> x + n`.
"""
dc_add(n::Integer) = x -> x + n

"""
    dc_sub(n)

The function `x -> x - n`.
"""
dc_sub(n::Integer) = x -> x - n

"""
    dc_rsub(n)

The function `x -> n - x`.
"""
dc_rsub(n::Integer) = x -> n - x

"""
    dc_mul(n)

The function `x -> x * n`.
"""
dc_mul(n::Integer) = x -> x * n

"""
    dc_modulo(n)

The function `x -> mod(x, n)`.
"""
dc_modulo(n::Integer) = x -> dc_mod(x, n)

"""
    dc_const(n)

The constant function `x -> n`.
"""
dc_const(n) = _ -> n

"""
    dc_compose(f, g)

The function `x -> f(g(x))`.
"""
dc_compose(f, g) = x -> f(g(x))

"""
    dc_greater_than(n)

The predicate `x -> x > n`.
"""
dc_greater_than(n::Integer) = x -> x > n

"""
    dc_less_than(n)

The predicate `x -> x < n`.
"""
dc_less_than(n::Integer) = x -> x < n

"""
    dc_equal_to(n)

The predicate `x -> x == n`.
"""
dc_equal_to(n::Integer) = x -> x == n

"""
    dc_divisible_by(n)

The predicate `x -> mod(x, n) == 0`.
"""
dc_divisible_by(n::Integer) = x -> dc_mod(x, n) == 0

"""
    dc_negate(f)

The predicate `x -> !f(x)`.
"""
dc_negate(f) = x -> !f(x)

# Binary operators for `dc_fold`. `dc_fold` calls `f(element, accumulator)`,
# so these take that argument order; `dc_cons` already has the right shape and
# is used directly as a fold operator to rebuild lists.

"""
    dc_add2(x, a)

Fold operator `(x, a) -> x + a`.
"""
dc_add2(x, a) = x + a

"""
    dc_sub2(x, a)

Fold operator `(x, a) -> a - x`.
"""
dc_sub2(x, a) = a - x

"""
    dc_mul2(x, a)

Fold operator `(x, a) -> x * a`.
"""
dc_mul2(x, a) = x * a

"""
    dc_max2(x, a)

Fold operator `(x, a) -> max(x, a)`.
"""
dc_max2(x, a) = max(x, a)

"""
    dc_min2(x, a)

Fold operator `(x, a) -> min(x, a)`.
"""
dc_min2(x, a) = min(x, a)

"""
    dc_snoc(x, a)

Fold operator `(x, a) -> dc_append(a, [x])`. Under `dc_fold`'s right fold this
reverses a list, which is otherwise out of reach without recursion.
"""
dc_snoc(x, a) = dc_append(a, [x])

"""
    dc_cons_map(f)

Fold operator `(x, a) -> dc_cons(f(x), a)`, i.e. `map f` expressed as a fold.
"""
dc_cons_map(f) = (x, a) -> dc_cons(f(x), a)

"""
    dc_cons_if(p)

Fold operator `(x, a) -> p(x) ? dc_cons(x, a) : a`, i.e. `filter p` expressed
as a fold.
"""
dc_cons_if(p) = (x, a) -> p(x) ? dc_cons(x, a) : a
