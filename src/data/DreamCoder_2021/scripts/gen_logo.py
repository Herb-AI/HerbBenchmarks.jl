"""Emit data.jl + solutions.jl for DreamCoder's LOGO turtle-graphics domain.

Ports `parseLogo`'s surface language and the turtle semantics of
`solvers/logoLib/logoInterpreter.ml`, then for each of the 160 manual tasks

  * evaluates the reference program to a list of line segments,
  * centres and rasterises them to a 28x28 bitmap -- the image that specifies
    the task, and
  * re-prints the program as a Herb grammar expression, unrolling the loops
    whose body mentions the loop variable.

The rasteriser here is the one the Julia benchmark uses too, so targets and
candidate drawings are always compared under identical rendering.
"""
import math
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from sexpdata import loads, Symbol  # noqa: E402
from logo_sources import manual_logo_sources  # noqa: E402

OUT_DIR = sys.argv[1]

# Constants from solvers/program.ml
UNIT_ANGLE = 1.0      # logo_UA -- angles are measured in whole turns
UNIT_LENGTH = 1.0     # logo_UL
ZERO_ANGLE = 0.0      # logo_ZA
ZERO_LENGTH = 0.0     # logo_ZL
EPS_LENGTH = 0.05     # logo_epsL
EPS_ANGLE = 0.025     # logo_epsA
INFINITY = 20         # logo_IFTY

# Canvas, from solvers/logoLib/VGWrapper.ml: the drawing is centred and the
# canvas spans [-4.5, 4.5] on both axes, rendered at 28x28.
CANVAS_HALF_EXTENT = 4.5
RESOLUTION = 28


# --------------------------------------------------------------------------
# Turtle semantics
# --------------------------------------------------------------------------


class Turtle:
    def __init__(self):
        self.x = 0.0
        self.y = 0.0
        self.t = 0.0      # heading, in turns
        self.pen = True
        self.segments = []

    def move(self, length, angle):
        x2 = self.x + length * math.cos(self.t * 2 * math.pi)
        y2 = self.y + length * math.sin(self.t * 2 * math.pi)
        if self.pen:
            self.segments.append((self.x, self.y, x2, y2))
        self.x, self.y = x2, y2
        self.t += angle

    def run(self, node, env):
        for k in node:
            self.command(k, env)

    def command(self, k, env):
        assert isinstance(k, list), k
        head = k[0]
        if head == Symbol("move"):
            return self.move(self.expr(k[1], env), self.expr(k[2], env))
        if head in (Symbol("loop"), Symbol("for")):
            var, bound, body = k[1], int(self.expr(k[2], env)), k[3:]
            for i in range(bound):
                self.run(body, {**env, var: i})
            return
        if head == Symbol("embed"):
            saved = (self.x, self.y, self.t, self.pen)
            self.run(k[1:], env)
            self.x, self.y, self.t, self.pen = saved
            return
        if head == Symbol("p"):
            self.pen = not self.pen
            self.run(k[1:], env)
            self.pen = not self.pen
            return
        # a nested block of commands
        return self.run(k, env)

    def expr(self, e, env):
        if isinstance(e, (int, float)):
            # sexpdata reads the token `infinity` as a float; parseLogo maps it
            # onto logo_IFTY the same way.
            return INFINITY if e == float("inf") else e
        if isinstance(e, Symbol):
            if e in env:
                return env[e]
            name = str(e)
            const = {"1a": UNIT_ANGLE, "1d": UNIT_LENGTH, "1l": UNIT_LENGTH,
                     "0a": ZERO_ANGLE, "0d": ZERO_LENGTH, "0l": ZERO_LENGTH,
                     "epsilonAngle": EPS_ANGLE,
                     "epsilonDistance": EPS_LENGTH, "epsilonLength": EPS_LENGTH,
                     "infinity": INFINITY}
            assert name in const, "unknown symbol %s" % name
            return const[name]
        assert isinstance(e, list), e
        op, args = str(e[0]), [self.expr(a, env) for a in e[1:]]
        if op in ("/a", "/d", "/l"):
            return args[0] / args[1]
        if op in ("*a", "*d", "*l"):
            return args[0] * args[1]
        if op in ("+a", "+d", "+l", "+"):
            return args[0] + args[1]
        if op in ("-a", "-d", "-l"):
            return args[0] - args[1]
        raise AssertionError("unknown operator %s" % op)


def parse(source):
    node = loads("(%s)" % source)
    while len(node) == 1 and isinstance(node[0], list) and (
        not node[0] or not isinstance(node[0][0], Symbol) or
        str(node[0][0]) not in ("move", "loop", "for", "embed", "p")
    ):
        node = node[0]
    return node


# --------------------------------------------------------------------------
# Rendering
# --------------------------------------------------------------------------


def center(segments):
    """Centre the drawing on the origin; port of `center_logo_list`."""
    if not segments:
        return segments
    xs = [v for s in segments for v in (s[0], s[2])]
    ys = [v for s in segments for v in (s[1], s[3])]
    dx = (max(xs) - min(xs)) / 2.0 + min(xs)
    dy = (max(ys) - min(ys)) / 2.0 + min(ys)
    return [(x1 - dx, y1 - dy, x2 - dx, y2 - dy) for x1, y1, x2, y2 in segments]


def rasterize(segments):
    """Rasterise centred segments to a RESOLUTION x RESOLUTION boolean grid.

    Each segment is walked in steps of a third of a pixel and the pixel
    containing each step is set, which draws a connected one-pixel line
    without needing an anti-aliasing model.
    """
    grid = [[False] * RESOLUTION for _ in range(RESOLUTION)]
    scale = RESOLUTION / (2 * CANVAS_HALF_EXTENT)

    def plot(x, y):
        # Column from x, row from y with row 1 at the top.
        col = int(math.floor((x + CANVAS_HALF_EXTENT) * scale))
        row = int(math.floor((CANVAS_HALF_EXTENT - y) * scale))
        if 0 <= row < RESOLUTION and 0 <= col < RESOLUTION:
            grid[row][col] = True

    for x1, y1, x2, y2 in segments:
        length = math.hypot(x2 - x1, y2 - y1)
        steps = max(1, int(math.ceil(length * scale * 3)))
        for i in range(steps + 1):
            u = i / steps
            plot(x1 + u * (x2 - x1), y1 + u * (y2 - y1))
    return grid


# --------------------------------------------------------------------------
# Translation to a Herb grammar expression
# --------------------------------------------------------------------------


def uses_var(node, var):
    if isinstance(node, Symbol):
        return node == var
    if isinstance(node, list):
        return any(uses_var(x, var) for x in node)
    return False


INT_LITERALS = set()


def int_literal(n):
    if n == float("inf"):
        n = INFINITY
    n = int(n)
    INT_LITERALS.add(n)
    return str(n)


def length_expr(e, env):
    if isinstance(e, Symbol):
        if e in env:
            return int_literal(env[e])
        name = str(e)
        if name in ("1d", "1l"):
            return "unit_length"
        if name in ("0d", "0l"):
            return "zero_length"
        if name in ("epsilonLength", "epsilonDistance"):
            return "eps_length"
        raise AssertionError("not a length: %s" % name)
    if isinstance(e, (int, float)):
        return int_literal(e)
    op = str(e[0])
    if op in ("*d", "*l"):
        return "mul_length(%s, %s)" % (length_expr(e[1], env), int_arg(e[2], env))
    if op in ("/d", "/l"):
        return "div_length(%s, %s)" % (length_expr(e[1], env), int_arg(e[2], env))
    raise AssertionError("not a length: %s" % e)


def angle_expr(e, env):
    if isinstance(e, Symbol):
        name = str(e)
        if name == "1a":
            return "unit_angle"
        if name == "0a":
            return "zero_angle"
        if name == "epsilonAngle":
            return "eps_angle"
        raise AssertionError("not an angle: %s" % name)
    op = str(e[0])
    if op == "*a":
        return "mul_angle(%s, %s)" % (angle_expr(e[1], env), int_arg(e[2], env))
    if op == "/a":
        return "div_angle(%s, %s)" % (angle_expr(e[1], env), int_arg(e[2], env))
    if op == "+a":
        return "add_angle(%s, %s)" % (angle_expr(e[1], env), angle_expr(e[2], env))
    if op == "-a":
        return "sub_angle(%s, %s)" % (angle_expr(e[1], env), angle_expr(e[2], env))
    raise AssertionError("not an angle: %s" % e)


def int_arg(e, env):
    """An integer-valued argument: a literal, a loop variable, or `infinity`."""
    if isinstance(e, Symbol):
        if e in env:
            return int_literal(env[e])
        if str(e) == "infinity":
            return int_literal(INFINITY)
        raise AssertionError("not an int: %s" % e)
    if isinstance(e, (int, float)):
        return int_literal(e)
    if str(e[0]) == "+":
        return int_literal(Turtle().expr(e, env))
    raise AssertionError("not an int: %s" % e)


def ops_of(node, env):
    ops = []
    for k in node:
        ops.extend(command_to_julia(k, env))
    return ops


def chain(ops):
    out = ops[-1]
    for op in reversed(ops[:-1]):
        out = "seq(%s, %s)" % (op, out)
    return out


def command_to_julia(k, env):
    assert isinstance(k, list)
    head = k[0]
    if head == Symbol("move"):
        return ["move(%s, %s)" % (length_expr(k[1], env), angle_expr(k[2], env))]
    if head in (Symbol("loop"), Symbol("for")):
        var, bound, body = k[1], int(Turtle().expr(k[2], env)), k[3:]
        if bound <= 0:
            return []
        if uses_var(body, var):
            # A context-free grammar cannot bind the loop variable: unroll.
            ops = []
            for i in range(bound):
                ops.extend(ops_of(body, {**env, var: i}))
            return ops
        inner = ops_of(body, {**env, var: 0})
        return ["logo_loop(%s, %s)" % (int_literal(bound), chain(inner))] if inner else []
    if head == Symbol("embed"):
        inner = ops_of(k[1:], env)
        return ["logo_embed(%s)" % chain(inner)] if inner else []
    if head == Symbol("p"):
        inner = ops_of(k[1:], env)
        return ["pen_toggle(%s)" % chain(inner)] if inner else []
    return ops_of(k, env)


# --------------------------------------------------------------------------


def sanitize(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def julia_bitmatrix(grid):
    rows = ["    " + " ".join("1" if v else "0" for v in row) for row in grid]
    return "Bool[\n" + ";\n".join(rows) + "]"


def main():
    tasks = manual_logo_sources()

    data = ["# Auto-generated from DreamCoder's LOGO turtle-graphics domain",
            "# (`dreamcoder/domains/logo/makeLogoTasks.py`, Ellis et al., 2021).",
            "#",
            "# Each problem has a single example: the input is a fresh `TurtleState`",
            f"# and the output is the target picture, a {RESOLUTION}x{RESOLUTION} bitmap.",
            ""]
    sols = ["# Reference programs for the LOGO tasks, transcribed from",
            "# `makeLogoTasks.py` into this benchmark's grammar. Loops whose body",
            "# mentions the loop variable are unrolled, since a context-free grammar",
            "# has no way to bind one.",
            "#",
            "# Each entry is the `Sequence` of a solution; `reference_program` wraps",
            "# it in the grammar's `Start` rule.",
            "",
            "const REFERENCE_PROGRAMS = Dict{String,Expr}("]

    seen = {}
    for i, (name, source, _train) in enumerate(tasks):
        base = sanitize(name)
        seen[base] = seen.get(base, 0) + 1
        if seen[base] > 1:
            base = "%s_%d" % (base, seen[base])
        ident = "%03d_%s" % (i, base)

        node = parse(source)
        turtle = Turtle()
        turtle.run(node, {})
        grid = rasterize(center(turtle.segments))

        data.append('problem_%s = Problem("problem_%s", [' % (ident, ident))
        data.append("\tIOExample(Dict{Symbol, Any}(:_arg_1 => TurtleState()), %s)"
                    % julia_bitmatrix(grid))
        data.append("])\n")

        ops = ops_of(node, {})
        sols.append('    "%s" => :(%s),' % (ident, chain(ops)))

    sols.append(")")

    with open(OUT_DIR + "/data.jl", "w") as f:
        f.write("\n".join(data))
    with open(OUT_DIR + "/solutions.jl", "w") as f:
        f.write("\n".join(sols) + "\n")
    print("wrote %d LOGO problems; integer literals used: %d..%d"
          % (len(tasks), min(INT_LITERALS), max(INT_LITERALS)))


if __name__ == "__main__":
    main()
