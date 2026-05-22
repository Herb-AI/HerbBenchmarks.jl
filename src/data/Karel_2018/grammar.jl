grammar_karel = @cfgrammar begin
    Start = Block                                   #1

    Block = Action                                  #2
    Block = (Action; Block)                         #3
    Block = ControlFlow                             #4

    Action = move                                   #5
    Action = turnLeft                               #6
    Action = turnRight                              #7
    Action = pickMarker                             #8
    Action = putMarker                              #9
    Action = noop                                   #10

    ControlFlow = IF(Condition, Block, Block)       #11
    ControlFlow = WHILE(Condition, Block)           #12

    Condition = frontIsClear                        #13
    Condition = leftIsClear                         #14
    Condition = rightIsClear                        #15
    Condition = markersPresent                      #16
    Condition = noMarkersPresent                    #17
    Condition = NOT(Condition)                      #18
end