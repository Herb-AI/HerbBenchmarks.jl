"""Emit data.jl + constants.jl for DreamCoder's text-editing domain.

`makeTextTasks.makeTasks()` generates its 128 tasks pseudo-randomly from
`random.seed(9)` and a vocabulary drawn from the SyGuS 2017 PBE_Strings_Track
benchmarks, so the task set is fully determined. This module reproduces it
without importing `dreamcoder` (which needs torch and dill), then also ports
`guessConstantStrings` -- DreamCoder hands each task the string constants it
is likely to need, and this benchmark puts them in that task's grammar.
"""
import os
import random
import re
import sys

from sexpdata import loads, Symbol

# Path to a checkout of https://github.com/ellisk42/ec, via $DREAMCODER_EC.
EC = os.environ.get("DREAMCODER_EC",
                    os.path.expanduser("~/ec"))
OUT_DIR = sys.argv[1]

delimiters = ['.', ',', ' ', '(', ')', '-']

WORDS = None


def randomPermutation(l):
    l = list(l)
    random.shuffle(l)
    return l


def crossProduct(a, b):
    b = list(b)
    for x in a:
        for y in b:
            yield x, y


def lcs(u, v):
    """Longest common substring; port of makeTextTasks.lcs."""
    t = {}
    for n in range(len(u) + 1):
        for m in range(len(v) + 1):
            if m == 0 or n == 0:
                t[(n, m)] = 0
                continue
            t[(n, m)] = 1 + t[(n - 1, m - 1)] if u[n - 1] == v[m - 1] else 0
    l, n, m = max((l, n, m) for (n, m), l in t.items())
    return u[n - l:n]


def load_pbe_observations(directory=f"{EC}/PBE_Strings_Track"):
    """Every string appearing in the SyGuS PBE_Strings_Track constraints."""
    observations = set()
    for f in sorted(os.listdir(directory)):
        if not f.endswith('.sl'):
            continue
        with open(os.path.join(directory, f)) as handle:
            expression = loads("(%s)" % handle.read())
        examples, declarative = [], False
        for e in expression:
            if len(e) == 0:
                continue
            if e[0] == Symbol('constraint'):
                e = e[1]
                if e[0] != Symbol('='):
                    continue
                inputs = e[1]
                if inputs[0] != Symbol('f'):
                    continue
                examples.append((inputs[1:], e[2]))
            elif e[0] == Symbol('synth-fun') and e[1] != Symbol('f'):
                declarative = True
                break
        if declarative:
            continue
        for xs, y in examples:
            for z in list(xs) + [y]:
                if isinstance(z, str):
                    observations.add(z)
    return observations


def randomWord(minimum=1, predicate=None):
    global WORDS
    if WORDS is None:
        observations = load_pbe_observations()

        def splitMany(s, ds):
            if not ds:
                return [s]
            d, ds = ds[0], ds[1:]
            return [w for z in s.split(d) for w in splitMany(z, ds) if len(w) > 0]

        WORDS = sorted({w for o in observations for w in splitMany(o, delimiters)})

    # DreamCoder thins out the over-represented length-3 words.
    while True:
        if random.random() > 0.7:
            candidate = random.choice([w for w in WORDS if len(w) >= minimum])
        else:
            candidate = random.choice(
                [w for w in WORDS if len(w) >= minimum and len(w) != 3])
        if predicate is None or predicate(candidate):
            return candidate


def randomWords(ds, minimum=1, lb=2, ub=4):
    words = [randomWord(minimum=minimum)
             for _ in range(random.choice(range(lb, ub + 1)))]
    s = ""
    for j, w in enumerate(words):
        if j > 0:
            s += random.choice(ds)
        s += w
    return s


def makeTasks():
    """Verbatim port of makeTextTasks.makeTasks()."""
    random.seed(9)
    NUMBEROFEXAMPLES = 4
    problems = []

    def problem(n, examples, needToTrain=False):
        problems.append((n, examples))

    for d1, d2 in randomPermutation(crossProduct(delimiters, delimiters))[:len(delimiters) * 2]:
        if d1 != d2:
            problem("Replace '%s' w/ '%s'" % (d1, d2),
                    [((x,), x.replace(d1, d2))
                     for _ in range(NUMBEROFEXAMPLES) for x in [randomWords(d1)]])
    for d in delimiters:
        problem("drop first word delimited by '%s'" % d,
                [((x,), d.join(x.split(d)[1:]))
                 for _ in range(NUMBEROFEXAMPLES) for x in [randomWords(d)]])
        for n in [0, 1, -1]:
            problem("nth (n=%d) word delimited by '%s'" % (n, d),
                    [((x,), x.split(d)[n])
                     for _ in range(NUMBEROFEXAMPLES) for x in [randomWords(d)]])
    for d1 in delimiters:
        problem("Append two words delimited by '%s'" % (d1),
                [((x, y), x + d1 + y)
                 for _ in range(NUMBEROFEXAMPLES)
                 for x in [randomWord()] for y in [randomWord()]])
    for d1, d2 in randomPermutation(crossProduct(delimiters, delimiters))[:len(delimiters)]:
        problem("Append two words delimited by '%s%s'" % (d1, d2),
                [((x, y), x + d1 + d2 + y)
                 for _ in range(NUMBEROFEXAMPLES)
                 for x in [randomWord()] for y in [randomWord()]])
    for n in range(1, 6):
        problem("Drop last %d characters" % n,
                [((x,), x[:-n])
                 for _ in range(NUMBEROFEXAMPLES) for x in [randomWord(minimum=n)]])
        if n > 1:
            problem("Take first %d characters" % n,
                    [((x,), x[:n])
                     for _ in range(NUMBEROFEXAMPLES) for x in [randomWord(minimum=n)]])
    for d1, d2 in randomPermutation(crossProduct(delimiters, delimiters))[:len(delimiters)]:
        problem("Extract word delimited by '%s' - '%s'" % (d1, d2),
                [((a + d1 + b + d2 + c + d + e,), b)
                 for _ in range(int(NUMBEROFEXAMPLES / 2))
                 for d in [d1, d2]
                 for a in [randomWord()] for b in [randomWord()]
                 for c in [randomWord()] for e in [randomWord()]])
    for n in range(len(delimiters)):
        problem("First letters of words (%s)" % ("I" * (1 + n)),
                [((x,), "".join(map(lambda z: z[0], x.split(' '))))
                 for _ in range(NUMBEROFEXAMPLES) for x in [randomWords(' ')]])
    for d in delimiters:
        problem("Take first character and append '%s'" % d,
                [((x,), x[0] + d)
                 for _ in range(NUMBEROFEXAMPLES) for x in [randomWord()]])
    for n in range(len(delimiters)):
        problem("Abbreviate separate words (%s)" % ("I" * (n + 1)),
                [((x, y), "%s.%s." % (x[0], y[0]))
                 for _ in range(NUMBEROFEXAMPLES)
                 for y in [randomWord()] for x in [randomWord()]])
        d = delimiters[n]
        problem("Abbreviate words separated by '%s'" % d,
                [((x + d + y,), "%s.%s." % (x[0], y[0]))
                 for _ in range(NUMBEROFEXAMPLES)
                 for y in [randomWord()] for x in [randomWord()]])
    for n in range(len(delimiters)):
        problem("Append 2 strings (%s)" % ('I' * (n + 1)),
                [((x, y), x + y)
                 for _ in range(NUMBEROFEXAMPLES)
                 for y in [randomWord()] for x in [randomWord()]])
    for n in range(len(delimiters)):
        w = randomWord(minimum=3)
        problem("Prepend '%s'" % w,
                [((x,), w + x) for _ in range(NUMBEROFEXAMPLES) for x in [randomWord()]])
        w = randomWord(minimum=3)
        problem("Append '%s'" % w,
                [((x,), x + w) for _ in range(NUMBEROFEXAMPLES) for x in [randomWord()]])
        w = randomWord(minimum=3)
        problem("Prepend '%s' to first word" % w,
                [((x + ' ' + y,), w + x)
                 for _ in range(NUMBEROFEXAMPLES)
                 for x in [randomWord()] for y in [randomWord()]])
    for n in range(1, 6):
        problem("parentheses around a single word (%s)" % ('I' * n),
                [((w,), "(%s)" % w) for _ in range(NUMBEROFEXAMPLES) for w in [randomWord()]])
    problem("parentheses around first word",
            [((w + " " + s,), "(%s)" % w)
             for _ in range(NUMBEROFEXAMPLES)
             for w in [randomWord()] for s in [randomWords(" ")]])
    problem("parentheses around second word",
            [((s,), "(%s)" % (s.split(" ")[1]))
             for _ in range(NUMBEROFEXAMPLES) for s in [randomWords(" ")]])
    allowed = [d for d in delimiters if d not in "()"]
    for d1, d2 in randomPermutation(crossProduct(allowed, allowed))[:len(delimiters)]:
        problem("parentheses around word delimited by '%s' & '%s'" % (d1, d2),
                [((prefix + d1 + word + d2 + suffix,),
                  prefix + d1 + '(' + word + ')' + d2 + suffix)
                 for _ in range(NUMBEROFEXAMPLES)
                 for prefix in [randomWords("", lb=0, ub=1)]
                 for suffix in [randomWords(allowed, ub=2, lb=1)]
                 for word in [randomWord()]])
    for n in range(7):
        w = randomWord(minimum=3)
        problem("ensure suffix `%s`" % w,
                [((s + (w if f else ""),), s + w)
                 for _ in range(NUMBEROFEXAMPLES)
                 for s in [randomWords(" ")]
                 for f in [random.choice([True, False])]])

    return problems


def guess_constant_strings(examples):
    """Port of `guessConstantStrings`: constants DreamCoder hands to the task."""
    guesses, N, T = {}, 10, 2
    for n in range(min(N, len(examples))):
        for m in range(n + 1, min(N, len(examples))):
            l = lcs(examples[n][1], examples[m][1])
            if len(l) > 2:
                guesses[l] = guesses.get(l, 0) + 1
    return sorted(g for g, f in guesses.items() if f >= T)


def sanitize(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def jl_string(s):
    out = s.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$")
    return '"%s"' % out


def main():
    tasks = makeTasks()
    data = ["# Auto-generated from DreamCoder's text-editing domain",
            "# (`dreamcoder/domains/text/makeTextTasks.py`, Ellis et al., 2021).",
            "#",
            "# DreamCoder represents strings as lists of characters; this benchmark",
            "# uses Julia `String`s, which the grammar's primitives operate on directly.",
            ""]
    consts = ["\"\"\"",
              "String constants DreamCoder hands to each task, recovered with its",
              "`guessConstantStrings` heuristic (repeated longest common substrings of",
              "the outputs). They become extra `Str` rules in that task's grammar --",
              "without them the tasks that prepend or append a fixed word are",
              "unsolvable.",
              "\"\"\"",
              "const PROBLEM_CONSTANTS = Dict{String,Vector{String}}("]
    arities = ["\"\"\"",
               "Number of arguments each text task takes (one or two).",
               "\"\"\"",
               "const PROBLEM_ARITIES = Dict{String,Int}("]
    names = ["\"\"\"",
             "DreamCoder's own name for each task. Identifiers have punctuation",
             "stripped -- several tasks differ only in which delimiter they use -- so",
             "this is where to look to find out what a task actually does.",
             "\"\"\"",
             "const PROBLEM_NAMES = Dict{String,String}("]

    seen = {}
    for i, (name, examples) in enumerate(tasks):
        base = sanitize(name)
        seen[base] = seen.get(base, 0) + 1
        if seen[base] > 1:
            base = "%s_%d" % (base, seen[base])
        ident = "%03d_%s" % (i, base)

        arity = len(examples[0][0])
        arities.append('    "%s" => %d,' % (ident, arity))
        names.append('    "%s" => %s,' % (ident, jl_string(name)))
        cs = guess_constant_strings(examples)
        consts.append('    "%s" => [%s],' % (ident, ", ".join(jl_string(c) for c in cs)))

        rows = []
        for xs, y in examples:
            ins = ", ".join(":_arg_%d => %s" % (j + 1, jl_string(x)) for j, x in enumerate(xs))
            rows.append("\tIOExample(Dict{Symbol, Any}(%s), %s)" % (ins, jl_string(y)))
        data.append('problem_%s = Problem("problem_%s", [' % (ident, ident))
        data.append(",\n".join(rows))
        data.append("])\n")

    consts.append(")")
    arities.append(")")
    names.append(")")

    with open(OUT_DIR + "/data.jl", "w") as f:
        f.write("\n".join(data))
    with open(OUT_DIR + "/metadata.jl", "w") as f:
        f.write("\n".join(arities) + "\n\n" + "\n".join(names)
                + "\n\n" + "\n".join(consts) + "\n")
    print("wrote %d text problems" % len(tasks))


if __name__ == "__main__":
    main()
