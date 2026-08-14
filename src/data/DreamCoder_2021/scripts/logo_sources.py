"""Recover the (name, source) pairs of DreamCoder's manual LOGO tasks.

`manualLogoTasks()` only ever calls a local `T(...)` helper, which forwards to
`manualLogoTask` -- and that is the part that needs the OCaml renderer. Exec'ing
the function body with `manualLogoTask` stubbed out therefore yields the task
list without needing to build the renderer.
"""
import re

import os

# Path to a checkout of https://github.com/ellisk42/ec, via $DREAMCODER_EC.
EC = os.environ.get("DREAMCODER_EC",
                    os.path.expanduser("~/ec"))


def manual_logo_sources():
    src = open(f"{EC}/dreamcoder/domains/logo/makeLogoTasks.py").read()
    start = src.index("def manualLogoTasks():")
    rest = src[start + len("def manualLogoTasks():"):]
    end = re.search(r"^def ", rest, re.M).start()
    body = "def manualLogoTasks():" + rest[:end]

    recorded = []

    def manualLogoTask(name, source, proto=False, needToTrain=False,
                       supervise=False, lambdaCalculus=False):
        recorded.append((name, source, needToTrain))
        return None

    import random

    class random_seed:
        """Copy of `dreamcoder.utilities.random_seed`."""

        def __init__(self, seed):
            self.seed = seed

        def __enter__(self):
            self._oldSeed = random.getstate()
            random.seed(self.seed)
            return self

        def __exit__(self, type, value, traceback):
            random.setstate(self._oldSeed)

    ns = {"manualLogoTask": manualLogoTask,
          "random_seed": random_seed,
          "random": random}
    exec(compile(body, "manualLogoTasks", "exec"), ns)
    ns["manualLogoTasks"]()
    return recorded


if __name__ == "__main__":
    ts = manual_logo_sources()
    print(len(ts), "tasks")
    for name, source, train in ts[:10]:
        print(repr(name), "|", " ".join(source.split()))
