using MLStyle

grammar_karel = @cfgrammar begin
    Start = (:DEF; :RUN; Block)                     #1

    Block = Action                                  #2
    Block = (Action; Block)                         #3
    Block = ControlFlow                             #4

    Action = move                                   #5
    Action = turnLeft                               #6
    Action = turnRight                              #7
    Action = pickMarker                             #8
    Action = putMarker                              #9

    ControlFlow = IF(Condition, Block)              #10
    ControlFlow = IFELSE(Condition, Block, Block)   #11
    ControlFlow = WHILE(Condition, Block)           #12
    ControlFlow = REPEAT(R=INT, Block)              #13
    INT = |(1:5)                                    #14-18

    Condition = frontIsClear                        #19
    Condition = leftIsClear                         #20
    Condition = rightIsClear                        #21
    Condition = markersPresent                      #22
    Condition = noMarkersPresent                    #23
    Condition = NOT(Condition)                      #24
end