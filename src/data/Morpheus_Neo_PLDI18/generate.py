#!/usr/bin/env python3
"""Generate the Morpheus_Neo_PLDI18 benchmark (problems, grammars and solutions) from
Neo's Morpheus PLDI'18 problem files.

Source: https://github.com/utopia-group/neo (commit 1d3572f):
  - problem/Morpheus-PLDI/rN.json   the 50 problems Neo evaluates (one example each)
  - sketches/morpheus_pldi/benchN.txt  Neo's sketch for problem N: the sequence of
    components of a solution, without their arguments.

Usage:
    python3 generate.py <path to neo> [output folder]

The output folder defaults to the folder of this script. The script writes data.jl,
grammars.jl, solutions.jl and status.json. For every problem it builds Neo's grammar
(src/org/genesys/language/MorpheusGrammar.java), then searches the arguments of Neo's sketch for a program whose
output has the same contents as Neo's expected output (Neo's `hasSameContents`). The
programs are evaluated with this benchmark's semantics, mirrored below from
table_functions.jl; if that file changes, update this mirror and rerun. `verify.jl`
re-checks everything in Julia. Problems without a solution are written commented out,
with the reason (see README.md).
"""
import glob, json, os, re, sys

# ---------------------------------------------------------------------------
# Grammar: Neo's MorpheusGrammar with 1-based column indices. Rule order matters:
# RuleNode indices refer to it. Start, the inputs and the problem's constants are
# appended per problem.
# ---------------------------------------------------------------------------
MAX_COL = 6  # Neo: maxCol = 6 (column indices), maxColListSize = 2

COMPONENTS = [  # (name, argument types after the table)
    ("select", ["ColList"]),
    ("group_by", ["ColList"]),
    ("inner_join", ["Table"]),
    ("gather", ["ColList"]),
    ("spread", ["Col", "Col"]),
    ("unite", ["Col", "Col"]),
    ("summarise", ["Aggr", "Col"]),
    ("separate", ["Col"]),
    ("filter", ["BinopBool", "Col", "Const"]),
    ("mutate", ["BinopInt", "Col", "Col"]),
]
BINOP_INT = ["/"]
BINOP_BOOL = [">", "<", "==", "!="]
AGGR = ["mean", "minimum", "sum", "length"]  # Neo: mean, min, sum, count
COLS = list(range(1, MAX_COL + 1))
COL_LISTS = ([("pos", (i,)) for i in COLS]
             + [("pos", (i, j)) for i in COLS for j in COLS if i < j]
             + [("not", (i,)) for i in COLS]
             + [("not", (i, j)) for i in COLS for j in COLS if i < j])


def col_list_str(cl):
    kind, idx = cl
    v = "[" + ", ".join(map(str, idx)) + "]"
    return v if kind == "pos" else f"Not({v})"


TEMPLATE = (
    [("Table", f"{name}(Table, {', '.join(args)})") for name, args in COMPONENTS]
    + [("BinopInt", f"({op})") for op in BINOP_INT]
    + [("BinopBool", f"({op})") for op in BINOP_BOOL]
    + [("Aggr", a) for a in AGGR]
    + [("Col", str(i)) for i in COLS]
    + [("ColList", col_list_str(cl)) for cl in COL_LISTS]
)


def julia_value(v):
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$") + '"'
    return repr(v)


def grammar_for(n_inputs, consts):
    rules = list(TEMPLATE) + [("Start", "contents(Table)")]
    rules += [("Table", f"_arg_{i + 1}") for i in range(n_inputs)]
    rules += [("Const", julia_value(c)) for c in consts]
    return rules


# ---------------------------------------------------------------------------
# Tables. A table is (names, types, cols, groups): column names, column types
# ('i' Int, 'd' Float64, 's' String), column vectors, and the grouping columns
# (None if not grouped; a grouped table stands for Julia's GroupedDataFrame).
# ---------------------------------------------------------------------------
class Fail(Exception):
    pass


NUM = ("i", "d")


def jl_string(v):
    """Julia's `string(v)` for the values that occur here."""
    if isinstance(v, str):
        return v
    if isinstance(v, bool):
        raise ValueError("Bool values are not expected")
    if isinstance(v, int):
        return str(v)
    r = repr(float(v))
    if "e" in r:  # Python 1e-05 / Julia 1.0e-5 (generate() checks these do not occur)
        m, e = r.split("e")
        r = (m if "." in m else m + ".0") + "e" + str(int(e))
    return r


def col_type(values):
    """Column type as Neo (krangl's dataFrameOf) builds it from Neo's parsed JSON values."""
    if all(isinstance(v, str) for v in values):
        return "s"
    if any(isinstance(v, str) for v in values):
        raise ValueError("mixed string/number column")
    return "d" if any(isinstance(v, float) for v in values) else "i"


def make_table(header, content):
    n = len(header)
    assert len(content) % n == 0 and len(set(header)) == n
    raw = [[content[i] for i in range(j, len(content), n)] for j in range(n)]
    types = [col_type(c) for c in raw]
    cols = [[float(v) for v in c] if t == "d" else list(c) for c, t in zip(raw, types)]
    return (list(header), types, cols, None)


def neo_number(v):
    """Neo's ProblemDeserializer: whole numbers become ints, others doubles."""
    if isinstance(v, str):
        return v
    return int(v) if float(v) % 1 == 0 else float(v)


def nrow(t):
    return len(t[2][0]) if t[2] else 0


def ungroup(t):
    return (t[0], t[1], t[2], None)


def name_at(t, i):
    if not 1 <= i <= len(t[0]):
        raise Fail("column index out of range")
    return i - 1


def resolve(t, cl):
    kind, idx = cl
    pos = [name_at(t, i) for i in idx]
    return pos if kind == "pos" else [j for j in range(len(t[0])) if j not in pos]


def fresh(t, k, *op):
    """Names for k new columns, from the operation, its arguments and its input table (as
    `_fresh` in table_functions.jl): two columns get the same name only if the same
    computation made them. Only this equality matters, not the names themselves."""
    return [f"MORPHEUS_{hash((op, i, fingerprint(t))) & 0xffffffff:08x}" for i in range(1, k + 1)]


def sub(t, js, rows=None):
    names, types, cols, _ = t
    rows = range(nrow(t)) if rows is None else rows
    return ([names[j] for j in js], [types[j] for j in js], [[cols[j][r] for r in rows] for j in js], None)


def rows_of(t):
    return [tuple(c[r] for c in t[2]) for r in range(nrow(t))]


def first_appearance_groups(t, js):
    groups = {}
    for r in range(nrow(t)):
        groups.setdefault(tuple(t[2][j][r] for j in js), []).append(r)
    return groups  # dicts keep insertion order: groups in order of first appearance


def op_select(t, cl):
    t = ungroup(t)
    return sub(t, resolve(t, cl))


def op_group_by(t, cl):
    t = ungroup(t)
    if cl[0] != "pos":
        raise Fail("group_by takes a list of columns, not a negated one")
    return (t[0], t[1], t[2], [t[0][j] for j in resolve(t, cl)])


def op_inner_join(a, b):
    a, b = ungroup(a), ungroup(b)
    on = [n for n in a[0] if n in b[0]]
    ai = [a[0].index(n) for n in on]
    bi = [b[0].index(n) for n in on]
    arest = [j for j in range(len(a[0])) if j not in ai]
    brest = [j for j in range(len(b[0])) if j not in bi]
    out_rows = []
    for ra in range(nrow(a)):
        ka = tuple(a[2][j][ra] for j in ai)
        for rb in range(nrow(b)):
            if ka == tuple(b[2][j][rb] for j in bi):
                out_rows.append((ra, rb))
    names = on + [a[0][j] for j in arest] + [b[0][j] for j in brest]
    types = [a[1][j] for j in ai] + [a[1][j] for j in arest] + [b[1][j] for j in brest]
    cols = ([[a[2][j][ra] for ra, _ in out_rows] for j in ai]
            + [[a[2][j][ra] for ra, _ in out_rows] for j in arest]
            + [[b[2][j][rb] for _, rb in out_rows] for j in brest])
    if len(set(names)) != len(names):
        raise Fail("duplicate column names")
    return (names, types, cols, None)


def op_gather(t, cl):
    t = ungroup(t)
    which = resolve(t, cl)
    if not which:
        raise Fail("gather needs at least one column")
    ids = [j for j in range(len(t[0])) if j not in which]
    key, value = fresh(t, 2, "gather", tuple(t[0][j] for j in which))
    n = nrow(t)
    numeric = all(t[1][j] in NUM for j in which)
    vtype = ("d" if any(t[1][j] == "d" for j in which) else "i") if numeric else "s"
    conv = (lambda v: float(v)) if vtype == "d" else (lambda v: v) if vtype == "i" else jl_string
    names = [t[0][j] for j in ids] + [key, value]
    types = [t[1][j] for j in ids] + ["s", vtype]
    cols = [t[2][j] * len(which) for j in ids]
    cols.append([t[0][w] for w in which for _ in range(n)])
    cols.append([conv(t[2][w][r]) for w in which for r in range(n)])
    return (names, types, cols, None)


def op_spread(t, ck, cv):
    t = ungroup(t)
    k, v = name_at(t, ck), name_at(t, cv)
    if k == v:
        raise Fail("spread key and value must differ")
    ids = [j for j in range(len(t[0])) if j not in (k, v)]
    keys = list(dict.fromkeys(t[2][k]))
    new = [jl_string(x) for x in keys]
    if len(set(new)) != len(new) or set(new) & {t[0][j] for j in ids}:
        raise Fail("spread column name clash")
    out = {}
    for r in range(nrow(t)):
        cells = out.setdefault(tuple(t[2][j][r] for j in ids), {})
        if t[2][k][r] in cells:
            raise Fail("spread: duplicate key in a row")
        cells[t[2][k][r]] = t[2][v][r]
    if any(len(c) != len(keys) for c in out.values()):
        raise Fail("spread: missing combination")
    names = [t[0][j] for j in ids] + new
    types = [t[1][j] for j in ids] + [t[1][v]] * len(new)
    rowkeys = list(out)
    cols = [[rk[i] for rk in rowkeys] for i in range(len(ids))]
    cols += [[out[rk][x] for rk in rowkeys] for x in keys]
    return (names, types, cols, None)


def op_unite(t, c1, c2):
    t = ungroup(t)
    i, j = name_at(t, c1), name_at(t, c2)
    if i == j:
        raise Fail("unite columns must differ")
    rest = [x for x in range(len(t[0])) if x not in (i, j)]
    new = fresh(t, 1, "unite", t[0][i], t[0][j])[0]
    vals = [jl_string(a) + "_" + jl_string(b) for a, b in zip(t[2][i], t[2][j])]
    pos = min(i, j)
    names = [t[0][x] for x in rest]
    types = [t[1][x] for x in rest]
    cols = [t[2][x] for x in rest]
    names.insert(pos, new); types.insert(pos, "s"); cols.insert(pos, vals)
    return (names, types, cols, None)


SEP = re.compile(r"\.|-|_|\|")


def op_separate(t, c):
    t = ungroup(t)
    i = name_at(t, c)
    if t[1][i] != "s":
        raise Fail("separate needs a string column")
    parts = [SEP.split(s) for s in t[2][i]]
    if any(len(p) != 2 for p in parts):
        raise Fail("separate: not exactly two parts")
    a, b = fresh(t, 2, "separate", t[0][i])
    names = t[0][:i] + [a, b] + t[0][i + 1:]
    types = t[1][:i] + ["s", "s"] + t[1][i + 1:]
    cols = t[2][:i] + [[p[0] for p in parts], [p[1] for p in parts]] + t[2][i + 1:]
    return (names, types, cols, None)


def aggregate(aggr, typ, xs):
    if aggr == "length":
        return len(xs), "i"
    if typ not in NUM:
        raise Fail("aggregate needs a numeric column")
    if aggr == "sum":
        return float(sum(xs)), "d"
    if aggr == "minimum":
        return float(min(xs)), "d"
    return sum(xs) / len(xs), "d"  # mean


def op_summarise(t, aggr, c):
    i = name_at(t, c)
    new = fresh(t, 1, "summarise", aggr, t[0][i])[0]
    if t[3] is None:
        v, typ = aggregate(aggr, t[1][i], t[2][i])
        return ([new], [typ], [[v]], None)
    gj = [t[0].index(g) for g in t[3]]
    groups = first_appearance_groups(t, gj)
    vals = [aggregate(aggr, t[1][i], [t[2][i][r] for r in rows]) for rows in groups.values()]
    typ = vals[0][1] if vals else ("i" if aggr == "length" else "d")
    names = [t[0][j] for j in gj] + [new]
    types = [t[1][j] for j in gj] + [typ]
    cols = [[g[x] for g in groups] for x in range(len(gj))] + [[v for v, _ in vals]]
    return (names, types, cols, None)


def op_filter(t, op, c, value):
    t = ungroup(t)
    i = name_at(t, c)
    xs = t[2][i]
    if op in (">", "<"):
        if t[1][i] not in NUM or not isinstance(value, int):
            raise Fail("> and < need a numeric column and an integer constant")
        gt = [x > value for x in xs]
        keep = gt if op == ">" else [not g for g in gt]  # Neo's < is "not >"
    else:
        eq = [type(x) is type(value) and x == value for x in xs]
        keep = eq if op == "==" else [not e for e in eq]
    return sub(t, range(len(t[0])), [r for r in range(len(xs)) if keep[r]])


def op_mutate(t, op, c1, c2):
    t = ungroup(t)
    i, j = name_at(t, c1), name_at(t, c2)
    if t[1][i] not in NUM or t[1][j] not in NUM:
        raise Fail("mutate needs numeric columns")
    new = fresh(t, 1, "mutate", op, t[0][i], t[0][j])[0]
    vals = []
    for a, b in zip(t[2][i], t[2][j]):
        if b == 0:
            raise Fail("division by zero")  # Julia gives Inf/NaN; never part of a solution here
        vals.append(a / b)
    return (t[0] + [new], t[1] + ["d"], t[2] + [vals], None)


OPS = {"select": op_select, "group_by": op_group_by, "inner_join": op_inner_join,
       "gather": op_gather, "spread": op_spread, "unite": op_unite,
       "summarise": op_summarise, "separate": op_separate, "filter": op_filter,
       "mutate": op_mutate}

# ---------------------------------------------------------------------------
# Neo's comparison (hasSameContents in Neo's fork of krangl, src/main/kotlin/krangl/Reshape.kt): same number of rows and
# columns, and every row of each table, as a set of strings, is approximately a subset
# of some row of the other. Strings that look like numbers are compared with tolerance
# 1e-5. Column names, column order and row order are ignored.
# ---------------------------------------------------------------------------
NUMBER = re.compile(r"-?\d+(\.\d+)?")


def approx_eq(a, b):
    if NUMBER.fullmatch(a) and NUMBER.fullmatch(b):
        return abs(float(a) - float(b)) < 1e-5
    return a == b


def row_sets(t):
    return [{jl_string(v) for v in row} for row in rows_of(t)]


def covered(ra, rb):
    return all(any(all(any(approx_eq(x, y) for y in s) for x in r) for s in rb) for r in ra)


def strictly_same(a, b):
    """Stricter than Neo: the same rows (as a multiset) once the columns of `a` are matched
    one-to-one with those of `b`, in any order. Names are ignored; numbers compared as in
    approx_eq. Used to prefer reference solutions; not part of the benchmark."""
    if len(a[0]) != len(b[0]) or nrow(a) != nrow(b):
        return False
    key = lambda v: ("n", round(float(jl_string(v)), 5)) if NUMBER.fullmatch(jl_string(v)) else ("s", jl_string(v))
    ca = [[key(v) for v in c] for c in a[2]]
    cb = [[key(v) for v in c] for c in b[2]]

    def match(i, used, perm):
        if i == len(ca):
            rows_a = sorted(zip(*[ca[j] for j in range(len(ca))]))
            rows_b = sorted(zip(*[cb[perm[j]] for j in range(len(ca))]))
            return rows_a == rows_b
        return any(match(i + 1, used | {j}, perm + [j]) for j in range(len(cb))
                   if j not in used and sorted(cb[j]) == sorted(ca[i]))
    return match(0, frozenset(), [])


def cell_key(v):
    """As `_cell_key` in table_functions.jl."""
    if isinstance(v, str) and not NUMBER.fullmatch(v):
        return (1, 0.0, v)
    r = round(float(v), 5)
    return (0, 0.0 if r == 0 else r, "")


def contents(t):
    """As `contents` in table_functions.jl: the sorted rows, each the sorted keys of its cells."""
    return sorted(sorted(cell_key(v) for v in row) for row in rows_of(t))


def same_table(a, b):
    if len(a[0]) != len(b[0]) or nrow(a) != nrow(b):
        return False
    ra, rb = row_sets(a), row_sets(b)
    return covered(ra, rb) and covered(rb, ra)


# ---------------------------------------------------------------------------
# Solution search: Neo's sketch fixes the components; search their arguments.
# A program is a chain: each component takes the previous table (the first takes an
# input). inner_join's other table is an input or an earlier table, on either side.
# A node is (rule_lhs, rule_rhs, children).
# ---------------------------------------------------------------------------
def leaf(lhs, rhs):
    return (lhs, rhs, [])


def arg_domain(comp, consts):
    """Argument tuples (value, node) for a component, in grammar order."""
    types = dict(COMPONENTS)[comp]
    domains = []
    for typ in types:
        if typ == "ColList":
            domains.append([(cl, leaf("ColList", col_list_str(cl))) for cl in COL_LISTS])
        elif typ == "Col":
            domains.append([(i, leaf("Col", str(i))) for i in COLS])
        elif typ == "Aggr":
            domains.append([(a, leaf("Aggr", a)) for a in AGGR])
        elif typ == "BinopBool":
            domains.append([(o, leaf("BinopBool", f"({o})")) for o in BINOP_BOOL])
        elif typ == "BinopInt":
            domains.append([(o, leaf("BinopInt", f"({o})")) for o in BINOP_INT])
        elif typ == "Const":
            domains.append([(c, leaf("Const", julia_value(c))) for c in consts])
    out = [[]]
    for d in domains:
        out = [p + [x] for p in out for x in d]
    return out


def fingerprint(t):
    return (tuple(t[0]), tuple(t[1]), tuple(tuple(c) for c in t[2]), tuple(t[3] or ()))


def components(node):
    """Number of component nodes (Table rules other than inputs) in a program."""
    lhs, rhs, kids = node
    return (lhs == "Table" and bool(kids)) + sum(components(k) for k in kids)


def search(inputs, target, sketch, consts, budget=5_000_000):
    """Return (node, table, strict) for the first program found, or None. The program's
    output must have the same `contents` as the target; one that also matches strictly
    (`strictly_same`) is preferred.

    Each component takes the previous component's table. As in Neo's sketches, a
    component may instead start again from an input when an inner_join comes later, and
    inner_join takes, besides the current table, an input or any earlier table (on either
    side). The program must use every component of the sketch."""
    joins_after = [("inner_join" in sketch[i + 1:]) for i in range(len(sketch))]
    roots = [(t, leaf("Table", f"_arg_{k + 1}")) for k, t in enumerate(inputs)]
    seen = set()
    steps = [0]

    def tables_for(i, cur):
        """(table, node) pairs component i can take as its (first) table."""
        if cur is None:
            return list(roots)
        return [cur] + (list(roots) if joins_after[i] else [])

    def rec(i, cur, earlier):
        if i == len(sketch):
            table, node = cur
            if components(node) == len(sketch) and contents(table) == target_contents:
                if strictly_same(table, target):
                    return node, table
                if loose[0] is None:  # same contents, but not strictly the same table
                    loose[0] = (node, table)
            return None
        comp = sketch[i]
        for t, tn in tables_for(i, cur):
            if comp == "inner_join":
                for o, on in earlier:
                    for (a, an), (b, bn) in [((t, tn), (o, on)), ((o, on), (t, tn))]:
                        steps[0] += 1
                        try:
                            nxt = op_inner_join(a, b)
                        except Fail:
                            continue
                        r = step(i, nxt, ("Table", "inner_join(Table, Table)", [an, bn]), earlier)
                        if r:
                            return r
                continue
            rhs = dict((n, f"{n}(Table, {', '.join(a)})") for n, a in COMPONENTS)[comp]
            for args in arg_domain(comp, consts):
                steps[0] += 1
                if steps[0] > budget:
                    raise TimeoutError
                try:
                    nxt = OPS[comp](t, *[a for a, _ in args])
                except Fail:
                    continue
                r = step(i, nxt, ("Table", rhs, [tn] + [n for _, n in args]), earlier)
                if r:
                    return r
        return None

    def step(i, nxt, node, earlier):
        if i + 1 == len(sketch):
            if len(nxt[0]) != len(target[0]) or nrow(nxt) != nrow(target):
                return None
            return rec(i + 1, (nxt, node), earlier)
        # Skip tables already reached at this step. When an inner_join comes later, the
        # earlier tables it could take matter too.
        context = tuple(render(n) for _, n in earlier) if joins_after[i] else ()
        key = (i, fingerprint(nxt), context)
        if key in seen:
            return None
        seen.add(key)
        return rec(i + 1, (nxt, node), earlier + [(nxt, node)])

    loose = [None]
    target_contents = contents(target)
    found = rec(0, None, list(roots))
    if found:
        return found + (True,)
    return loose[0] + (False,) if loose[0] else None


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
def render(node):
    lhs, rhs, kids = node
    if not kids:
        return rhs
    name = rhs.split("(")[0]
    return f"{name}({', '.join(render(k) for k in kids)})"


def rulenode(node, rules):
    lhs, rhs, kids = node
    idx = rules.index((lhs, rhs)) + 1
    if not kids:
        return f"RuleNode({idx})"
    return f"RuleNode({idx}, AbstractRuleNode[{', '.join(rulenode(k, rules) for k in kids)}])"


def size(node):
    return 1 + sum(size(k) for k in node[2])


def df_julia(t, indent):
    names, types, cols, _ = t
    pad = " " * indent
    lines = [f'{pad}    {julia_value(n)} => [{", ".join(julia_value(v) for v in c)}],'
             for n, c in zip(names, cols)]
    return "DataFrame(\n" + "\n".join(lines) + f"\n{pad})"


def comment_out(text):
    return "\n".join("# " + line if line else "#" for line in text.split("\n"))


def problem_consts(inputs):
    """Neo's constants: every value of the input tables (after column typing), deduplicated
    by type and value. Order: first appearance, inputs in order, row by row."""
    seen, out = set(), []
    for t in inputs:
        for row in rows_of(t):
            for v in row:
                k = (type(v), v)
                if k not in seen:
                    seen.add(k)
                    out.append(v)
    return out


def check_number_format(tables, pid):
    for t in tables:
        for c in t[2]:
            for v in c:
                if isinstance(v, float) and v != 0 and not (1e-4 <= abs(v) < 1e6):
                    raise ValueError(f"{pid}: {v} would print in scientific notation")


HEADER = ("# Generated by generate.py from Neo's problem/Morpheus-PLDI and sketches/morpheus_pldi "
          "(https://github.com/utopia-group/neo). Do not edit by hand.\n"
          "# Problems without a solution under this benchmark's semantics are commented out "
          "(BENCHED), with the reason; see README.md.\n")


def generate(neo, out):
    files = sorted(glob.glob(os.path.join(neo, "problem", "Morpheus-PLDI", "r*.json")),
                   key=lambda f: int(re.findall(r"\d+", os.path.basename(f))[0]))
    data, grammars, solutions, status = [HEADER], [HEADER], [HEADER + (
        "\n# solution_N = (expr, rulenode, size, neo_sketch): a program for problem N whose output has\n"
        "# the expected contents (see `contents`), with the components of Neo's sketch.\n"
        "# `rulenode` uses grammar_N's rule indices (including Start), and `size` is its number of nodes.\n")], []
    for f in files:
        num = int(re.findall(r"\d+", os.path.basename(f))[0])
        pid = f"{num:03d}"
        prob = json.load(open(f))
        (ex,) = prob["examples"]
        inputs = [make_table(t["header"], [neo_number(v) for v in t["content"]]) for t in ex["input"]]
        target = make_table(ex["output"]["header"], [neo_number(v) for v in ex["output"]["content"]])
        check_number_format(inputs + [target], pid)
        sketch = open(os.path.join(neo, "sketches", "morpheus_pldi", f"bench{num}.txt")).read().split()
        consts = problem_consts(inputs)
        rules = grammar_for(len(inputs), consts)
        try:
            found = search(inputs, target, sketch, consts)
            reason = None if found else "no program with Neo's sketch reproduces Neo's output"
        except TimeoutError:
            found, reason = None, "search budget exhausted"

        ins = ",\n".join(f"        :_arg_{k + 1} => {df_julia(t, 8)}" for k, t in enumerate(inputs))
        p = (f'problem_{pid} = Problem("problem_{pid}", [\n'
             f"    IOExample(Dict{{Symbol, Any}}(\n{ins}\n    ), contents({df_julia(target, 4)}))\n])")
        g = "\n".join([f"grammar_{pid} = @csgrammar begin"]
                      + [f"    {lhs} = {rhs}" for lhs, rhs in rules] + ["end"])
        entry = {"problem": pid, "neo_name": prob["name"], "sketch": " ".join(sketch),
                 "inputs": len(inputs), "constants": len(consts), "rules": len(rules)}
        if found:
            node, _, strict = found
            root = ("Start", "contents(Table)", [node])
            s = (f"solution_{pid} = (\n    expr = :({render(root)}),\n"
                 f"    rulenode = {rulenode(root, rules)},\n    size = {size(root)},\n"
                 f'    neo_sketch = "{" ".join(sketch)}",\n)')
            entry.update(status="ok", size=size(root), expr=render(root), strict=strict)
        else:
            s = f'solution_{pid} = nothing  # BENCHED ({reason}); Neo\'s sketch: {" ".join(sketch)}'
            entry.update(status="benched", reason=reason)
        if not found:
            p, g, s = (f"# BENCHED ({reason})\n" + comment_out(x) for x in (p, g, s))
        data.append(p); grammars.append(g); solutions.append(s); status.append(entry)
        print(pid, entry["status"], entry.get("strict", ""), entry.get("expr", entry.get("reason")), flush=True)

    for name, parts in [("data.jl", data), ("grammars.jl", grammars), ("solutions.jl", solutions)]:
        with open(os.path.join(out, name), "w") as fh:
            fh.write("\n\n".join(parts) + "\n")
    with open(os.path.join(out, "status.json"), "w") as fh:
        json.dump(status, fh, indent=1)
        fh.write("\n")


if __name__ == "__main__":
    if len(sys.argv) not in (2, 3):
        sys.exit(__doc__)
    generate(sys.argv[1], sys.argv[2] if len(sys.argv) == 3 else os.path.dirname(os.path.abspath(__file__)))
