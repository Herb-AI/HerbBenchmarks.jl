"""
Reference programs for the house problems.

Unlike the other benchmarks, these are not clever: a reference program here
replays the human's recorded build one block at a time, in the order 3D-Craft
recorded it. That is the *naive* solution, and finding a shorter one -- spotting
that a wall is a `fill_box` and a row of windows a `repeat_op` -- is the whole
task.

They still earn their place. Every one must reproduce its target exactly, which
proves the DSL can express all 40 houses, and their length is the baseline any
synthesised program should beat.
"""

"""
    rule_index(grammar, type, rhs) -> Int

The index of the rule `type = rhs`, erroring if the grammar has no such rule.

Matching on both sides matters here: an `Offset` and a `Block` can be the same
integer, so a right-hand side alone does not identify a rule.
"""
function rule_index(grammar::AbstractGrammar, type::Symbol, rhs)
    index = findfirst(i -> grammar.types[i] === type && grammar.rules[i] == rhs,
        eachindex(grammar.rules))
    index === nothing && error("no rule `$type = $rhs` in the grammar")
    return index
end

"""
    operation_node(grammar, name) -> RuleNode

A parameterless `Operation`, such as `place` or `remove`.
"""
operation_node(grammar::AbstractGrammar, name::Symbol) =
    RuleNode(rule_index(grammar, :Operation, name))

"""
    select_node(grammar, block) -> RuleNode

`select(block)`, for a block this house's grammar offers.
"""
select_node(grammar::AbstractGrammar, block::Int) = RuleNode(
    rule_index(grammar, :Operation, :(select(Block))),
    [RuleNode(rule_index(grammar, :Block, block))])

"""
    move_nodes(grammar, delta) -> Vector{RuleNode}

Cursor moves carrying the cursor by `delta`, splitting each axis into steps of
at most 8 because that is the largest `Offset` the grammar has.
"""
function move_nodes(grammar::AbstractGrammar, delta::NTuple{3,Int})
    nodes = AbstractRuleNode[]
    for (axis, rhs) in ((1, :(move_x(Offset))), (2, :(move_y(Offset))), (3, :(move_z(Offset))))
        remaining = delta[axis]
        remaining == 0 && continue
        rule = rule_index(grammar, :Operation, rhs)
        while remaining != 0
            step = clamp(remaining, -8, 8)
            push!(nodes, RuleNode(rule, [RuleNode(rule_index(grammar, :Offset, step))]))
            remaining -= step
        end
    end
    return nodes
end

"""
    seq_node(grammar, operations) -> RuleNode

Fold operations into the grammar's right-nested `Sequence` spine.
"""
function seq_node(grammar::AbstractGrammar, operations::AbstractVector{<:AbstractRuleNode})
    isempty(operations) && error("a Sequence needs at least one Operation")
    single = rule_index(grammar, :Sequence, :Operation)
    cons = rule_index(grammar, :Sequence, :(seq(Operation, Sequence)))
    node = RuleNode(single, [last(operations)])
    for op in Iterators.reverse(@view operations[1:end-1])
        node = RuleNode(cons, [op, node])
    end
    return node
end

"""
    reference_program(identifier) -> RuleNode

The naive replay of a house's recorded build, as a `RuleNode` over that house's
grammar.

Emits a `select` only when the block type changes and moves only along axes
that actually differ, so it is the shortest program of this *shape* -- but it
still has no loops and no bulk shapes, which is exactly the headroom a
synthesiser is meant to find.

```julia
julia> program = reference_program("house_0001")
julia> interpret(program, get_problem(Minecraft_Houses_2019, "house_0001").spec[1]) ==
           HOUSE_TARGETS["house_0001"]
true
```
"""
function reference_program(identifier::AbstractString)
    grammar = HOUSE_GRAMMARS[identifier]
    operations = AbstractRuleNode[]
    cursor = (0, 0, 0)
    block = 0

    for (x, y, z, id) in HOUSE_TRACES[identifier]
        if id != block
            push!(operations, select_node(grammar, id))
            block = id
        end
        append!(operations, move_nodes(grammar, (x, y, z) .- cursor))
        push!(operations, operation_node(grammar, :place))
        cursor = (x, y, z)
    end

    return RuleNode(1, [seq_node(grammar, operations)])
end

"""
    compact_program(identifier) -> RuleNode

A hand-written *compressed* solution, for the houses that have one.

[`reference_program`](@ref) shows what the naive replay costs;
this shows what the same house costs once its structure is exploited. The gap
between the two is what a synthesiser is being asked to close, so having a
worked example of the far end makes the benchmark's target concrete.

Throws a `KeyError` for a house with no compact solution written yet.

```julia
julia> length(reference_program("house_0030")), length(compact_program("house_0030"))
(443, 110)
```
"""
compact_program(identifier::AbstractString) = COMPACT_SOLUTIONS[identifier]()

"""
    COMPACT_SOLUTIONS

Compressed solutions, keyed by identifier. Each entry is a thunk, because a
program can only be built once its house's grammar exists.
"""
const COMPACT_SOLUTIONS = Dict{String,Function}()

"""
    house_0030_compact() -> RuleNode

`house_0030` is a 6x6 ring of oak-plank walls two storeys high, a flat roof,
four glass windows and a doorway. Written out that way it is 34 operations
against the 148 the human's recorded build takes.
"""
function house_0030_compact()
    grammar = HOUSE_GRAMMARS["house_0030"]
    index(type, rhs) = rule_index(grammar, type, rhs)
    op(name) = RuleNode(index(:Operation, name))
    arg1(rhs, type, value) = RuleNode(index(:Operation, rhs), [RuleNode(index(type, value))])

    select(block) = arg1(:(select(Block)), :Block, block)
    fill_x(n) = arg1(:(fill_x(Offset)), :Offset, n)
    fill_z(n) = arg1(:(fill_z(Offset)), :Offset, n)
    move_x(n) = arg1(:(move_x(Offset)), :Offset, n)
    move_y(n) = arg1(:(move_y(Offset)), :Offset, n)
    move_z(n) = arg1(:(move_z(Offset)), :Offset, n)
    repeat_op(n, body) = RuleNode(index(:Operation, :(repeat_op(Count, Sequence))),
        [RuleNode(index(:Count, n)), seq_node(grammar, body)])
    fill_box(dx, dy, dz) = RuleNode(index(:Operation, :(fill_box(Extent, Extent, Extent))),
        [RuleNode(index(:Extent, dx)), RuleNode(index(:Extent, dy)),
            RuleNode(index(:Extent, dz))])

    return RuleNode(1, [seq_node(grammar, [
        select(5),
        # Four runs trace the wall ring and bring the cursor back where it
        # started, so `move_y(1)` is all the second storey needs.
        repeat_op(2, [fill_x(5), fill_z(5), fill_x(-5), fill_z(-5), move_y(1)]),
        fill_box(5, 0, 5),                                          # the flat roof
        select(20),
        move_y(-2), move_x(3), op(:place), move_y(1), op(:place),   # window, z = 0
        move_y(-1), move_x(2), move_z(1), op(:place), move_y(1), op(:place),
        move_y(-1), move_x(-5), move_z(2), op(:place), move_y(1), op(:place),
        move_y(-1), move_x(3), move_z(2), op(:place), move_y(1), op(:place),
        # The ring was laid unbroken, so the doorway is cut back out of it.
        select(5),
        move_y(-1), move_x(2), move_z(-2), op(:remove), move_y(1), op(:remove),
    ])])
end

COMPACT_SOLUTIONS["house_0030"] = house_0030_compact
