#!/usr/bin/env python3
"""Generate the Neo_PLDI18 benchmark (problems, grammars and solutions) from Neo's
DeepCoder PLDI'18 problem files.

Source: https://github.com/utopia-group/neo, folder problem/DeepCoder-pldi18
(100 files progN.json with fields `name`, `program` and `examples`).

Usage:
    python3 generate.py <path to neo/problem/DeepCoder-pldi18> [output folder]

The output folder defaults to the folder of this script. The script writes
data.jl, grammars.jl and solutions.jl. For every problem it translates Neo's
program into this benchmark's grammar, builds its RuleNode from the problem's own
grammar, and evaluates it on Neo's examples with this benchmark's semantics
(mirrored from list_functions.jl). Problems whose solution does not reproduce
Neo's outputs are written commented out, with the reason (see README.md).

The semantics below mirror list_functions.jl; if that file changes, update
`herb_eval` and rerun. `verify.jl` re-checks everything in Julia.
"""
import glob, json, os, re, sys
from collections import Counter

I64 = 2 ** 63

# ---------------------------------------------------------------------------
# Grammar template: the DeepCoder grammar used by this repository, with
# `access` (0-based) instead of `getindex`. Rule order matters: RuleNode
# indices refer to it. Start and argument rules are appended per problem.
# ---------------------------------------------------------------------------
TEMPLATE = [("ExprNum", str(c)) for c in range(-3, 4)] + [
    ("ExprNum", "maximum(ExprArr)"), ("ExprNum", "minimum(ExprArr)"), ("ExprNum", "sum(ExprArr)"),
    ("ExprNum", "first(ExprArr)"), ("ExprNum", "last(ExprArr)"), ("ExprNum", "access(ExprArr, ExprNum)"),
    ("ExprNum", "countSt(ExprArr, ExprNum)"), ("ExprNum", "countGt(ExprArr, ExprNum)"),
    ("ExprNum", "countEq(ExprArr, ExprNum)"), ("ExprNum", "countNeq(ExprArr, ExprNum)"),
    ("ExprNum", "countMod(ExprArr, ExprNum)"), ("ExprNum", "countNmod(ExprArr, ExprNum)"),
    ("ExprArr", "drop(ExprArr, ExprNum)"), ("ExprArr", "take(ExprArr, ExprNum)"),
    ("ExprArr", "sort(ExprArr)"), ("ExprArr", "reverse(ExprArr)"),
    ("ExprArr", "filterSt(ExprArr, ExprNum)"), ("ExprArr", "filterGt(ExprArr, ExprNum)"),
    ("ExprArr", "filterEq(ExprArr, ExprNum)"), ("ExprArr", "filterNeq(ExprArr, ExprNum)"),
    ("ExprArr", "filterMod(ExprArr, ExprNum)"), ("ExprArr", "filterNmod(ExprArr, ExprNum)"),
    ("ExprArr", "mapPlus(ExprArr, ExprNum)"), ("ExprArr", "mapMinus(ExprArr, ExprNum)"),
    ("ExprArr", "mapMult(ExprArr, ExprNum)"), ("ExprArr", "mapDiv(ExprArr, ExprNum)"),
    ("ExprArr", "mapPow(ExprArr, ExprNum)"),
    ("ExprArr", "zipwithMax(ExprArr, ExprArr)"), ("ExprArr", "zipwithMin(ExprArr, ExprArr)"),
    ("ExprArr", "zipwithPlus(ExprArr, ExprArr)"), ("ExprArr", "zipwithMinus(ExprArr, ExprArr)"),
    ("ExprArr", "zipwithMult(ExprArr, ExprArr)"),
    ("ExprArr", "scanl1Max(ExprArr)"), ("ExprArr", "scanl1Min(ExprArr)"), ("ExprArr", "scanl1Plus(ExprArr)"),
    ("ExprArr", "scanl1Minus(ExprArr)"), ("ExprArr", "scanl1Mult(ExprArr)"),
]


def grammar_for(arg_types, out_type):
    """arg_types: list of 'ExprArr'/'ExprNum' for _arg_1.._arg_n."""
    rules = list(TEMPLATE) + [("Start", out_type)]
    rules += [(t, f"_arg_{i+1}") for i, t in enumerate(arg_types)]
    return rules


def rule_index(rules, lhs, rhs):
    idx = [i + 1 for i, r in enumerate(rules) if r == (lhs, rhs)]
    assert len(idx) == 1, (lhs, rhs)
    return idx[0]


# ---------------------------------------------------------------------------
# Neo programs
# ---------------------------------------------------------------------------
def tokenize(s):
    toks = re.findall(r"\(|\)|\[id=\d+\]|l\([^)]*\)\.\([^)]*\)|[^\s()\[\]]+", s)
    return [t for t in toks if not t.startswith("[id=")]


def parse(toks, i=0):
    if toks[i] == "(":
        op = toks[i + 1]; i += 2; kids = []
        while toks[i] != ")":
            k, i = parse(toks, i); kids.append(k)
        return (op, kids), i + 1
    return toks[i], i + 1


SIMPLE = {"SORT": "sort", "REVERSE": "reverse", "HEAD": "first", "LAST": "last",
          "MINIMUM": "minimum", "MAXIMUM": "maximum", "SUM": "sum",
          "SCANL1-PLUS": "scanl1Plus", "SCANL1-MINUS": "scanl1Minus", "SCANL1-MUL": "scanl1Mult",
          "SCANL1-MAX": "scanl1Max", "SCANL1-MIN": "scanl1Min",
          "MAP-PLUS": "mapPlus", "MAP-MUL": "mapMult", "MAP-DIV": "mapDiv", "MAP-POW": "mapPow",
          "ZIPWITH-PLUS": "zipwithPlus", "ZIPWITH-MINUS": "zipwithMinus", "ZIPWITH-MUL": "zipwithMult",
          "ZIPWITH-MAX": "zipwithMax", "ZIPWITH-MIN": "zipwithMin",
          "TAKE": "take", "DROP": "drop", "ACCESS": "access"}
# Neo's lambdas l(a,b).(op a b) -> this benchmark's predicate suffix (see list_functions.jl:
# binopBoolSt(x, k) = x > k, binopBoolGt(x, k) = x < k, ...).
PRED = {"(> a b)": "St", "(< a b)": "Gt", "(== a b)": "Eq", "(!= a b)": "Neq",
        "(%= a b)": "Mod", "(%!= a b)": "Nmod"}
NUM_OUT = {"first", "last", "minimum", "maximum", "sum", "access"} | {"count" + p for p in PRED.values()}


def translate(t, argmap):
    """Neo tree -> (name, children); leaves ('_arg_k', []) or ('const', n)."""
    if isinstance(t, str):
        return (argmap[t], []) if t.startswith("input") else ("const", int(t))
    op, kids = t
    if op in ("FILTER", "COUNT"):
        lst, lam, k = kids
        p = PRED[re.sub(r"^l\(a,b\)\.", "", lam)]
        return (("filter" if op == "FILTER" else "count") + p, [translate(lst, argmap), translate(k, argmap)])
    return (SIMPLE[op], [translate(k, argmap) for k in kids])


def show(e):
    name, kids = e
    if name == "const":
        return str(kids)
    return name if not kids else f"{name}({', '.join(show(k) for k in kids)})"


def child_types(name):
    if name in ("access", "take", "drop") or name.startswith(("map", "filter", "count")):
        return ["ExprArr", "ExprNum"]
    if name.startswith("zipwith"):
        return ["ExprArr", "ExprArr"]
    return ["ExprArr"]


def to_rulenode(e, rules, nt, arg_types):
    """Return (julia RuleNode source, size)."""
    name, kids = e
    if name == "const":
        assert nt == "ExprNum", "constant in a list position"
        return f"RuleNode({rule_index(rules, 'ExprNum', str(kids))})", 1
    if name.startswith("_arg_"):
        t = arg_types[int(name[5:]) - 1]
        assert t == nt, f"{name} has type {t}, needed {nt}"
        return f"RuleNode({rule_index(rules, t, name)})", 1
    out_t = "ExprNum" if name in NUM_OUT else "ExprArr"
    assert out_t == nt, f"{name} returns {out_t}, needed {nt}"
    rhs = [r for (l, r) in rules if l == nt and r.startswith(name + "(")]
    assert len(rhs) == 1, name
    idx = rule_index(rules, nt, rhs[0])
    parts, size = [], 1
    for k, kt in zip(kids, child_types(name)):
        src, s = to_rulenode(k, rules, kt, arg_types)
        parts.append(src); size += s
    return f"RuleNode({idx}, AbstractRuleNode[{', '.join(parts)}])", size


# ---------------------------------------------------------------------------
# Semantics, mirrored from list_functions.jl (and Base for the rest)
# ---------------------------------------------------------------------------
# Switches to Neo's semantics, used only to diagnose why a solution fails (never to
# generate outputs): Java 32-bit wrap-around, Neo's x^(k+1), and 256 for out-of-range access.
NEO = {"wrap32": False, "pow": False, "access256": False}


class EvalError(Exception):
    def __init__(self, kind, msg):
        super().__init__(msg); self.kind = kind


def wrap(x):
    return (x + I64) % (2 * I64) - I64


def checked_mul(a, b):
    r = a * b
    if NEO["wrap32"]:
        return ((r + 2**31) % 2**32) - 2**31
    if not -I64 <= r < I64:
        raise EvalError("overflow", f"checked_mul({a}, {b}) overflows Int64")
    return r


def jdiv(a, b):
    if b == 0:
        raise EvalError("other", "div by zero")
    q = abs(a) // abs(b)
    return q if (a >= 0) == (b > 0) else -q


def jpow(a, b):
    if NEO["pow"]:  # Neo: res = a; for i in 1..b: res *= a
        r = a
        for _ in range(1, b + 1): r = ((r * a + 2**31) % 2**32) - 2**31
        return r
    if b < 0:
        if a == 1: return 1
        if a == -1: return -1 if b % 2 else 1
        raise EvalError("other", f"{a}^{b}: negative exponent")
    return wrap(a ** b)


def jrem(a, b):
    r = abs(a) % abs(b)
    return r if a >= 0 else -r


PREDS = {"St": lambda x, k: x > k, "Gt": lambda x, k: x < k, "Eq": lambda x, k: x == k,
         "Neq": lambda x, k: x != k, "Mod": lambda x, k: False if k == 0 else jrem(x, k) == 0,
         "Nmod": lambda x, k: True if k == 0 else jrem(x, k) != 0}
BIN = {"Plus": lambda a, b: wrap(a + b), "Minus": lambda a, b: wrap(a - b), "Mult": checked_mul,
       "Max": max, "Min": min, "Div": jdiv, "Pow": jpow}


def herb_eval(e, env):
    name, kids = e
    if name == "const": return kids
    if name.startswith("_arg_"): return env[name]
    v = [herb_eval(k, env) for k in kids]
    if name == "sort": return sorted(v[0])
    if name == "reverse": return v[0][::-1]
    if name in ("first", "last", "minimum", "maximum"):
        if not v[0]: raise EvalError("other", f"{name} of an empty list")
        return {"first": v[0][0], "last": v[0][-1], "minimum": min(v[0]), "maximum": max(v[0])}[name]
    if name == "sum":
        s = 0
        for x in v[0]: s = wrap(s + x)
        return s
    if name == "access":  # access(xs, n) = xs[n + 1]
        xs, n = v
        if not 0 <= n < len(xs) and NEO["access256"]: return 256
        if not 0 <= n < len(xs): raise EvalError("index", f"access at {n} in a list of length {len(xs)}")
        return xs[n]
    if name == "take":  # first(xs, n)
        xs, n = v
        if n < 0: raise EvalError("other", f"take with n = {n}")
        return xs[:n]
    if name == "drop":  # n >= length -> Int[], else xs[n+1:end]
        xs, n = v
        if n >= len(xs): return []
        if n < 0: raise EvalError("other", f"drop with n = {n}")
        return xs[n:]
    if name.startswith("scanl1"):
        f = BIN[name[6:]]; xs = v[0]
        if not xs: return []
        ys = [xs[0]]
        for x in xs[1:]: ys.append(f(ys[-1], x))
        return ys
    if name.startswith("map"):
        f = BIN[name[3:]]; return [f(x, v[1]) for x in v[0]]
    if name.startswith("zipwith"):
        f = BIN[name[7:]]; return [f(a, b) for a, b in zip(v[0], v[1])]
    if name.startswith("filter"):
        p = PREDS[name[6:]]; return [x for x in v[0] if p(x, v[1])]
    if name.startswith("count"):
        p = PREDS[name[5:]]; return sum(1 for x in v[0] if p(x, v[1]))
    raise ValueError(name)


def reproduces(e, examples):
    for ex in examples:
        env = {f"_arg_{j+1}": x for j, x in enumerate(ex["input"])}
        try:
            if herb_eval(e, env) != ex["output"]: return False
        except EvalError:
            return False
    return True


def diagnose(e, examples):
    """Smallest set of Neo-semantics switches under which the solution reproduces Neo's outputs."""
    import itertools
    keys = ["wrap32", "pow", "access256"]
    for n in range(1, 4):
        for combo in itertools.combinations(keys, n):
            for k in keys: NEO[k] = k in combo
            ok = reproduces(e, examples)
            for k in keys: NEO[k] = False
            if ok: return combo
    return None


def uses(e, op):
    name, kids = e
    return name == op or (name not in ("const",) and any(uses(k, op) for k in kids if isinstance(k, tuple)))


# ---------------------------------------------------------------------------
# Julia output
# ---------------------------------------------------------------------------
def jl(v):
    if isinstance(v, list):
        return "Int[]" if not v else "[" + ", ".join(str(x) for x in v) + "]"
    return str(v)


def comment(block, reason):
    lines = [f"# BENCHED ({reason})"] + ["# " + l if l else "#" for l in block.splitlines()]
    return "\n".join(lines)


REASONS = {
    "overflow": "Neo's Java ints wrap at 32 bits; Herb's checked multiplication throws",
    "power": "Neo's ^ computes x^(k+1) (loop bug in PrimitiveBinop.java); Herb's mapPow computes x^k",
    "index": "Neo returns 256 as a 'no value' placeholder out of range; access throws",
    "other": "solution does not reproduce Neo's outputs",
}


def main():
    src = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.dirname(os.path.abspath(__file__))
    files = sorted(glob.glob(os.path.join(src, "prog*.json")), key=lambda f: int(re.findall(r"\d+", os.path.basename(f))[0]))
    assert len(files) == 100, len(files)
    data, grams, sols, status = [], [], [], []
    names = set()
    for f in files:
        d = json.load(open(f))
        # number from the file name (progN.json), not from the `name` field: in Neo's
        # files, prog98.json is also named "prog48"
        num = int(re.findall(r"\d+", os.path.basename(f))[0])
        pname = f"{num:03d}"
        assert pname not in names, f"duplicate problem {pname}"
        names.add(pname)
        ex0 = d["examples"][0]
        arg_types = ["ExprArr" if isinstance(x, list) else "ExprNum" for x in ex0["input"]]
        out_type = "ExprArr" if isinstance(ex0["output"], list) else "ExprNum"
        rules = grammar_for(arg_types, out_type)
        argmap = {f"input{i}": f"_arg_{i+1}" for i in range(len(arg_types))}
        tree, _ = parse(tokenize(d["program"]))
        assert tree[0] == "root" and len(tree[1]) == 1
        e = translate(tree[1][0], argmap)
        rn, size = to_rulenode(e, rules, out_type, arg_types)
        rn = f"RuleNode({rule_index(rules, 'Start', out_type)}, AbstractRuleNode[{rn}])"
        size += 1

        kind, detail = "ok", ""
        for i, ex in enumerate(d["examples"]):
            env = {f"_arg_{j+1}": x for j, x in enumerate(ex["input"])}
            try:
                got = herb_eval(e, env)
            except EvalError as err:
                kind, detail = err.kind, f"example {i+1}: {err}"; break
            if got != ex["output"]:
                kind = "power" if uses(e, "mapPow") else "other"
                detail = f"example {i+1}: got {jl(got)}, Neo expects {jl(ex['output'])}"; break
        if kind != "ok":
            combo = diagnose(e, d["examples"])
            if combo:
                kind = "+".join({"wrap32": "overflow", "pow": "power", "access256": "index"}[c] for c in combo)
            else:
                kind = "other"
        status.append((pname, kind, size, show(e), detail))

        exs = []
        for ex in d["examples"]:
            args = ", ".join(f":_arg_{j+1} => {jl(x)}" for j, x in enumerate(ex["input"]))
            exs.append(f"\tIOExample(Dict{{Symbol, Any}}({args}), {jl(ex['output'])})")
        pblock = f'problem_{pname} = Problem("problem_{pname}", [\n' + ",\n".join(exs) + "\n])"
        gblock = f"grammar_{pname} = @csgrammar begin\n" + "\n".join(f"    {l} = {r}" for l, r in rules) + "\nend"
        sblock = (f"solution_{pname} = (\n    expr = :({show(e)}),\n    rulenode = {rn},\n    size = {size},\n"
                  f"    neo_program = {json.dumps(d['program'])},\n)")
        if kind == "ok":
            data.append(pblock); grams.append(gblock); sols.append(sblock)
        else:
            why = "; ".join(f"{k}: {REASONS[k]}" for k in kind.split("+")) + f"; {detail}"
            data.append(comment(pblock, why)); grams.append(comment(gblock, why)); sols.append(comment(sblock, why))

    hdr = ("# Generated by generate.py from Neo's problem/DeepCoder-pldi18 "
           "(https://github.com/utopia-group/neo). Do not edit by hand.\n"
           "# Problems whose solution does not reproduce Neo's outputs under this benchmark's\n"
           "# semantics are commented out (BENCHED), with the reason; see README.md.\n\n")
    open(os.path.join(out, "data.jl"), "w").write(hdr + "\n\n".join(data) + "\n")
    open(os.path.join(out, "grammars.jl"), "w").write(hdr + "\n\n".join(grams) + "\n")
    open(os.path.join(out, "solutions.jl"), "w").write(
        hdr + "# solution_N = (expr, rulenode, size, neo_program): Neo's program for problem N, translated to\n"
        "# this benchmark's grammar. `rulenode` uses grammar_N's rule indices (including Start), and\n"
        "# `size` is its number of nodes.\n\n" + "\n\n".join(sols) + "\n")
    json.dump([dict(problem=p, status=k, size=s, expr=x, detail=dt) for p, k, s, x, dt in status],
              open(os.path.join(out, "status.json"), "w"), indent=1)

    c = Counter(k for _, k, _, _, _ in status)
    print("status:", dict(c))
    ok_sizes = [s for _, k, s, _, _ in status if k == "ok"]
    print("solution sizes (ok):", dict(sorted(Counter(ok_sizes).items())), "mean", round(sum(ok_sizes) / len(ok_sizes), 2))
    for p, k, s, x, dt in status:
        if k != "ok":
            print(f"  benched {p} [{k}] {x} -- {dt}")


if __name__ == "__main__":
    main()
