"""Emit the Julia sources of the `Hackers_Delight` HerbBenchmarks submodule."""
import json
import os

from parse_sl import all_benchmarks

OUT = os.environ.get("HD_OUT_DIR", os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# SyGuS/SMT-LIB operator -> Julia primitive (see hd_primitives.jl)
OPS = {
    "bvnot": "bvnot", "bvand": "bvand", "bvor": "bvor", "bvxor": "bvxor",
    "bvneg": "bvneg", "bvadd": "bvadd", "bvsub": "bvsub", "bvmul": "bvmul",
    "bvudiv": "bvudiv", "bvurem": "bvurem", "bvsdiv": "bvsdiv", "bvsrem": "bvsrem",
    "bvshl": "bvshl", "bvlshr": "bvlshr", "bvashr": "bvashr",
    "bvult": "bvult", "bvule": "bvule", "bvugt": "bvugt", "bvuge": "bvuge",
    "bvslt": "bvslt", "bvsle": "bvsle", "bvsgt": "bvsgt", "bvsge": "bvsge",
    "bvredor": "bvredor", "ite": "ite",
    "=": "bveq", "not": "boolnot", "and": "booland", "or": "boolor",
}


def to_julia(sexpr, argmap):
    """Translate a SyGuS term into a Julia expression string."""
    if isinstance(sexpr, str):
        if sexpr in argmap:
            return argmap[sexpr]
        if sexpr.startswith("#x"):
            return "0x" + sexpr[2:]
        if sexpr in ("true", "false"):
            return sexpr
        return sexpr                      # nonterminal
    head, args = sexpr[0], sexpr[1:]
    assert head in OPS, "unknown operator %r" % head
    return "%s(%s)" % (OPS[head], ", ".join(to_julia(a, argmap) for a in args))


def wrap(expr, indent=4, width=100):
    """Break a long Julia call expression over multiple lines."""
    if len(expr) <= width:
        return expr
    # split the outermost argument list
    open_paren = expr.index("(")
    head, inner = expr[:open_paren], expr[open_paren + 1:-1]
    parts, depth, cur = [], 0, ""
    for ch in inner:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(cur)
            cur = ""
            continue
        cur += ch
    parts.append(cur)
    pad = " " * indent
    body = (",\n").join(pad + wrap(p.strip(), indent + 4, width) for p in parts)
    return "%s(\n%s\n%s)" % (head, body, " " * (indent - 4))


def header(b):
    desc = " ".join(b.description) or "(no description in the original file)"
    return desc


def main():
    os.makedirs(OUT, exist_ok=True)
    benches = all_benchmarks()
    examples = json.load(open("examples.json"))

    # ---------------- grammars.jl ----------------
    g = ['"""',
         'Grammars for the SyGuS Hacker\'s Delight benchmarks.',
         '',
         'Each `grammar_hd_NN` is the `synth-fun` grammar of `hd-NN.sl`, rule for rule and',
         'in the original order. `Start` is always the start symbol and carries the return',
         'type of the synthesised function; the second nonterminal (`StartBool` for the',
         'bit-vector problems, `StartBV` for the predicate problems) is the other sort.',
         'Arguments are named `_arg_1`, `_arg_2`, ... following the HerbBenchmarks',
         'convention; the mapping to the original SyGuS names is given per grammar.',
         '"""',
         '']
    for b in benches:
        argmap = {a: "_arg_%d" % (i + 1) for i, a in enumerate(b.args)}
        g.append("# %s: %s" % (b.name, header(b)))
        g.append("# arguments: " + ", ".join("%s = %s" % (v, k) for k, v in argmap.items()))
        g.append("grammar_%s = @cfgrammar begin" % b.ident)
        for nt_name, nt_sort, prods in b.nonterminals:
            for p in prods:
                g.append("    %s = %s" % (nt_name, to_julia(p, argmap)))
        g.append("end")
        g.append("")
    open(os.path.join(OUT, "grammars.jl"), "w").write("\n".join(g))

    # ---------------- solutions.jl ----------------
    s = ['"""',
         'Reference implementations of the Hacker\'s Delight benchmarks.',
         '',
         'Each `solution_hd_NN` is the `define-fun hdNN` of `hd-NN.sl` -- the ground truth',
         'the SyGuS `constraint` refers to -- transliterated into the primitives of',
         '`hd_primitives.jl`. These are the functions the IO examples in `data.jl` were',
         'sampled from, and they are what a synthesiser is expected to (re)discover.',
         '',
         'Note that some of them do *not* implement the natural-language comment at the top',
         'of their `.sl` file; see the README for the list.',
         '"""',
         '']
    for b in benches:
        argmap = {a: "_arg_%d" % (i + 1) for i, a in enumerate(b.args)}
        sig = ", ".join("%s::UInt64" % argmap[a] for a in b.args)
        ret = "Bool" if b.is_bool else "UInt64"
        body = wrap(to_julia(b.spec_body, argmap), indent=4)
        s.append("# %s: %s" % (b.name, header(b)))
        s.append("solution_%s(%s)::%s = %s" % (b.ident, sig, ret, body))
        s.append("")
    open(os.path.join(OUT, "solutions.jl"), "w").write("\n".join(s))

    # ---------------- data.jl ----------------
    d = ['"""',
         'IO examples for the SyGuS Hacker\'s Delight benchmarks.',
         '',
         'Ten examples per problem, every one of them a model of',
         '`(assert (= out (hdNN x ...)))` produced by z3 (see `README.md` for the sampling',
         'procedure). Inputs are 64-bit bit-vectors (`UInt64`); the output is a `UInt64`,',
         'except for hd_10, hd_11, hd_12 and hd_18 whose specification returns a `Bool`.',
         '"""',
         '']
    for b in benches:
        ex = examples[b.ident]["examples"]
        d.append("# %s: %s" % (b.name, header(b)))
        d.append('problem_%s = Problem("problem_%s", [' % (b.ident, b.ident))
        rows = []
        for e in ex:
            ins = ", ".join(":_arg_%d => 0x%016x" % (i + 1, v)
                            for i, v in enumerate(e["in"]))
            out = str(e["out"]).lower() if b.is_bool else "0x%016x" % e["out"]
            rows.append("    IOExample(Dict{Symbol,Any}(%s), %s)" % (ins, out))
        d.append(",\n".join(rows))
        d.append("])")
        d.append("")
    open(os.path.join(OUT, "data.jl"), "w").write("\n".join(d))

    print("wrote grammars.jl, solutions.jl, data.jl to", OUT)


if __name__ == "__main__":
    main()
