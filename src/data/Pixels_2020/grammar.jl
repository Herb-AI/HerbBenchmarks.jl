grammar_pixels = @cfgrammar begin
    Start = (state = Init; Sequence; Return)
    Init = initState(_arg_1)
    Return = getMatrix(state)

    Sequence = Operation 
    Sequence = Operation; Sequence
    Operation = Transformation 
    Operation = ControlStatement

    Transformation = moveRight(state) | moveLeft(state) | moveUp(state) | moveDown(state) | draw(state)
    ControlStatement = Condition ? Sequence : Sequence 
    ControlStatement = while Condition; Sequence; end

    Condition = atTop(state) | atBottom(state) | atLeft(state) | atRight(state) | notAtTop(state) | notAtBottom(state) | notAtLeft(state) | notAtRight(state)
end
