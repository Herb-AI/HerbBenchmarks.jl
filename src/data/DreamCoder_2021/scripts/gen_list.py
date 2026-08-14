"""Emit HerbBenchmarks-style data.jl for the DreamCoder list-processing tasks."""
import json
import os
import re
import sys

# Path to a checkout of https://github.com/ellisk42/ec, via $DREAMCODER_EC.
EC = os.environ.get("DREAMCODER_EC",
                    os.path.expanduser("~/ec"))
OUT = sys.argv[1]


def sanitize(name):
    s = name.lower()
    s = re.sub(r"[^a-z0-9]+", "_", s)
    return s.strip("_")


def jl(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, list):
        if not v:
            return "Int[]"
        return "[" + ", ".join(jl(x) for x in v) + "]"
    raise TypeError(v)


def main():
    tasks = json.load(open(f"{EC}/data/list_tasks.json"))

    lines = [
        "# Auto-generated from DreamCoder's `data/list_tasks.json` (Ellis et al., 2021).",
        "# 217 list-processing tasks, 15 input/output examples each.",
        "",
    ]
    identifiers = []
    int_input = []

    for i, t in enumerate(tasks):
        ident = f"{i:03d}_{sanitize(t['name'])}"
        identifiers.append((ident, t["name"], t["type"]["input"], t["type"]["output"]))
        if t["type"]["input"] == "int":
            int_input.append(ident)

        exs = []
        for ex in t["examples"]:
            exs.append(
                "\tIOExample(Dict{Symbol, Any}(:_arg_1 => %s), %s)"
                % (jl(ex["i"]), jl(ex["o"]))
            )
        lines.append(f'problem_{ident} = Problem("problem_{ident}", [')
        lines.append(",\n".join(exs))
        lines.append("])\n")

    with open(OUT, "w") as f:
        f.write("\n".join(lines))

    print(f"wrote {len(tasks)} problems to {OUT}")
    print("int-input tasks:", int_input)


if __name__ == "__main__":
    main()
