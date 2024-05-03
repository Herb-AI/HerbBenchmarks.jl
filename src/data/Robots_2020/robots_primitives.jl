using MLStyle

struct RobotState
    holds_ball::Int
    robot_x::Int
    robot_y::Int
    ball_x::Int
    ball_y::Int
    size::Int
end


function interpret(prog::RuleNode, state::RobotState)
    rule_node = get_rule(prog)

    @match rule_node begin
        3 => interpret(prog.children[2], interpret(prog.children[1], state)) # (Operation ; Sequence)
        6 => notAtRight(state) ? RobotState(state.holds_ball, state.robot_x+1, state.robot_y, state.ball_x, state.ball_y, state.size) : state
        7 => notAtBottom(state) ? RobotState(state.holds_ball, state.robot_x, state.robot_y+1, state.ball_x, state.ball_y, state.size) : state
        8 => notAtLeft(state) ? RobotState(state.holds_ball, state.robot_x-1, state.robot_y, state.ball_x, state.ball_y, state.size) : state
        9 => notAtTop(state) ? RobotState(state.holds_ball, state.robot_x, state.robot_y-1, state.ball_x, state.ball_y, state.size) : state
        10 => state.holds_ball == 1 ? RobotState(0, state.robot_x, state.robot_y, state.robot_x, state.robot_y, state.size) : state
        11 => can_pickup(state) ? RobotState(1, state.robot_x-1, state.robot_y, state.ball_x, state.ball_y, state.size) : state
        12 => interpret(condition, state) ? interpret(tbranch, state) : interpret(fbranch, state) 
        13 => command_while(prog.children[1], prog.children[2], state)
        14 => state.robot_y == 1
        15 => state.robot_y == state.size
        16 => state.robot_x == 1
        17 => state.robot_x == state.size
        18 => !(state.robot_y == 1) 
        19 => !(state.robot_y == state.size)
        20 => !(state.robot_x == 1)
        21 => !(state.robot_x == state.size)
        _ => interpret(prog.children[1], state) # Start operation Transformation ControlStatement
    end
end

can_pickup(state::RobotState) = state.holds_ball == 0 && state.robot_x == state.ball_x && state.robot_y == state.ball_y

function command_while(condition::RuleNode, body::RuleNode, state::RobotState) 
    while interpret(condition, state)
        state = interpret(body, state)
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
