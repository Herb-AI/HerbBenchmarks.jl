"""
Grammars for the MineRL tasks.

There are two, and the smaller is a strict subset of the larger:

  - [`grammar_minerl_navigate`](@ref) has movement and the compass only. It is
    the grammar for the `Navigate` problems, where the terrain is the whole
    difficulty and nothing needs to be mined or built.
  - [`grammar_minerl`](@ref) adds mining, placing, crafting and smelting on top
    of exactly those movement rules, and is the default for every other
    problem. It is what the `Obtain*` tasks need, because their difficulty is
    the item hierarchy rather than the walking.

Both follow the same shape as DreamCoder's tower grammar: `Operation` derives
*function values* and `Sequence` composes them with `seq`, so that `repeat_op`,
`if_op` and `while_op` can be handed a body to run repeatedly without the
grammar ever binding a variable. `Start` applies the composed function to the
input world.

`Sequence` is deliberately right-recursive and has no empty production, so each
program denotes exactly one action list and the search space holds no
distinct-but-equivalent spellings of the same plan.
"""

"""
    grammar_minerl_navigate

Movement-only grammar, used by the `Navigate` problems.
"""
grammar_minerl_navigate = @cfgrammar begin
    Start = run_minerl(Sequence, _arg_1)

    Sequence = Operation
    Sequence = seq(Operation, Sequence)

    Operation = move_forward
    Operation = move_back
    Operation = strafe_left
    Operation = strafe_right
    Operation = turn_left
    Operation = turn_right
    Operation = jump_forward

    Operation = repeat_op(Count, Sequence)
    Operation = if_op(Condition, Sequence, Sequence)
    Operation = while_op(Condition, Sequence)

    Condition = at_goal
    Condition = goal_ahead
    Condition = goal_behind
    Condition = goal_left
    Condition = goal_right
    Condition = blocked_ahead
    Condition = can_step_up
    Condition = not_op(Condition)

    Count = |(1:8)
end

"""
    grammar_minerl

The full grammar: every rule of [`grammar_minerl_navigate`](@ref), plus mining,
placing, crafting and smelting.

This is the module's default grammar, so any problem without its own
`grammar_<identifier>` gets this one.
"""
grammar_minerl = @cfgrammar begin
    Start = run_minerl(Sequence, _arg_1)

    Sequence = Operation
    Sequence = seq(Operation, Sequence)

    Operation = move_forward
    Operation = move_back
    Operation = strafe_left
    Operation = strafe_right
    Operation = turn_left
    Operation = turn_right
    Operation = jump_forward

    Operation = repeat_op(Count, Sequence)
    Operation = if_op(Condition, Sequence, Sequence)
    Operation = while_op(Condition, Sequence)

    Condition = at_goal
    Condition = goal_ahead
    Condition = goal_behind
    Condition = goal_left
    Condition = goal_right
    Condition = blocked_ahead
    Condition = can_step_up
    Condition = not_op(Condition)

    Count = |(1:8)

    # --- everything below is what `grammar_minerl_navigate` leaves out ---

    Operation = mine_forward
    Operation = mine_forward_up
    Operation = mine_down
    Operation = mine_up
    Operation = place_forward(Placeable)
    Operation = craft(Craftable)
    Operation = smelt(Smeltable)

    Condition = block_ahead_is(Block)
    Condition = block_below_is(Block)
    Condition = has_at_least(Item, Count)

    # Blocks the agent can carry and put back down.
    Placeable = :dirt | :cobblestone | :planks | :torch

    # Blocks worth recognising in the world: the ores that gate the hierarchy,
    # plus the terrain an agent has to dig through to reach them.
    Block = :air | :grass | :dirt | :stone | :log | :leaves
    Block = :coal_ore | :iron_ore | :diamond_ore | :water | :bedrock

    Craftable = :planks | :stick | :crafting_table | :furnace | :torch
    Craftable = :wooden_pickaxe | :stone_pickaxe | :iron_pickaxe
    Craftable = :white_bed | :red_bed | :blue_bed

    Smeltable = :iron_ingot | :cooked_beef | :cooked_porkchop
    Smeltable = :cooked_chicken | :cooked_mutton

    # Anything the agent can end up holding, for `has_at_least`.
    Item = :log | :planks | :stick | :cobblestone | :dirt | :coal
    Item = :iron_ore | :iron_ingot | :diamond | :crafting_table | :furnace
    Item = :wooden_pickaxe | :stone_pickaxe | :iron_pickaxe
end
