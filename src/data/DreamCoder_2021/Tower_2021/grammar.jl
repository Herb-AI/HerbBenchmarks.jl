"""
Grammar for DreamCoder's block-tower domain.

Every task shares this grammar: the input is always a fresh `TowerState`, so
there is a single `grammar_tower` rather than one grammar per problem.

`Operation` derives function values, and `Sequence` composes them, so
`tower_loop` and `tower_embed` receive a body they can run repeatedly without
the grammar ever binding a variable.
"""
grammar_tower = @cfgrammar begin
    Start = run_tower(Sequence, _arg_1)

    Sequence = Operation
    Sequence = seq(Operation, Sequence)

    Operation = place_v
    Operation = place_h
    Operation = move_right(Int)
    Operation = move_left(Int)
    Operation = tower_loop(Int, Sequence)
    Operation = tower_embed(Sequence)

    # DreamCoder's tower DSL provides the integer literals 1 through 8.
    Int = |(1:8)
end
