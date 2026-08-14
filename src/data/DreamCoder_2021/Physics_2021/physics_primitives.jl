"""
Primitives for DreamCoder's physical-law discovery domain.

In the paper (Fig. 7A) DreamCoder is handed only a generic recursive basis —
`map`, `fold`, `zip`, `cons`, `car`, `cdr`, `empty`, arithmetic and `power` —
and *learns* vector algebra (inner products, vector sums, norms) and then the
inverse-square schema on top of it. A context-free Herb grammar cannot
rediscover those via lambda-recursion, so the vector operations DreamCoder
learns are provided here as primitives; the README records this as a
deliberate deviation.

Vectors are lists of reals, exactly as in `bin/scientificLaws.py`.
"""

"""
    dc_pi

DreamCoder's π. `bin/scientificLaws.py` uses the literal `3.14`
("I think this is close enough to pi"), and the benchmark data was generated
with that value, so it is reproduced here rather than using `Base.pi`.
"""
const dc_pi = 3.14

"""
    dc_g

Standard gravitational acceleration as used by the freefall and potential
energy laws.
"""
const dc_g = 9.8

"""
    real_add(x, y)

`x + y`.
"""
real_add(x::Real, y::Real) = x + y

"""
    real_sub(x, y)

`x - y`.
"""
real_sub(x::Real, y::Real) = x - y

"""
    real_mul(x, y)

`x * y`.
"""
real_mul(x::Real, y::Real) = x * y

"""
    real_div(x, y)

`x / y`.
"""
real_div(x::Real, y::Real) = x / y

"""
    real_power(x, y)

`x ^ y`. DreamCoder's `power`.
"""
real_power(x::Real, y::Real) = x^y

"""
    real_sqrt(x)

`sqrt(x)`.
"""
real_sqrt(x::Real) = sqrt(x)

"""
    real_reciprocal(x)

`1 / x`. One of the abstractions DreamCoder learns (Fig. 7A).
"""
real_reciprocal(x::Real) = 1 / x

"""
    vec_add(u, v)

Element-wise sum of two vectors.
"""
vec_add(u::AbstractVector, v::AbstractVector) = [a + b for (a, b) in zip(u, v)]

"""
    vec_sub(u, v)

Element-wise difference of two vectors.
"""
vec_sub(u::AbstractVector, v::AbstractVector) = [a - b for (a, b) in zip(u, v)]

"""
    vec_scale(a, v)

Multiply every component of `v` by the scalar `a`.
"""
vec_scale(a::Real, v::AbstractVector) = [a * x for x in v]

"""
    vec_dot(u, v)

Inner product of `u` and `v`.
"""
vec_dot(u::AbstractVector, v::AbstractVector) = sum(x * y for (x, y) in zip(u, v))

"""
    vec_norm(v)

Euclidean norm of `v`.
"""
vec_norm(v::AbstractVector) = sqrt(sum(x * x for x in v))

"""
    vec_unit(v)

`v` scaled to unit length.
"""
vec_unit(v::AbstractVector) = vec_scale(1 / vec_norm(v), v)

"""
    vec_cross(u, v)

Cross product of two 3-dimensional vectors.
"""
function vec_cross(u::AbstractVector, v::AbstractVector)
    return [u[2] * v[3] - u[3] * v[2],
        u[3] * v[1] - u[1] * v[3],
        u[1] * v[2] - u[2] * v[1]]
end

"""
    vec_sum_components(v)

Sum of the components of `v`. DreamCoder's learned "sum components".
"""
vec_sum_components(v::AbstractVector) = sum(v)

"""
    vec_add_many(vs)

Sum of a list of vectors. DreamCoder's learned "add many vectors".
"""
vec_add_many(vs::AbstractVector) = reduce(vec_add, vs)

"""
    reals_sum(xs)

Sum of a list of reals (series resistors, parallel capacitors).
"""
reals_sum(xs::AbstractVector) = sum(xs)

"""
    reals_reciprocal_sum(xs)

`(Σ 1/x)^-1` — the parallel-resistor / series-capacitor schema.
"""
reals_reciprocal_sum(xs::AbstractVector) = sum(x^(-1) for x in xs)^(-1)

"""
    reals_map_reciprocal(xs)

Element-wise reciprocal of a list of reals.
"""
reals_map_reciprocal(xs::AbstractVector) = [1 / x for x in xs]

"""
    vec_zip_mul(u, v)

Element-wise product of two vectors, i.e. `zip` followed by multiplication.
"""
vec_zip_mul(u::AbstractVector, v::AbstractVector) = [a * b for (a, b) in zip(u, v)]
