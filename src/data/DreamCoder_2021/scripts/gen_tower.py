"""Emit data.jl + solutions.jl for DreamCoder's block-tower domain.

Ports the task list of `dreamcoder/domains/tower/makeTowerTasks.py` and the
semantics of `dreamcoder/domains/tower/tower_common.py`, then

  * evaluates each reference program to a *plan* (blocks in placement order),
  * runs DreamCoder's `simulateWithoutPhysics` + `centerTower` to get the
    settled, translation-normalised tower that specifies the task, and
  * re-prints each reference program as a Herb grammar expression, unrolling
    the `for` loops whose body mentions the loop variable (a context-free
    grammar cannot bind one).
"""
import re
import sys

from sexpdata import loads, Symbol

OUT_DIR = sys.argv[1]

# --------------------------------------------------------------------------
# The task list, transcribed from makeTowerTasks.makeSupervisedTasks()
# --------------------------------------------------------------------------


def make_task_sources():
    tasks = []

    def T(name, source):
        tasks.append((name, source))

    for n in range(1, 9):
        T("arch leg %d" % n, "((for i %d v) (r 4) (for i %d v) (l 2) h)" % (n, n))
    for n in range(3, 7):
        T("arch stack %d" % n, "(for i %d v (r 4) v (l 2) h (l 2))" % n)
    for n in range(2, 8):
        for l in range(1, 6):
            T("bridge (%d) of arch %d" % (n, l),
              "(for j %d (for i %d v (r 4) v (l 4)) (r 2) h (r 4))" % (n, l))
    for n, l in [(3, 7), (4, 8)]:
        T("bridge (%d) of arch, spaced %d" % (n, l),
          "(for j %d (embed v (r 4) v (l 2) h ) (r %d))" % (n, l))
    for n in range(1, 7):
        T("Josh (%d)" % n,
          "(for i %d h (l 2) v (r 2) v (r 2) v (l 2) h (r 6))" % n)
    for n in range(3, 8):
        T("R staircase %d" % n,
          "(for i %d (for j i (embed v (r 4) v (l 2) h)) (r 6))" % n)
    for n in range(3, 8):
        T("L staircase %d" % n,
          "(for i %d (for j i (embed v (r 4) v (l 2) h)) (l 6))" % n)
    for o, n, s in [('h', 4, 7), ('v', 5, 3)]:
        T("%s row %d, spacing %d" % (o, n, s), "(for j %d %s (r %s))" % (n, o, s))

    for n in range(2, 6):
        T("arch pyramid %d" % n,
          "((for i %d (for j i (embed v (r 4) v (l 2) h)) (r 6))"
          " (for i %d (for j (- %d i) (embed v (r 4) v (l 2) h)) (r 6)))" % (n, n, n))
    for n in range(4, 6):
        T("H pyramid %d" % n,
          "((for i %d (for j i h) (r 6)) (for i %d (for j (- %d i) h) (r 6)))" % (n, n, n))
    for n in range(4, 8):
        T("H 1/2 pyramid %d" % n,
          "(for i %d (r 6) (embed (for j i h (l 3))))" % n)
    for n in range(2, 8):
        T("arch 1/2 pyramid %d" % n,
          "(for i %d (r 6) (embed (for j i (embed v (r 4) v (l 2) h) (l 3))))" % n)

    for w in range(3, 7):
        for h in range(1, 6):
            T("brickwall, %dx%d" % (w, h),
              "(for j %d (embed (for i %d h (r 6))) (embed (r 3) (for i %d h (r 6))))" % (h, w, w))
    for w in range(4, 8):
        for h in range(3, 6):
            T("aqueduct: %dx%d" % (w, h),
              "(for j %d %s (r 4) %s (l 2) h (l 2) v (r 4) v (l 2) h (r 4))"
              % (w, "v " * h, "v " * h))

    for b1, b2, w1, w2 in [(5, 2, 4, 5)]:
        T("%dx%d-bridge on top of %dx%d bricks" % (b1, b2, w1, w2),
          "((for j %d (embed (for i %d h (r 6))) (embed (r 3) (for i %d h (r 6))))"
          " (r 1) (for j %d (for i %d v (r 4) v (l 4)) (r 2) h (r 4)))"
          % (w1, w2, w2, b1, b2))
    for w1, w2, p in [(2, 5, 2)]:
        T("%d pyramid on top of %dx%d bricks" % (p, w1, w2),
          "((for j %d (embed (for i %d h (r 6))) (embed (r 3) (for i %d h (r 6))))"
          " (r 1) (for i %d (for j i (embed v (r 4) v (l 2) h)) (r 6))"
          " (for i %d (for j (- %d i) (embed v (r 4) v (l 2) h)) (r 6)))"
          % (w1, w2, w2, p, p, p))
    for t, w1, w2 in [(4, 1, 3)]:
        T("%d tower on top of %dx%d bricks" % (t, w1, w2),
          "((for j %d (embed (for i %d h (r 6))) (embed (r 3) (for i %d h (r 6))))"
          " (r 6) %s (r 4) %s (l 2) h)" % (w1, w2, w2, "v " * t, "v " * t))

    return tasks


# --------------------------------------------------------------------------
# Semantics (port of tower_common.py / towerPrimitives.py)
# --------------------------------------------------------------------------

BLOCKS = {"v": (1, 3), "h": (3, 1)}  # name -> (w, h), doubled when placed


class Ev:
    """Evaluate a parsed tower program to a plan: [(x, w, h), ...]."""

    def __init__(self):
        self.hand = 0
        self.plan = []

    def block(self, name):
        w, h = BLOCKS[name]
        self.plan.append((self.hand, w * 2, h * 2))

    def run(self, node, env):
        # node is a list of commands (a block) or a single command
        for k in node:
            self.command(k, env)

    def command(self, k, env):
        if k == Symbol("v") or k == Symbol("1x3"):
            return self.block("v")
        if k == Symbol("h") or k == Symbol("3x1"):
            return self.block("h")
        assert isinstance(k, list), k
        head = k[0]
        if head == Symbol("r"):
            self.hand += self.expr(k[1], env)
            return
        if head == Symbol("l"):
            self.hand -= self.expr(k[1], env)
            return
        if head == Symbol("for"):
            var = k[1]
            bound = self.expr(k[2], env)
            for i in range(bound):
                self.run(k[3:], {**env, var: i})
            return
        if head == Symbol("embed"):
            saved = self.hand
            self.run(k[1:], env)
            self.hand = saved
            return
        # a nested block of commands, e.g. ((for ...) (r 4) ...)
        self.run(k, env)

    def expr(self, e, env):
        if isinstance(e, int):
            return e
        if isinstance(e, Symbol):
            return env[e]
        assert isinstance(e, list)
        if e[0] == Symbol("+"):
            return self.expr(e[1], env) + self.expr(e[2], env)
        if e[0] == Symbol("-"):
            return self.expr(e[1], env) - self.expr(e[2], env)
        raise AssertionError(e)


def parse(source):
    node = loads("(%s)" % source)
    # `(...)` around a source that is already a single parenthesised block
    # yields [[...]]; unwrap so that `run` always sees a list of commands.
    while len(node) == 1 and isinstance(node[0], list) and not (
        node[0] and node[0][0] in (Symbol("r"), Symbol("l"), Symbol("for"), Symbol("embed"))
    ):
        node = node[0]
    return node


def simulate_without_physics(plan):
    """Settle each block onto whatever is below it; port of tower_common.py."""
    def overlap(b, other):
        (x, w, h) = b
        (x_, y_, w_, h_) = other
        if x_ - w_ / 2 >= x + w / 2 or x - w / 2 >= x_ + w_ / 2:
            return None
        return y_ + h_ // 2 + h // 2

    world = []
    for b in plan:
        heights = [b[2] // 2] + [y for o in world if (y := overlap(b, o)) is not None]
        x, w, h = b
        world.append((x, max(heights), w, h))
    return sorted(world)


def center(world):
    """Translate so the tower is centred on x=0; port of `centerTower`."""
    if not world:
        return world
    xs = [x for x, _, _, _ in world]
    c = int((max(xs) - min(xs)) / 2.0) + min(xs)
    return sorted((x - c, y, w, h) for x, y, w, h in world)


# --------------------------------------------------------------------------
# Translation to a Herb grammar expression
# --------------------------------------------------------------------------


def uses_var(node, var):
    if isinstance(node, Symbol):
        return node == var
    if isinstance(node, list):
        return any(uses_var(x, var) for x in node)
    return False


def ops_of(node, env):
    ops = []
    for k in node:
        ops.extend(command_to_julia(k, env))
    return ops


def chain(ops):
    """Fold a list of operations into `seq(op, seq(op, ...))`."""
    out = ops[-1]
    for op in reversed(ops[:-1]):
        out = "seq(%s, %s)" % (op, out)
    return out


def to_julia(node, env):
    ops = ops_of(node, env)
    if not ops:
        raise ValueError("empty command sequence")
    return chain(ops)


def command_to_julia(k, env):
    """Translate one command; returns a list of operation strings."""
    if k == Symbol("v") or k == Symbol("1x3"):
        return ["place_v"]
    if k == Symbol("h") or k == Symbol("3x1"):
        return ["place_h"]
    assert isinstance(k, list)
    head = k[0]
    if head == Symbol("r"):
        return ["move_right(%d)" % Ev().expr(k[1], env)]
    if head == Symbol("l"):
        return ["move_left(%d)" % Ev().expr(k[1], env)]
    if head == Symbol("for"):
        var, bound, body = k[1], Ev().expr(k[2], env), k[3:]
        if bound <= 0:
            return []
        if uses_var(body, var):
            # The loop variable is a binder, which a context-free grammar
            # cannot express: unroll.
            ops = []
            for i in range(bound):
                ops.extend(ops_of(body, {**env, var: i}))
            return ops
        inner = ops_of(body, {**env, var: 0})
        return ["tower_loop(%d, %s)" % (bound, chain(inner))] if inner else []
    if head == Symbol("embed"):
        inner = ops_of(k[1:], env)
        return ["tower_embed(%s)" % chain(inner)] if inner else []
    return ops_of(k, env)


# --------------------------------------------------------------------------


def sanitize(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def main():
    tasks = make_task_sources()
    data, sols = [], []
    max_const = 0

    data.append("# Auto-generated from DreamCoder's block-tower domain")
    data.append("# (`dreamcoder/domains/tower/makeTowerTasks.py`, Ellis et al., 2021).")
    data.append("#")
    data.append("# Each problem has a single example: the input is a fresh `TowerState`")
    data.append("# and the output is the target tower — the blocks `(x, y, w, h)` after")
    data.append("# settling under `simulateWithoutPhysics` and centring on x = 0.")
    data.append("")
    sols.append("# Reference programs for the block-tower tasks, transcribed from")
    sols.append("# `makeTowerTasks.py` into this benchmark's grammar. `for` loops whose")
    sols.append("# body mentions the loop variable are unrolled, since a context-free")
    sols.append("# grammar has no way to bind one.")
    sols.append("#")
    sols.append("# Each entry is the `Sequence` of a solution; `reference_program`")
    sols.append("# wraps it in the grammar's `Start` rule.")
    sols.append("")
    sols.append("const REFERENCE_PROGRAMS = Dict{String,Expr}(")

    for i, (name, source) in enumerate(tasks):
        ident = "%03d_%s" % (i, sanitize(name))
        node = parse(source)
        ev = Ev()
        ev.run(node, {})
        target = center(simulate_without_physics(ev.plan))

        blocks = ", ".join("(%d, %d, %d, %d)" % b for b in target)
        data.append('problem_%s = Problem("problem_%s", [' % (ident, ident))
        data.append("\tIOExample(Dict{Symbol, Any}(:_arg_1 => TowerState()), "
                    "Tuple{Int,Int,Int,Int}[%s])" % blocks)
        data.append("])\n")

        jl = to_julia(node, {})
        max_const = max([max_const] + [int(m) for m in re.findall(r"\((\d+)", jl)])
        sols.append('    "%s" => :(%s),' % (ident, jl))

    sols.append(")")

    with open(OUT_DIR + "/data.jl", "w") as f:
        f.write("\n".join(data))
    with open(OUT_DIR + "/solutions.jl", "w") as f:
        f.write("\n".join(sols) + "\n")
    print("wrote %d tower problems; largest integer literal used: %d"
          % (len(tasks), max_const))


if __name__ == "__main__":
    main()
