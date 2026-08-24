"""
The builder grammar for the 3D-Craft houses.

`Operation` derives *function values* and `Sequence` composes them with `seq`,
the same shape DreamCoder's tower grammar uses, so `repeat_op` and `embed` can
be handed a body without the grammar ever binding a variable. `Start` applies
the composed function to the input canvas.

The rules fall into two groups. `select`, `place`, `remove` and the cursor
moves are 3D-Craft's recorded action alphabet, one rule per thing a human can
actually do. `fill_x`/`fill_y`/`fill_z`, `fill_box` and `box_shell` are the
bulk shapes a human is implicitly making when they lay a wall or a floor block
by block -- without them, a 100-block house is a 100-deep program and nothing
can be synthesised.

## One grammar per house

Every problem carries its own `grammar_house_<n>`, differing only in the
`Block` rules: a house's grammar offers exactly the block types that house is
made of. The dataset uses 199 distinct block ids overall but a median of ten
per house, so a single shared `Block` alphabet would bury every search under
choices that cannot appear in the answer. [`house_grammar`](@ref) builds them.

[`grammar_builder`](@ref) below is the generic fallback, with a palette of
common building blocks.
"""

"""
    BUILDER_RULES

The block-independent part of every house grammar, as an expression ready to
splice into `@cfgrammar`.

Kept in one place so that [`house_grammar`](@ref) cannot drift from
[`grammar_builder`](@ref).
"""
const BUILDER_RULES = quote
    Start = build_house(Sequence, _arg_1)

    Sequence = Operation
    Sequence = seq(Operation, Sequence)

    # 3D-Craft's recorded actions.
    Operation = select(Block)
    Operation = place
    Operation = remove
    Operation = move_x(Offset)
    Operation = move_y(Offset)
    Operation = move_z(Offset)

    # Bulk shapes.
    Operation = fill_x(Offset)
    Operation = fill_y(Offset)
    Operation = fill_z(Offset)
    Operation = fill_box(Extent, Extent, Extent)
    Operation = box_shell(Extent, Extent, Extent)

    # Control flow.
    Operation = repeat_op(Count, Sequence)
    Operation = embed(Sequence)

    # Signed offsets, so one rule covers both directions along an axis. Zero is
    # excluded: a move of nothing, or a run of one block, is never worth a rule.
    Offset = |(-8:-1)
    Offset = |(1:8)

    # Box dimensions, which *do* include zero -- a box flat in one axis is a
    # floor or a roof, and those are most of what these houses are made of.
    Extent = |(-8:8)

    Count = |(2:8)
end

"""
    house_grammar(blocks) -> ContextSensitiveGrammar

Build a grammar whose `Block` alternatives are exactly `blocks`.

```julia
julia> house_grammar([5, 17, 20])   # planks, log, glass
```
"""
function house_grammar(blocks::AbstractVector{Int})
    isempty(blocks) && throw(ArgumentError("a house grammar needs at least one block type"))
    rules = copy(BUILDER_RULES)
    for block in blocks
        push!(rules.args, :(Block = $block))
    end
    return expr2csgrammar(rules)
end

"""
    COMMON_BLOCKS

A generic palette for [`grammar_builder`](@ref): the block ids that turn up
most often across the dataset. Numeric ids are Minecraft 1.12's, which is what
3D-Craft recorded.
"""
const COMMON_BLOCKS = [
    1,    # stone
    2,    # grass
    4,    # cobblestone
    5,    # oak planks
    12,   # sand
    17,   # oak log
    18,   # oak leaves
    20,   # glass
    24,   # sandstone
    35,   # wool
    45,   # brick
    50,   # torch
    53,   # oak stairs
    98,   # stone brick
    102,  # glass pane
    126,  # wooden slab
]

"""
    grammar_builder

The generic house-building grammar, used when a problem has no grammar of its
own.

Named so that it sorts before the per-problem `grammar_house_*` grammars, which
is what makes `get_default_grammar` pick it.
"""
grammar_builder = house_grammar(COMMON_BLOCKS)
