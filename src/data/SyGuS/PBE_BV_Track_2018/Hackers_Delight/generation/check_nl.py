"""Check every `define-fun hdNN` against its natural-language description.

For each benchmark an *independent* 64-bit reference implementation of what the
comment says is built in z3, and z3 is asked to prove equivalence with the
reference implementation shipped in the .sl file.  Any counterexample is
reported.
"""
import z3
from parse_sl import all_benchmarks

W = 64
BV = lambda n: z3.BitVecVal(n, W)


# ---------- reference building blocks -------------------------------------
def popcount(x):
    return z3.Sum([z3.ZeroExt(W - 1, z3.Extract(i, i, x)) for i in range(W)])


def nlz(x):
    """number of leading zeros, 64-bit"""
    val = BV(W)
    for i in range(W):                       # higher bits override
        val = z3.If(z3.Extract(i, i, x) == 1, BV(W - 1 - i), val)
    return val


def clp2(x):
    """round up to the next power of two (Hacker's Delight `clp2`, 64 bit)"""
    y = x - 1
    for s in (1, 2, 4, 8, 16, 32):
        y = y | z3.LShR(y, BV(s))
    return y + 1


def snoob(x):
    """next higher unsigned integer with the same number of one bits"""
    s = x & -x
    r = x + s
    return r | z3.UDiv(z3.LShR(x ^ r, BV(2)), s)


def mulhi(x, y):
    p = z3.ZeroExt(W, x) * z3.ZeroExt(W, y)
    return z3.Extract(2 * W - 1, W, p)


def avg_floor(x, y):
    s = z3.ZeroExt(1, x) + z3.ZeroExt(1, y)
    return z3.Extract(W - 1, 0, z3.LShR(s, 1))


def avg_ceil(x, y):
    s = z3.ZeroExt(1, x) + z3.ZeroExt(1, y) + 1
    return z3.Extract(W - 1, 0, z3.LShR(s, 1))


def exchange_fields(x, m, k):
    t = ((z3.LShR(x, k)) ^ x) & m
    return x ^ t ^ (t << k)


# ---------- per-benchmark reference + claim -------------------------------
# each entry: (claim shown in the report, lambda over the spec args -> z3 term
#              that must equal the shipped spec, optional precondition)
REFS = {
    "hd_01": ("x with its rightmost 1-bit turned off",
              lambda x: x & (x - 1), None),
    "hd_02": ("zero iff x is of the form 2^n - 1  (result compared as `== 0`)",
              lambda x: z3.If(popcount(x + 1) <= 1, BV(0), x & (x + 1)), None),
    "hd_03": ("only the rightmost 1-bit of x kept",
              lambda x: x & -x, None),
    "hd_04": ("mask covering the rightmost 1-bit and the trailing zeros",
              lambda x: (x & -x) | ((x & -x) - 1), None),
    "hd_05": ("x with the rightmost 1-bit propagated right",
              lambda x: x | ((x & -x) - 1), None),
    "hd_06": ("x with the rightmost 0-bit turned on",
              lambda x: x | (x + 1), None),
    "hd_07": ("only the rightmost 0-bit of x kept (as a 1)",
              lambda x: ~x & (x + 1), None),
    "hd_08": ("mask covering exactly the trailing zeros of x",
              lambda x: (x & -x) - 1, None),
    "hd_09": ("|x| (two's complement absolute value)",
              lambda x: z3.If(x < 0, -x, x), None),
    "hd_10": ("nlz(x) == nlz(y)",
              lambda x, y: nlz(x) == nlz(y), None),
    "hd_11": ("nlz(x) < nlz(y)",
              lambda x, y: z3.ULT(nlz(x), nlz(y)), None),
    "hd_12": ("nlz(x) < nlz(y)",
              lambda x, y: z3.ULT(nlz(x), nlz(y)), None),
    "hd_13": ("sign(x): -1 / 0 / 1",
              lambda x: z3.If(x < 0, BV(-1), z3.If(x == 0, BV(0), BV(1))), None),
    "hd_14": ("floor((x + y) / 2), unsigned, without overflow",
              avg_floor, None),
    "hd_15": ("floor((x + y) / 2), unsigned, without overflow",
              avg_floor, None),
    "hd_16": ("max(x, y), signed  (no description in the file)",
              lambda x, y: z3.If(x < y, y, x), None),
    "hd_17": ("x with the rightmost contiguous run of ones turned off",
              lambda x: ((x | (x - 1)) + 1) & x, None),
    "hd_18": ("x is a power of two",
              lambda x: z3.And(x != 0, (x & (x - 1)) == 0), None),
    "hd_19": ("fields A and B of x exchanged (m selects B, k is the distance)",
              exchange_fields, None),
    "hd_20": ("next higher unsigned number with the same number of 1-bits",
              snoob, None),
    "hd_21": ("cycle x through a -> b -> c -> a",
              lambda x, a, b, c: z3.If(x == a, b, z3.If(x == b, c, a)), None),
    "hd_22": ("parity of x (popcount(x) mod 2)",
              lambda x: z3.ZeroExt(W - 1, z3.Extract(0, 0, popcount(x))), None),
    "hd_23": ("popcount(x)", popcount, None),
    "hd_24": ("smallest power of two >= x", clp2, None),
    "hd_25": ("high 64 bits of the 128-bit product x * y", mulhi, None),
    "hd_26": ("x rounded up to a multiple of 2^k",
              lambda x, k: (x + ((BV(1) << k) - 1)) & ~((BV(1) << k) - 1),
              lambda x, k: z3.ULT(k, BV(W))),
    "hd_27": ("min(x, y), signed  (no description in the file)",
              lambda x, y: z3.If(x < y, x, y), None),
}

# extra, weaker claims tried when the primary claim fails - they identify what
# the shipped implementation *actually* computes.
ALTERNATIVES = {
    "hd_09": [("|x| computed with a 31-bit arithmetic shift (the 32-bit HD trick)",
               lambda x: (x ^ (x >> BV(31))) - (x >> BV(31))),
              ("|x| when x fits in 32 signed bits",
               None)],
    "hd_13": [("sign(x) restricted to 32-bit inputs", None)],
    "hd_12": [("nlz(x) <= nlz(y)", lambda x, y: z3.ULE(nlz(x), nlz(y)))],
    "hd_15": [("ceil((x + y) / 2), unsigned, without overflow", avg_ceil)],
    "hd_23": [("popcount of the low 32 bits of x",
               lambda x: popcount(z3.Concat(z3.BitVecVal(0, 32), z3.Extract(31, 31 - 31, x))))],
    "hd_22": [("parity of the low 32 bits of x",
               lambda x: z3.ZeroExt(W - 1, z3.Extract(0, 0,
                   popcount(z3.Concat(z3.BitVecVal(0, 32), z3.Extract(31, 0, x))))))],
    "hd_24": [("smallest power of two >= x, for x < 2^32", None)],
    "hd_26": [("x + 2 rounded up to a multiple of 2^k (an off-by-two: the shipped "
               "code adds 2^k + 1 instead of 2^k - 1)",
               lambda x, k: (x + (BV(1) << k) + 1) & ~((BV(1) << k) - 1))],
}

RESTRICTIONS = {
    # benchmark -> (label, precondition) used to find the input range on which
    # the shipped implementation *does* match the description
    "hd_09": ("x fits in 32 signed bits", lambda x: z3.And(x >= BV(-2**31), x < BV(2**31))),
    "hd_13": ("-2^31 <= x <= 0", lambda x: z3.And(x >= BV(-2**31), x <= BV(0))),
    "hd_23": ("x < 2^32", lambda x: z3.ULT(x, BV(2**32))),
    "hd_22": ("x < 2^32", lambda x: z3.ULT(x, BV(2**32))),
    "hd_24": ("x <= 2^31", lambda x: z3.ULE(x, BV(2**31))),
    "hd_25": ("x, y < 2^16", lambda x, y: z3.And(z3.ULT(x, BV(2**16)), z3.ULT(y, BV(2**16)))),
    "hd_20": ("x < 2^8", lambda x: z3.ULT(x, BV(2**8))),
}


def spec_term(b, vars_):
    """z3 term for the shipped `define-fun`, applied to `vars_`."""
    decls = "\n".join("(declare-const %s %s)" % (a, s)
                      for a, s in zip(b.args, b.arg_sorts))
    call = "(%s %s)" % (b.spec_name, " ".join(b.args))
    if b.is_bool:
        assertion = "(assert %s)" % call
    else:
        assertion = "(assert (= %s #x0000000000000000))" % call
    parsed = z3.parse_smt2_string("\n".join([b.smt2_prelude(), decls, assertion]))[-1]
    if b.is_bool:
        term = parsed
    else:
        term = parsed.arg(0)
    subst = [(z3.BitVec(a, W), v) for a, v in zip(b.args, vars_)]
    return z3.substitute(term, *subst)


def prove_equal(lhs, rhs, vars_, pre=None):
    s = z3.Solver()
    if pre is not None:
        s.add(pre)
    s.add(lhs != rhs)
    if s.check() == z3.unsat:
        return None
    m = s.model()
    return tuple(m.eval(v, model_completion=True).as_long() for v in vars_)


def main():
    ok, bad = [], []
    for b in all_benchmarks():
        vars_ = [z3.BitVec(a, W) for a in b.args]
        shipped = spec_term(b, vars_)
        claim, ref_fn, pre_fn = REFS[b.ident]
        ref = ref_fn(*vars_)
        pre = pre_fn(*vars_) if pre_fn else None

        cex = prove_equal(shipped, ref, vars_, pre)
        pretext = "" if pre is None else "   [assuming %s]" % pre
        if cex is None:
            print("OK    %s : %s%s" % (b.ident, claim, pretext))
            ok.append(b.ident)
            continue

        print("WRONG %s : does NOT compute \"%s\"" % (b.ident, claim))
        print("        counterexample: %s" % ", ".join(
            "%s=0x%016x" % (a, v) for a, v in zip(b.args, cex)))
        sub = [(z3.BitVec(a, W), z3.BitVecVal(v, W)) for a, v in zip(b.args, cex)]
        got = z3.simplify(z3.substitute(shipped, *sub))
        want = z3.simplify(z3.substitute(ref, *sub))
        print("        spec gives %s, description says %s" % (got, want))
        bad.append(b.ident)

        for label, alt_fn in ALTERNATIVES.get(b.ident, []):
            if alt_fn is None:
                continue
            if prove_equal(shipped, alt_fn(*vars_), vars_) is None:
                print("        -> it actually computes: %s" % label)
        if b.ident in RESTRICTIONS:
            label, rfn = RESTRICTIONS[b.ident]
            if prove_equal(shipped, ref, vars_, rfn(*vars_)) is None:
                print("        -> it does match the description when %s" % label)
            else:
                print("        -> still wrong even when %s" % label)

    print()
    print("matches description: %d/%d" % (len(ok), len(ok) + len(bad)))
    print("mismatching        : %s" % ", ".join(bad))


if __name__ == "__main__":
    main()
