"""
SMT-LIB `FixedSizeBitVectors` primitives for 64-bit bit-vectors.

Every function below implements the corresponding SMT-LIB 2.6 operator of the
`QF_BV`/`BV` theory at width 64, including the corner cases that differ from the
naive Julia translation:

* `bvudiv`/`bvurem`/`bvsdiv`/`bvsrem` are **total**: division by zero does not
  error, it is defined by the theory (see the individual docstrings),
* shift distances are bit-vectors, not integers, and a distance `>= 64` yields
  `0` (`bvshl`, `bvlshr`) resp. the sign-extension of the operand (`bvashr`),
* `bvashr` is an *arithmetic* shift; Julia's `>>` on a `UInt64` is a logical
  shift, so the operand has to be reinterpreted as `Int64` first,
* the signed comparisons interpret their operands as two's complement.

The signed operators are defined exactly as the SMT-LIB standard defines them,
i.e. by reduction to their unsigned counterparts, so that the wrap-around cases
(`typemin ÷ -1`) come out the same way the theory prescribes instead of throwing.

`bvredor` deviates from SMT-LIB on purpose: the standard's `bvredor` returns a
`(_ BitVec 1)`, but the SyGuS Hacker's Delight benchmarks (`hd-18`) use it as a
`Bool` -- inside `not`/`and` and as a production of the `Bool` nonterminal --
so it returns a `Bool` here.
"""

const BV_WIDTH = 64
const BV_ZERO = UInt64(0)
const BV_ONES = typemax(UInt64)

# -- bitwise ---------------------------------------------------------------

"""
    bvnot(a::UInt64)::UInt64

SMT-LIB `bvnot`: bitwise negation.
"""
bvnot(a::UInt64)::UInt64 = ~a

"""
    bvand(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvand`: bitwise conjunction.
"""
bvand(a::UInt64, b::UInt64)::UInt64 = a & b

"""
    bvor(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvor`: bitwise disjunction.
"""
bvor(a::UInt64, b::UInt64)::UInt64 = a | b

"""
    bvxor(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvxor`: bitwise exclusive disjunction.
"""
bvxor(a::UInt64, b::UInt64)::UInt64 = a ⊻ b

# -- arithmetic ------------------------------------------------------------

"""
    bvneg(a::UInt64)::UInt64

SMT-LIB `bvneg`: two's complement unary minus, `2^64 - a mod 2^64`.
"""
bvneg(a::UInt64)::UInt64 = -a

"""
    bvadd(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvadd`: addition modulo `2^64`.
"""
bvadd(a::UInt64, b::UInt64)::UInt64 = a + b

"""
    bvsub(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvsub`: subtraction modulo `2^64`.
"""
bvsub(a::UInt64, b::UInt64)::UInt64 = a - b

"""
    bvmul(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvmul`: multiplication modulo `2^64`.
"""
bvmul(a::UInt64, b::UInt64)::UInt64 = a * b

"""
    bvudiv(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvudiv`: unsigned division, truncating. Division by zero is *not* an
error: the theory defines `(bvudiv a 0)` to be the all-ones bit-vector.
"""
bvudiv(a::UInt64, b::UInt64)::UInt64 = b == BV_ZERO ? BV_ONES : div(a, b)

"""
    bvurem(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvurem`: unsigned remainder. The theory defines `(bvurem a 0)` to be
`a`.
"""
bvurem(a::UInt64, b::UInt64)::UInt64 = b == BV_ZERO ? a : rem(a, b)

"""
    bvsdiv(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvsdiv`: two's complement signed division, truncating towards zero.
Defined by the standard through `bvudiv` and `bvneg`, which fixes both corner
cases: `(bvsdiv a 0)` is `-1` for `a >= 0` and `1` for `a < 0`, and
`(bvsdiv typemin -1)` wraps to `typemin` rather than overflowing.
"""
function bvsdiv(a::UInt64, b::UInt64)::UInt64
    msb_a = signbit(reinterpret(Int64, a))
    msb_b = signbit(reinterpret(Int64, b))
    if !msb_a && !msb_b
        return bvudiv(a, b)
    elseif msb_a && !msb_b
        return bvneg(bvudiv(bvneg(a), b))
    elseif !msb_a && msb_b
        return bvneg(bvudiv(a, bvneg(b)))
    else
        return bvudiv(bvneg(a), bvneg(b))
    end
end

"""
    bvsrem(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvsrem`: two's complement signed remainder, the sign follows the
*dividend*. As for `bvsdiv` the standard defines it through `bvurem`/`bvneg`,
so `(bvsrem a 0)` is `a`.
"""
function bvsrem(a::UInt64, b::UInt64)::UInt64
    msb_a = signbit(reinterpret(Int64, a))
    msb_b = signbit(reinterpret(Int64, b))
    if !msb_a && !msb_b
        return bvurem(a, b)
    elseif msb_a && !msb_b
        return bvneg(bvurem(bvneg(a), b))
    elseif !msb_a && msb_b
        return bvurem(a, bvneg(b))
    else
        return bvneg(bvurem(bvneg(a), bvneg(b)))
    end
end

"""
    bvsmod(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvsmod`: two's complement signed modulus, the sign follows the
*divisor*. Not used by the Hacker's Delight grammars, provided for completeness.
"""
function bvsmod(a::UInt64, b::UInt64)::UInt64
    msb_a = signbit(reinterpret(Int64, a))
    msb_b = signbit(reinterpret(Int64, b))
    abs_a = msb_a ? bvneg(a) : a
    abs_b = msb_b ? bvneg(b) : b
    u = bvurem(abs_a, abs_b)
    if u == BV_ZERO
        return u
    elseif !msb_a && !msb_b
        return u
    elseif msb_a && !msb_b
        return bvadd(bvneg(u), b)
    elseif !msb_a && msb_b
        return bvadd(u, b)
    else
        return bvneg(u)
    end
end

# -- shifts ----------------------------------------------------------------

"""
    bvshl(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvshl`: left shift by the *bit-vector* `b`. A distance of 64 or more
shifts every bit out and yields `0`.
"""
bvshl(a::UInt64, b::UInt64)::UInt64 = b >= UInt64(BV_WIDTH) ? BV_ZERO : a << b

"""
    bvlshr(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvlshr`: logical right shift by the *bit-vector* `b`. A distance of 64
or more yields `0`.
"""
bvlshr(a::UInt64, b::UInt64)::UInt64 = b >= UInt64(BV_WIDTH) ? BV_ZERO : a >>> b

"""
    bvashr(a::UInt64, b::UInt64)::UInt64

SMT-LIB `bvashr`: arithmetic right shift by the *bit-vector* `b`, replicating
the sign bit. A distance of 64 or more yields all-ones for a negative `a` and
`0` otherwise.

Note that Julia's `>>` on an unsigned integer is a *logical* shift, so `a` is
reinterpreted as an `Int64` here.
"""
function bvashr(a::UInt64, b::UInt64)::UInt64
    if b >= UInt64(BV_WIDTH)
        return signbit(reinterpret(Int64, a)) ? BV_ONES : BV_ZERO
    end
    return reinterpret(UInt64, reinterpret(Int64, a) >> b)
end

# -- predicates ------------------------------------------------------------

"""
    bvult(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvult`: unsigned less-than.
"""
bvult(a::UInt64, b::UInt64)::Bool = a < b

"""
    bvule(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvule`: unsigned less-than-or-equal.
"""
bvule(a::UInt64, b::UInt64)::Bool = a <= b

"""
    bvugt(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvugt`: unsigned greater-than.
"""
bvugt(a::UInt64, b::UInt64)::Bool = a > b

"""
    bvuge(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvuge`: unsigned greater-than-or-equal.
"""
bvuge(a::UInt64, b::UInt64)::Bool = a >= b

"""
    bvslt(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvslt`: two's complement signed less-than.
"""
bvslt(a::UInt64, b::UInt64)::Bool = reinterpret(Int64, a) < reinterpret(Int64, b)

"""
    bvsle(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvsle`: two's complement signed less-than-or-equal.
"""
bvsle(a::UInt64, b::UInt64)::Bool = reinterpret(Int64, a) <= reinterpret(Int64, b)

"""
    bvsgt(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvsgt`: two's complement signed greater-than.
"""
bvsgt(a::UInt64, b::UInt64)::Bool = reinterpret(Int64, a) > reinterpret(Int64, b)

"""
    bvsge(a::UInt64, b::UInt64)::Bool

SMT-LIB `bvsge`: two's complement signed greater-than-or-equal.
"""
bvsge(a::UInt64, b::UInt64)::Bool = reinterpret(Int64, a) >= reinterpret(Int64, b)

"""
    bveq(a::UInt64, b::UInt64)::Bool

SMT-LIB `=` on bit-vectors.
"""
bveq(a::UInt64, b::UInt64)::Bool = a == b

"""
    bvredor(a::UInt64)::Bool

OR-reduction of `a`, i.e. `a != 0`.

Deviates from SMT-LIB, where `bvredor` returns a `(_ BitVec 1)`: the SyGuS
`hd-18` benchmark uses it as a `Bool` (it appears under `not`/`and` and as a
production of the `Bool` nonterminal), which only type-checks with a `Bool`
result. The bit pattern is the same, only the sort differs.
"""
bvredor(a::UInt64)::Bool = a != BV_ZERO

# -- core ------------------------------------------------------------------

"""
    ite(c::Bool, a, b)

SMT-LIB `ite`. Both branches are evaluated eagerly; every operator in this
theory is total, so this is observationally equivalent to lazy evaluation.
"""
ite(c::Bool, a, b) = c ? a : b

"""
    boolnot(a::Bool)::Bool

SMT-LIB `not`.
"""
boolnot(a::Bool)::Bool = !a

"""
    booland(a::Bool, b::Bool)::Bool

SMT-LIB `and` (binary).
"""
booland(a::Bool, b::Bool)::Bool = a & b

"""
    boolor(a::Bool, b::Bool)::Bool

SMT-LIB `or` (binary). Not used by the Hacker's Delight grammars, provided for
completeness.
"""
boolor(a::Bool, b::Bool)::Bool = a | b
