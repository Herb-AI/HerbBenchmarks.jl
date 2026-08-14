"""
Grammar for DreamCoder's LOGO turtle-graphics domain.

Every task shares this grammar — the input is always a fresh `TurtleState` —
so there is a single `grammar_logo` rather than one grammar per problem.

`Operation` derives function values and `Sequence` composes them, so
`logo_loop`, `logo_embed` and `pen_toggle` receive a body they can run
repeatedly or under a changed pen state, without the grammar ever binding a
variable.
"""
grammar_logo = @cfgrammar begin
    Start = run_logo(Sequence, _arg_1)

    Sequence = Operation
    Sequence = seq(Operation, Sequence)

    Operation = move(Length, Angle)
    Operation = logo_loop(Int, Sequence)
    Operation = logo_embed(Sequence)
    Operation = pen_toggle(Sequence)

    Length = unit_length
    Length = zero_length
    Length = eps_length
    Length = mul_length(Length, Int)
    Length = div_length(Length, Int)

    Angle = unit_angle
    Angle = zero_angle
    Angle = eps_angle
    Angle = mul_angle(Angle, Int)
    Angle = div_angle(Angle, Int)
    Angle = add_angle(Angle, Angle)
    Angle = sub_angle(Angle, Angle)

    # DreamCoder provides the literals 0-9 plus `logo_IFTY` (= 20). The
    # reference solutions also need the values in between, because unrolling
    # an `infinity` loop that used its index introduces them, so the whole
    # range 0-20 is available here.
    Int = |(0:20)
end
