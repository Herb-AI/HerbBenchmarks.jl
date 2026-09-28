"""Sample IO examples for each Hacker's Delight spec with z3.

The reference implementation (`define-fun hdNN`) is asserted as a constraint

    (assert (= out (hdNN x y ...)))

and every example is a *model* of that constraint produced by the solver.

To get examples that are actually informative (rather than 10 random bit
patterns that all take the same path through the spec) the solver is driven with
extra assumptions on top of that constraint:

  * branch / predicate coverage - every Boolean subterm of the spec body (ite
    conditions, comparisons, and the Boolean result itself) is forced to true in
    one model and to false in another,
  * magnitude coverage - the first argument is pinned to 0, 1, all-ones and the
    sign bit,
  * randomised bit assumptions - a random subset of the input bits is pinned to
    random values (at a randomly chosen magnitude: 8/16/32/64 significant bits)
    and the solver fills in the rest,

and every model is required to differ from all previously sampled inputs.
Assumptions are only ever *added*; the spec constraint itself is untouched, so
every example is by construction consistent with the reference implementation.
"""
import random
import json
import z3

from parse_sl import all_benchmarks, sexpr_to_str

BOOL_HEADS = {"=", "bvule", "bvult", "bvugt", "bvuge", "bvsle", "bvslt",
              "bvsgt", "bvsge", "distinct", "and", "or", "not", "redor64"}

N_EXAMPLES = 10
SEED = 20260817


def bool_subterms(sexpr):
    """Boolean-typed subterms of the spec body, outermost first."""
    found = []

    def walk(s):
        if isinstance(s, str):
            return
        if s[0] in BOOL_HEADS:
            txt = sexpr_to_str(s)
            if txt not in found:
                found.append(txt)
        for child in s[1:]:
            walk(child)

    walk(sexpr)
    return found


class Sampler:
    def __init__(self, bench):
        self.b = bench
        self.rng = random.Random(SEED + int(bench.ident[3:]))

        decls = "\n".join(
            "(declare-const %s %s)" % (a, s) for a, s in zip(bench.args, bench.arg_sorts))
        out_decl = "(declare-const __out %s)" % bench.ret_sort
        call = "(%s %s)" % (bench.spec_name, " ".join(bench.args))
        self.smt2 = "\n".join([
            bench.smt2_prelude(), decls, out_decl,
            "(assert (= __out %s))" % call,
        ])

        self.vars = [z3.BitVec(a, 64) for a in bench.args]
        self.out = z3.Bool("__out") if bench.is_bool else z3.BitVec("__out", 64)

        self.solver = z3.Solver()
        self.solver.set("random_seed", SEED % 2**16)
        self.solver.add(z3.parse_smt2_string(self.smt2))

        # Arguments used as a shift distance / bit position (`k` in hd-19, hd-26)
        # are restricted to a meaningful range; outside [0, 63] every shift in
        # SMT-LIB collapses to 0 and the examples carry no information.
        for a, v in zip(bench.args, self.vars):
            if a == "k":
                self.solver.add(z3.ULT(v, z3.BitVecVal(64, 64)))

        self.inputs = []      # list of tuples of ints
        self.examples = []    # list of (tuple_of_ints, out_value)

    # -- helpers ---------------------------------------------------------
    def _parse_term(self, txt):
        """Parse an SMT2 term written over the spec's parameters."""
        return z3.parse_smt2_string(self.smt2 + "\n(assert %s)" % txt)[-1]

    def _distinct_from_previous(self):
        return [z3.Or([v != z3.BitVecVal(p, 64) for v, p in zip(self.vars, prev)])
                for prev in self.inputs]

    def _random_pins(self, prob=0.7):
        """Random bit assumptions, at a randomly chosen magnitude."""
        head, pins = [], []
        for i, (a, v) in enumerate(zip(self.b.args, self.vars)):
            if i > 0:
                # keep the extra arguments from collapsing to 0 (which would make
                # masks/shifts degenerate) whenever that is satisfiable
                head.append(v != z3.BitVecVal(0, 64))
            if a == "k":
                # shift distance: pin to a concrete, non-degenerate value
                head.append(v == z3.BitVecVal(self.rng.randint(1, 63), 64))
                continue
            width = self.rng.choice([8, 16, 32, 64, 64])
            for bit in range(64):
                if bit >= width:
                    pins.append(z3.Extract(bit, bit, v) == z3.BitVecVal(0, 1))
                elif self.rng.random() < prob:
                    pins.append(z3.Extract(bit, bit, v) ==
                                z3.BitVecVal(self.rng.getrandbits(1), 1))
        self.rng.shuffle(pins)
        return head + pins

    def _solve(self, hard, pins):
        """Model for `hard`, using as many of the (droppable) `pins` as possible."""
        s = self.solver
        s.push()
        s.add(self._distinct_from_previous())
        s.add(hard)
        result = None
        n = len(pins)
        while True:
            s.push()
            s.add(pins[:n])
            if s.check() == z3.sat:
                result = s.model()
                s.pop()
                break
            s.pop()
            if n == 0:
                break
            n //= 2
        s.pop()
        return result

    def _fresh_output(self):
        """Prefer a not-yet-seen output value; makes the example set informative."""
        seen = [o for _, o in self.examples]
        if self.b.is_bool:
            return [self.out != z3.BoolVal(o) for o in set(seen)]
        return [self.out != z3.BitVecVal(o, 64) for o in set(seen)]

    def _try(self, hard, pins=None):
        pins = pins if pins is not None else []
        # First ask for a model whose output is new; fall back if impossible.
        model = self._solve(hard + self._fresh_output(), pins)
        if model is None:
            model = self._solve(hard, pins)
        if model is None:
            return False
        ins = tuple(model.eval(v, model_completion=True).as_long() for v in self.vars)
        if ins in self.inputs:
            return False
        outv = model.eval(self.out, model_completion=True)
        out = z3.is_true(outv) if self.b.is_bool else outv.as_long()
        self.inputs.append(ins)
        self.examples.append((ins, out))
        return True

    # -- sampling --------------------------------------------------------
    def run(self):
        goals = []

        # 1. Boolean result of the spec (for the predicate benchmarks): both polarities.
        if self.b.is_bool:
            goals += [[self.out], [z3.Not(self.out)]]

        # 2. Every Boolean subterm of the spec body, both polarities.
        for txt in bool_subterms(self.b.rewrite_smt2(self.b.spec_body)):
            term = self._parse_term(txt)
            goals += [[term], [z3.Not(term)]]

        # 3. Magnitude corner cases for the first input.
        for val in (0, 1, 2**64 - 1, 2**63):
            goals.append([self.vars[0] == z3.BitVecVal(val, 64)])

        for g in goals:
            if len(self.examples) >= N_EXAMPLES:
                break
            # random pins keep the *other* arguments from collapsing to 0
            self._try(g, self._random_pins(prob=0.35))

        # 4. Fill the rest with randomised bit assumptions.
        attempts = 0
        while len(self.examples) < N_EXAMPLES and attempts < 200:
            attempts += 1
            self._try([], self._random_pins(prob=0.85))

        return self.examples


def main():
    out = {}
    for b in all_benchmarks():
        ex = Sampler(b).run()
        assert len(ex) == N_EXAMPLES, (b.ident, len(ex))
        out[b.ident] = {
            "name": b.name,
            "args": b.args,
            "is_bool": b.is_bool,
            "examples": [{"in": list(i), "out": o} for i, o in ex],
        }
        print("%-6s %s" % (b.ident, "-> Bool" if b.is_bool else ""))
        for i, o in ex:
            print("   ", ", ".join("0x%016x" % v for v in i), "=>",
                  (str(o).lower() if b.is_bool else "0x%016x" % o))
    with open("examples.json", "w") as f:
        json.dump(out, f, indent=1)


if __name__ == "__main__":
    main()
