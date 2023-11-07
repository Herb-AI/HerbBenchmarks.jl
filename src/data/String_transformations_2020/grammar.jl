grammar = @cfgrammar begin
    Start = ((state) -> state[:pos] = 1; Sequence; return state[:_arg_1])(_arg_1)

    Sequence = Operation
    Sequence = Operation * ";" * Sequence
    Operation = Tranformation | ControlStatement

    Transformation = moveRight(state) | moveLeft(state) | makeUppercase(state) | makeLowercase(state) | drop(state)
    ControlStatement = Condition ? Sequence : Sequence | while Condition; Sequence; end

    Condition = atEnd(state) | notAtEnd(state) | atStart(state) | notAtStart(state) | isLetter(state) | isNotLetter(state) | isUppercase(state) | isNotUppercase(state) | isLowercase(state) | isNotLowercase(state) | isNumber(state) | isNotNumber(state) | isSpace(state) | isNotSpace(state)

end
