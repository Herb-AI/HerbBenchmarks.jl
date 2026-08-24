# Minecraft Houses (3D-Craft)

![A program building house_0030: walls, roof, windows, doorway](example.gif)

[3D-Craft](https://github.com/facebookresearch/voxelcnn) (Chen et al., ICCV
2019) is 2,586 Minecraft houses built by crowdworkers, each given 30 minutes
and no instruction. Every house is recorded as the **ordered** sequence of
blocks the human placed and broke, which is the point of the dataset and of the
paper's order-aware model. The data was collected under
[CraftAssist](https://github.com/facebookresearch/craftassist) (Gray et al.,
2019).

Here each house is a target structure and the task is to write a program that
builds it.

## What the task is

A problem's input is an empty `HouseState`; its output is the finished canvas, a
`Dict{NTuple{3,Int},Int}` from cell to Minecraft 1.12 block id, with `y` up.
Coordinates are translated so the house's lowest corner is the origin.

The interesting part is compression. Replaying a human's build one block at a
time is 150 to 700 nodes. The same house is usually a wall ring, a roof and a
handful of details. For `house_0030`, 443 nodes of replay compress to 110:

```julia
reference_program("house_0030")   # 443 nodes, the human's recorded order
compact_program("house_0030")     # 110 nodes, the same house
```

Both are shipped, so the gap a synthesiser is asked to close is concrete.

Two things are dropped in translation. Block *metadata* (facing and colour
variants) is not kept, so a house is cell to block id alone. And breaks are
replayed rather than preserved: a house is the net result of its placements and
removals.

## Grammar

Two halves. `select`, `place`, `remove` and the cursor moves are 3D-Craft's own
recorded action alphabet, one rule per thing a human can do. The rest are the
bulk shapes a human is implicitly making when they lay a wall block by block;
without them a 100-block house is a 100-deep program.

```
Start     = build_house(Sequence, _arg_1)
Sequence  = Operation | seq(Operation, Sequence)
Operation = select(Block) | place | remove
          | move_x(Offset) | move_y(Offset) | move_z(Offset)
          | fill_x(Offset) | fill_y(Offset) | fill_z(Offset)
          | fill_box(Extent, Extent, Extent)
          | box_shell(Extent, Extent, Extent)
          | repeat_op(Count, Sequence)
          | embed(Sequence)
Offset    = -8..-1, 1..8        # signed; zero would be a move of nothing
Extent    = -8..8               # includes zero: a box flat in one axis is a roof
Count     = 2..8
Block      <one rule per block type this house uses>
```

`embed` runs a sequence and restores the cursor, so an excursion to build a
detail need not be counted back by hand.

### One grammar per house

Every problem carries its own `grammar_house_<n>`, offering exactly the block
types its house is made of. The dataset uses 199 block ids overall but a median
of ten per house, so a shared alphabet would bury every search under choices
that cannot appear in the answer.

That means **there is no single interpreter**. Rule index `n + 2` is block `5`
in one house's grammar and block `35` in another's, and an interpreter compiled
against one would build the right shape from the wrong materials in every
other. So `interpret` takes the grammar explicitly and caches one per grammar.
`grammar_builder` is the generic fallback.

## Running it

```julia
using HerbBenchmarks, HerbBenchmarks.Minecraft_Houses_2019
const MH = Minecraft_Houses_2019

problem = get_problem(MH, "house_0030")
grammar = get_grammar(MH, "house_0030")        # this house's own grammar

built = MH.interpret(MH.compact_program("house_0030"), problem.spec[1], grammar)
built == problem.spec[1].out                   # true

MH.build("house_0030")                         # shorthand for the above
MH.print_house(problem.spec[1].out; y=1)       # top-down plan of one layer
MH.house_legend(problem.spec[1].out)           # "a = oak planks, b = glass"
```

Exact reconstruction is harsh for a 74-block structure, so partial credit and
ordering are also available:

```julia
MH.voxel_f1(built, MH.HOUSE_TARGETS["house_0030"])    # overlap, matching block type
MH.voxel_iou(built, MH.HOUSE_TARGETS["house_0030"])
MH.evaluate_trace(program, "house_0030")              # (canvas, is_done, reward)
MH.trace_problem("house_0030")                        # the human's build order
MH.metric_problem("house_0030")                       # cost = 1 - voxel_f1
```

F1 rather than cell accuracy, because the canvas is mostly empty and a program
that places nothing must not score well.

## Visualising

```julia
MH.visualize(program, "house_0030"; path="build.gif")  # one frame per action
MH.visualize("house_0030"; path="target.svg")          # the target alone
MH.compare(program, "house_0030"; path="diff.svg")     # wrong red, missing blue
```

`compare` is the one to reach for when a program nearly works: an exact-match
failure says nothing about *where* the house went wrong. Rendering is the
dependency-free `src/utils/voxel_render.jl`.

The upstream tarball does ship pre-rendered PNGs made with the Chunky
path-tracer, but only for 73 of the 2,586 houses, and they show finished
targets, so they cannot show what a program produced.

## Regenerating the data

The dataset is a 562 MB tarball, too large to vendor, and its median house is
528 blocks, which is not a program anyone will synthesise. `data.jl` holds a
curated subset: the 40 smallest houses with 25 to 150 blocks and at most 8
block types. `scripts/gen_houses.py` produces it, and needs nothing but the
Python standard library:

```bash
cd scripts
python3 gen_houses.py                    # regenerate ../data.jl as committed
python3 gen_houses.py --count 200 --max-voxels 400 --out ../data_large.jl
python3 gen_houses.py --count 2586 --min-voxels 1 --max-voxels 100000 \
                     --max-block-types 99 --out ../data_all.jl
```

The tarball is cached in `scripts/cache/` (gitignored), so re-running is cheap.
The selection is deliberate and lossy: **if you report results, say which
subset you used.**

## Citation

> Chen, Zhuoyuan, Demi Guo, Tong Xiao, Saining Xie, Xinlei Chen, Haonan Yu,
> Jonathan Gray, Kavya Srinet, Haoqi Fan, Jerry Ma, Charles R. Qi, Shubham
> Tulsiani, Arthur Szlam, and C. Lawrence Zitnick. "Order-Aware Generative
> Modeling Using the 3D-Craft Dataset." *ICCV*, 2019.

See `citation.bib`, which also cites the CraftAssist paper the data was
collected under.
