using MLStyle

struct RobotState
    holds_ball::Int
    robot_x::Int
    robot_y::Int
    ball_x::Int
    ball_y::Int
    size::Int
end

function interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::RobotState)
    rule_node =  prog.ind # get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammar, state)) # (Operation ; Sequence)
        :moveRight => !(state.robot_x == state.size) ? RobotState(state.holds_ball, state.robot_x+1, state.robot_y, state.ball_x, state.ball_y, state.size) : state       #moveright
        :moveDown => !(state.robot_y == state.size) ? RobotState(state.holds_ball, state.robot_x, state.robot_y+1, state.ball_x, state.ball_y, state.size) : state      #moveDown
        :moveLeft => !(state.robot_x == 1) ? RobotState(state.holds_ball, state.robot_x-1, state.robot_y, state.ball_x, state.ball_y, state.size) : state        #moveLeft
        :moveUp => !(state.robot_y == 1) ? RobotState(state.holds_ball, state.robot_x, state.robot_y-1, state.ball_x, state.ball_y, state.size) : state         #moveUp
        :drop => state.holds_ball == 1 ? RobotState(0, state.robot_x, state.robot_y, state.robot_x, state.robot_y, state.size) : state                 #drop
        :grab => can_pickup(state) ? RobotState(1, state.robot_x, state.robot_y, state.ball_x, state.ball_y, state.size) : state                     # grab
        :IF => interpret(prog.children[1], grammartags, state) ? interpret(prog.children[2], grammartags, state) : interpret(prog.children[3], grammartags, state)                      #If statement 
        :WHILE => command_while(prog.children[1], prog.children[2], grammartags, state)              # while loop
        :atTop => state.robot_y == 1            #atTop 
        :atBottom => state.robot_y == state.size   #atBottom 
        :atLeft => state.robot_x == 1            #atLeft 
        :atRight => state.robot_x == state.size   #atRight
        :notAtTop => !(state.robot_y == 1)         #notAtTop
        :notAtBottom => !(state.robot_y == state.size)    # notAtBottom
        :notAtLeft => !(state.robot_x == 1)             #notAtLeft
        :notAtRight => !(state.robot_x == state.size)    # notAtRight
        _ => interpret(prog.children[1], grammartags, state) # Start operation Transformation ControlStatement
    end
end

"""
Gets relevant symbol to easily match the rules
"""
function get_relevant_tags(grammar::ContextSensitiveGrammar)
    tags = Dict{Int,Symbol}()
    for (ind, r) in pairs(grammar.rules)
        tags[ind] = if typeof(r) == Symbol
                        r
                    else
                        @match r.head begin
                            :block =>  :OpSeq
                            :call =>  r.args[1]             
                            end
                        end
                    end
    return tags
end

can_pickup(state::RobotState) = state.holds_ball == 0 && state.robot_x == state.ball_x && state.robot_y == state.ball_y

function command_while(condition::RuleNode, body::RuleNode, grammartags::Dict{Int,Symbol}, state::RobotState, max_steps::Int=1000) 
    counter = max_steps
    while interpret(condition, grammartags, state) && counter > 0
        state = interpret(body, grammartags, state)
        counter -= 1
    end
    state
end

function Base.show(io::IO, state::RobotState)
    for y in 1:state.size
        row = "";
        for x in 1:state.size
            if (x == state.robot_x && y == state.robot_y)
                row *= state.holds_ball == 1 ? "#" : "R"
            elseif (x == state.ball_x && y == state.ball_y)
                row *= "B"
            else
                row *= "."
            end
        end
        println(io, row)
    end
end

"""
mygrammartags = get_relevant_tags(grammar_robots)
mystate = RobotState(0,1,1,2,1,5)
moveRight = RuleNode(6, [])
interpret(moveRight, mygrammartags, mystate)
"""