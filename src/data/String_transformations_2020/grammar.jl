grammar_string = @cfgrammar begin
    # Start = ((input) -> (state = initState(input); Sequence; return state.str))(_arg_1)
    Start = (state = Init; Sequence; Return)
    Init = initState(_arg_1)
    Return = getString(state)

    Sequence = Operation 
    Sequence = Operation; Sequence
    Operation = Transformation 
    Operation = ControlStatement

    Transformation = moveRight(state) | moveLeft(state) | makeUppercase(state) | makeLowercase(state) | drop(state)
    ControlStatement = Condition ? Sequence : Sequence 
    ControlStatement = while Condition; Sequence; end

    Condition = atEnd(state) | notAtEnd(state) | atStart(state) | notAtStart(state) | isLetter(state) | isNotLetter(state) | isUppercase(state) | isNotUppercase(state) | isLowercase(state) | isNotLowercase(state) | isNumber(state) | isNotNumber(state) | isSpace(state) | isNotSpace(state)

end
