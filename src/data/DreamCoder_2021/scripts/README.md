# Regenerating the DreamCoder_2021 data

The `data.jl`, `solutions.jl`, `metadata.jl` and `signatures.jl` files in the
sub-benchmark directories next to this one are generated rather than
hand-written. These are the scripts that produce them.

You only need this if you want to re-derive the benchmark from upstream — the
generated files are committed, so using the benchmark needs none of it.

## Setup

Clone the DreamCoder reference implementation and point `$DREAMCODER_EC` at
it:

```sh
git clone https://github.com/ellisk42/ec
export DREAMCODER_EC=$PWD/ec
```

The Python scripts need `sexpdata` (but *not* torch, dill, or the OCaml
solvers — the task definitions are recovered without running DreamCoder):

```sh
pip install sexpdata
```

## Running

From the repository root:

```sh
DATA=src/data/DreamCoder_2021
GEN=$DATA/scripts

python $GEN/gen_list.py  $DATA/List_2021/data.jl
python $GEN/gen_text.py  $DATA/Text_2021
python $GEN/gen_tower.py $DATA/Tower_2021
julia  $GEN/gen_physics.jl $DATA/Physics_2021/data.jl

# LOGO is two steps: the Python script recovers the reference programs, then
# the Julia script renders the targets by running those programs through the
# benchmark's own renderer.
python $GEN/gen_logo.py $DATA/LOGO_2021
julia --project=. $GEN/gen_logo_data.jl $DATA/LOGO_2021
```

`gen_logo.py` also writes a `data.jl`, which `gen_logo_data.jl` then
overwrites. That is deliberate: rendering the targets from Julia keeps the
specification and the evaluator on exactly the same floating-point code path,
so a target can never disagree with its own reference program over a rounding
difference. Run the two in that order.

## What each script does

| Script | Output | Notes |
|:---|:---|:---|
| `gen_list.py` | `List_2021/data.jl` | Straight conversion of `data/list_tasks.json`. |
| `gen_text.py` | `Text_2021/data.jl`, `metadata.jl` | Re-runs `makeTextTasks()`, which is seeded and so deterministic, without importing `dreamcoder`. Also ports `guessConstantStrings`. |
| `gen_tower.py` | `Tower_2021/data.jl`, `solutions.jl` | Transcribes `makeSupervisedTasks()`, evaluates each program to a settled tower, and re-prints it in this benchmark's grammar. |
| `logo_sources.py` | — | Helper: recovers the 160 `(name, source)` pairs by exec'ing `manualLogoTasks()` with the renderer stubbed out. |
| `gen_logo.py` | `LOGO_2021/solutions.jl` | Translates each LOGO program into this benchmark's grammar, unrolling index-dependent loops. |
| `gen_logo_data.jl` | `LOGO_2021/data.jl` | Renders the targets by running `solutions.jl` through the benchmark's grammar and rasteriser. |
| `gen_physics.jl` | `Physics_2021/data.jl`, `signatures.jl` | Ports the 61 laws of `bin/scientificLaws.py` and samples examples from a fixed seed. |

The physics data is sampled from `Xoshiro(20210608)`; regenerating it on a
Julia version with a different stream would produce different (equally valid)
examples, so the generated file is the source of truth.
