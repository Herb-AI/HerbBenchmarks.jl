"""Parser for the SyGuS .sl Hacker's Delight benchmark files."""
import re, os, glob

# Directory holding hd-01.sl ... hd-27.sl (SyGuS benchmark repo, `bitvector/hackers-delight`).
BENCH_DIR = os.environ.get("HD_SL_DIR", os.path.expanduser("~/hackers-delight"))


def strip_comments(text):
    out = []
    for line in text.split("\n"):
        idx = line.find(";")
        if idx >= 0:
            line = line[:idx]
        out.append(line)
    return "\n".join(out)


def leading_comments(text):
    """Comment lines at the very top of the file (the natural language description)."""
    lines = []
    for line in text.split("\n"):
        s = line.strip()
        if not s:
            if lines:
                break
            continue
        if s.startswith(";"):
            lines.append(s.lstrip("; ").rstrip())
        else:
            break
    return lines


def tokenize(text):
    text = text.replace("(", " ( ").replace(")", " ) ")
    return text.split()


def parse_sexprs(text):
    tokens = tokenize(strip_comments(text))
    pos = 0

    def parse():
        nonlocal pos
        tok = tokens[pos]
        pos += 1
        if tok == "(":
            lst = []
            while tokens[pos] != ")":
                lst.append(parse())
            pos += 1
            return lst
        assert tok != ")", "unbalanced"
        return tok

    res = []
    while pos < len(tokens):
        res.append(parse())
    return res


def sexpr_to_str(s):
    if isinstance(s, str):
        return s
    return "(" + " ".join(sexpr_to_str(x) for x in s) + ")"


def sort_to_smt2(s):
    """(BitVec 64) -> (_ BitVec 64); Bool -> Bool"""
    if isinstance(s, str):
        return s
    if len(s) == 2 and s[0] == "BitVec":
        return "(_ BitVec %s)" % s[1]
    return sexpr_to_str(s)


class Benchmark:
    def __init__(self, path):
        self.path = path
        self.name = os.path.basename(path)[:-3]          # hd-01
        self.ident = self.name.replace("-", "_")          # hd_01
        text = open(path).read()
        self.description = leading_comments(text)
        forms = parse_sexprs(text)

        self.spec = None
        self.synth = None
        for f in forms:
            if f[0] == "define-fun":
                self.spec = f
            elif f[0] == "synth-fun":
                self.synth = f
        assert self.spec is not None and self.synth is not None

        # define-fun <name> ((x (BitVec 64)) ...) <ret> <body>
        _, self.spec_name, spec_args, spec_ret, self.spec_body = self.spec
        self.args = [a[0] for a in spec_args]
        self.arg_sorts = [sort_to_smt2(a[1]) for a in spec_args]
        self.ret_sort = sort_to_smt2(spec_ret)
        self.is_bool = self.ret_sort == "Bool"

        # synth-fun f (args) ret (grammar)
        _, _, synth_args, synth_ret, grammar = self.synth
        self.synth_args = [a[0] for a in synth_args]
        assert self.synth_args == self.args, (self.synth_args, self.args)
        # grammar: list of (NT sort (prods...))
        self.nonterminals = []
        for nt in grammar:
            nt_name, nt_sort, prods = nt
            self.nonterminals.append((nt_name, sort_to_smt2(nt_sort), prods))

    # ---- SMT2 rendering -------------------------------------------------
    def smt2_prelude(self):
        """define-fun for the spec, in valid SMT-LIB, plus bvredor helper."""
        lines = []
        lines.append("(define-fun redor64 ((a (_ BitVec 64))) Bool (distinct a #x0000000000000000))")
        argdecl = " ".join("(%s %s)" % (a, s) for a, s in zip(self.args, self.arg_sorts))
        body = sexpr_to_str(self.rewrite_smt2(self.spec_body))
        lines.append("(define-fun %s (%s) %s %s)" % (self.spec_name, argdecl, self.ret_sort, body))
        return "\n".join(lines)

    def rewrite_smt2(self, s):
        if isinstance(s, str):
            return s
        head = s[0]
        rest = [self.rewrite_smt2(x) for x in s[1:]]
        if head == "bvredor":
            head = "redor64"
        return [head] + rest


def all_benchmarks():
    return [Benchmark(p) for p in sorted(glob.glob(os.path.join(BENCH_DIR, "hd-*.sl")))]


if __name__ == "__main__":
    for b in all_benchmarks():
        print("=" * 70)
        print(b.name, "| args:", b.args, "| ret:", b.ret_sort)
        print("  desc:", " ".join(b.description))
        print("  NTs:", [(n, s, len(p)) for n, s, p in b.nonterminals])
        print("  spec:", sexpr_to_str(b.rewrite_smt2(b.spec_body))[:200])
