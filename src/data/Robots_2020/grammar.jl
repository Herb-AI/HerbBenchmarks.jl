grammar_robots = @cfgrammar begin
    Start = (state = Init; Sequence; Return)
    Init = initState(holds_ball, robot_x, robot_y, ball_x, ball_y, size)
    Return = returnState(state)

    Sequence = Operation 
    Sequence = Operation; Sequence
    Operation = Transformation 
    Operation = ControlStatement

    Transformation = moveRight(state) | moveDown(state) | moveLeft(state) | moveUp(state) | drop(state) | grab(state)
    ControlStatement = Condition ? Sequence : Sequence 
    ControlStatement = while Condition; Sequence; end

    Condition = atTop(state) | atBottom(state) | atLeft(state) | atRight(state) | notAtTop(state) | notAtBottom(state) | notAtLeft(state) | notAtRight(state)
end
