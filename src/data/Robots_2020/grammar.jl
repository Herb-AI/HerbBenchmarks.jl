grammar = @cfgrammar begin
    Start = ((state) -> Sequence; return state)(_arg_1)

    Sequence = Operation
    Sequence = Operation * ";" * Sequence
    Operation = Transition | ControlStatement

    Transition = moveRight(state) | moveLeft(state) | moveUp(state) | moveDown(state) | drop(state) | grab(state)
    ControlStatement = Condition ? Sequence : Sequence | while Condition; Sequence; end

    Condition = atTop(state) | atBottom(state) | atLeft(state) | atRight(state) | notAtTop(state) | notAtBottom(state) | notAtLeft(state) | notAtRight(state)

end
