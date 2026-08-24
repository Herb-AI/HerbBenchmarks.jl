"""
Hand-written solutions to the MineRL problems.

These are not part of the specification -- a synthesiser is not meant to
reproduce them -- but they pin the world model down. If a change to the
primitives or the recipes breaks the item hierarchy, the test that runs every
one of these fails, which is a far better signal than a task quietly becoming
unsolvable.

Solutions are built as `RuleNode`s directly rather than through
`expr2rulenode`, because several literals appear under more than one
nonterminal: `:planks` is both a `Placeable` and a `Craftable`, and `:torch`
likewise. Reading such a program back from an expression is genuinely
ambiguous, so the constructors below name the nonterminal explicitly.
"""

"""
    rule_index(grammar, type, rhs) -> Int

The index of the rule `type = rhs`, erroring if the grammar has no such rule.

Looking a rule up by *both* its left- and right-hand side is what makes these
constructors unambiguous where `expr2rulenode` is not.
"""
function rule_index(grammar::AbstractGrammar, type::Symbol, rhs)
    index = findfirst(i -> grammar.types[i] === type && grammar.rules[i] == rhs,
        eachindex(grammar.rules))
    index === nothing && error("no rule `$type = $rhs` in the grammar")
    return index
end

"""
    operation(name) -> RuleNode

A parameterless `Operation`, such as `move_forward` or `mine_forward`.
"""
operation(name::Symbol) = RuleNode(rule_index(grammar_minerl, :Operation, name))

"""
    literal(type, value) -> RuleNode

A symbol literal under a named nonterminal, such as `:planks` as a `Craftable`.
"""
literal(type::Symbol, value::Symbol) =
    RuleNode(rule_index(grammar_minerl, type, QuoteNode(value)))

"""
    count_node(n) -> RuleNode

The `Count` literal `n`, which the grammar provides for `1:8`.
"""
function count_node(n::Int)
    1 <= n <= 8 || error("the grammar's Count only covers 1:8, got $n")
    return RuleNode(rule_index(grammar_minerl, :Count, n))
end

"""
    seq_node(operations) -> RuleNode

Fold operations into the grammar's right-nested `Sequence` spine, so solutions
can be written as flat lists.
"""
function seq_node(operations::AbstractVector{<:AbstractRuleNode})
    isempty(operations) && error("a Sequence needs at least one Operation")
    single = rule_index(grammar_minerl, :Sequence, :Operation)
    cons = rule_index(grammar_minerl, :Sequence, :(seq(Operation, Sequence)))
    node = RuleNode(single, [last(operations)])
    for op in Iterators.reverse(operations[1:end-1])
        node = RuleNode(cons, [op, node])
    end
    return node
end

"""
    repeat_node(n, body) -> RuleNode

`repeat_op(n, body)`, chaining several `repeat_op`s when `n` exceeds the
grammar's largest `Count`.
"""
function repeat_node(n::Int, body::AbstractVector{<:AbstractRuleNode})
    n >= 1 || error("repeat count must be positive, got $n")
    rule = rule_index(grammar_minerl, :Operation, :(repeat_op(Count, Sequence)))
    chunks = AbstractRuleNode[]
    while n > 0
        chunk = min(n, 8)
        push!(chunks, RuleNode(rule, [count_node(chunk), seq_node(body)]))
        n -= chunk
    end
    return chunks
end

"""
    craft_node(item) -> RuleNode

`craft(item)` for a `Craftable`.
"""
craft_node(item::Symbol) = RuleNode(
    rule_index(grammar_minerl, :Operation, :(craft(Craftable))),
    [literal(:Craftable, item)])

"""
    smelt_node(item) -> RuleNode

`smelt(item)` for a `Smeltable`.
"""
smelt_node(item::Symbol) = RuleNode(
    rule_index(grammar_minerl, :Operation, :(smelt(Smeltable))),
    [literal(:Smeltable, item)])

"""
    walk(n) -> Vector{RuleNode}

Walk `n` cells forward.
"""
walk(n::Int) = repeat_node(n, [operation(:move_forward)])

"""
    tunnel(n) -> Vector{RuleNode}

Mine and step forward `n` times: the idiom for eating through a run of blocks
laid out in front of the agent.
"""
tunnel(n::Int) = repeat_node(n, [operation(:mine_forward), operation(:move_forward)])

"""
    chop(n) -> Vector{RuleNode}

Like [`tunnel`](@ref), but clears head height too, which a stand of trees needs
because the leaves would otherwise bar the way.
"""
chop(n::Int) = repeat_node(n,
    [operation(:mine_forward), operation(:mine_forward_up), operation(:move_forward)])

"""
    wooden_pickaxe_chain() -> Vector{RuleNode}

The crafting steps from a stack of logs to a wooden pickaxe: four batches of
planks, one of sticks, a crafting table, and the pickaxe itself. Every
`Obtain*` task above the first rung starts with this.
"""
wooden_pickaxe_chain() = [
    craft_node(:planks), craft_node(:planks), craft_node(:planks), craft_node(:planks),
    craft_node(:stick),
    craft_node(:crafting_table),
    craft_node(:wooden_pickaxe),
]

"""
    SOLUTIONS

One reference solution per problem, keyed by identifier. Each is the `Sequence`
of a solution; [`reference_program`](@ref) wraps it in the `Start` rule.
"""
const SOLUTIONS = Dict{String,AbstractRuleNode}()

# --- Navigate --------------------------------------------------------------
# Straight down the plain.
SOLUTIONS["navigate_01_plain"] = seq_node(walk(8))

# The ledge at x = 4 is climbed by simply walking into it.
SOLUTIONS["navigate_02_ledge"] = seq_node(walk(8))

# Walk to the lip of the trench, jump it, then carry on. Walking in instead
# would drop the agent somewhere it cannot climb out of.
SOLUTIONS["navigate_03_trench"] = seq_node([walk(4); operation(:jump_forward); walk(2)])

# East along the corridor, then right (south) and down it.
SOLUTIONS["navigate_04_corridor"] = seq_node([walk(5); operation(:turn_right); walk(6)])

# Every step of the staircase is a one-block climb, so walking suffices.
SOLUTIONS["navigate_05_staircase"] = seq_node(walk(9))

# --- Treechop --------------------------------------------------------------
SOLUTIONS["treechop"] = seq_node(chop(8))

# --- Obtain* ---------------------------------------------------------------
SOLUTIONS["obtain_wooden_pickaxe"] = seq_node([tunnel(5); wooden_pickaxe_chain()])

SOLUTIONS["obtain_stone_pickaxe"] = seq_node([
    tunnel(5); wooden_pickaxe_chain();
    walk(1); tunnel(6);
    craft_node(:stone_pickaxe)
])

# Iron needs the whole ladder: a stone pickaxe to mine the ore, a furnace to
# smelt it, coal to fire the furnace, and fresh sticks because the stone
# pickaxe consumed the first pair.
const IRON_PICKAXE_PLAN = [
    tunnel(5); wooden_pickaxe_chain();
    walk(1); tunnel(11);
    craft_node(:stone_pickaxe);
    tunnel(3);
    craft_node(:furnace);
    walk(1); tunnel(3);
    craft_node(:stick);
    smelt_node(:iron_ingot); smelt_node(:iron_ingot); smelt_node(:iron_ingot);
    craft_node(:iron_pickaxe)
]

SOLUTIONS["obtain_iron_pickaxe"] = seq_node(IRON_PICKAXE_PLAN)

# Only an iron pickaxe can break diamond ore, so the diamond plan is the iron
# plan plus two more steps.
SOLUTIONS["obtain_diamond"] = seq_node([IRON_PICKAXE_PLAN; walk(1); tunnel(1)])

# `ObtainCookedMeat`: wood, a wooden pickaxe, stone for a furnace, coal for
# fuel, then hunt the animal and cook what it drops.
for (_, animal, cooked) in OBTAIN_COOKED_MEAT
    SOLUTIONS["obtain_$(cooked)"] = seq_node([
        tunnel(5); wooden_pickaxe_chain();
        walk(1); tunnel(9);
        craft_node(:furnace);
        tunnel(2);
        walk(1); tunnel(1);
        smelt_node(cooked)
    ])
end

# `ObtainBed`: two batches of planks (the crafting table eats the first), then
# three sheep for the wool.
for (_, animal, wool, bed) in OBTAIN_BED
    SOLUTIONS["obtain_$(bed)"] = seq_node([
        tunnel(3);
        craft_node(:planks); craft_node(:planks); craft_node(:crafting_table);
        walk(1); tunnel(3);
        craft_node(bed)
    ])
end
