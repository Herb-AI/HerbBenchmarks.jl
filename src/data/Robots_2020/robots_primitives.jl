using MLStyle

struct RobotState
    holds_ball::Int
    robot_x::Int
    robot_y::Int
    ball_x::Int
    ball_y::Int
    size::Int
end

function interpret(prog::AbstractRuleNode, example::IOExample)
    interpret(prog, example.in[:in])
end

function interpret(prog::AbstractRuleNode, state::RobotState)
    rule_node = get_rule(prog)

    @match rule_node begin
        3 => interpret(prog.children[2], interpret(prog.children[1], state)) # (Operation ; Sequence)
        6 => !(state.robot_x == state.size) ? RobotState(state.holds_ball, state.robot_x+1, state.robot_y, state.ball_x, state.ball_y, state.size) : state       #moveright
        7 => !(state.robot_y == state.size) ? RobotState(state.holds_ball, state.robot_x, state.robot_y+1, state.ball_x, state.ball_y, state.size) : state      #moveDown
        8 => !(state.robot_x == 1) ? RobotState(state.holds_ball, state.robot_x-1, state.robot_y, state.ball_x, state.ball_y, state.size) : state        #moveLeft
        9 => !(state.robot_y == 1) ? RobotState(state.holds_ball, state.robot_x, state.robot_y-1, state.ball_x, state.ball_y, state.size) : state         #moveUp
        10 => state.holds_ball == 1 ? RobotState(0, state.robot_x, state.robot_y, state.robot_x, state.robot_y, state.size) : state                 #drop
        11 => can_pickup(state) ? RobotState(1, state.robot_x-1, state.robot_y, state.ball_x, state.ball_y, state.size) : state                     # grab
        12 => interpret(prog.children[1], state) ? interpret(prog.children[2], state) : interpret(prog.children[3], state)                      #If statement 
        13 => command_while(prog.children[1], prog.children[2], state)              # while loop
        14 => state.robot_y == 1            #atTop 
        15 => state.robot_y == state.size   #atBottom 
        16 => state.robot_x == 1            #atLeft 
        17 => state.robot_x == state.size   #atRight
        18 => !(state.robot_y == 1)         #notAtTop
        19 => !(state.robot_y == state.size)    # notAtBottom
        20 => !(state.robot_x == 1)             #notAtLeft
        21 => !(state.robot_x == state.size)    # notAtRight
        _ => interpret(prog.children[1], state) # Start operation Transformation ControlStatement
    end
end

can_pickup(state::RobotState) = state.holds_ball == 0 && state.robot_x == state.ball_x && state.robot_y == state.ball_y

function command_while(condition::RuleNode, body::RuleNode, state::RobotState, max_steps::Int=1000) 
    counter = max_steps
    while interpret(condition, state) && counter > 0
        state = interpret(body, state)
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
