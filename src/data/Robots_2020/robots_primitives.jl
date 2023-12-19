mutable struct RobotState
    holds_ball::Int
    robot_x::Int
    robot_y::Int
    ball_x::Int
    ball_y::Int
    size::Int
end

function initState(holds_ball::Int, robot_x::Int, robot_y::Int, ball_x::Int, ball_y::Int, size::Int)
    return RobotState(holds_ball, robot_x, robot_y, ball_x, ball_y, size)
end

function returnState(state::RobotState)
    return Dict{Symbol, Any}(:holds_ball => state.holds_ball,
                             :robot_x => state.robot_x, 
                             :robot_y => state.robot_y,
                             :ball_x => state.ball_x,
                             :ball_y => state.ball_y,
                             :size => state.size)
end

function atTop(state::RobotState)
    return state.robot_y == 1
end

function atBottom(state::RobotState)
    return state.robot_y == state.size
end

function atLeft(state::RobotState)
    return state.robot_x == 1
end

function atRight(state::RobotState)
    return state.robot_x == state.size
end

function notAtTop(state::RobotState)
    return !atTop(state)
end

function notAtBottom(state::RobotState)
    return !atBottom(state)
end

function notAtLeft(state::RobotState)
    return !atLeft(state)
end

function notAtRight(state::RobotState)
    return !atRight(state)
end

function moveRight(state::RobotState)
    if notAtRight(state)
        state.robot_x += 1
    end
end

function moveDown(state::RobotState)
    if notAtBottom(state)
        state.robot_y += 1
    end
end

function moveLeft(state::RobotState)
    if notAtLeft(state)
        state.robot_x -= 1
    end
end

function moveUp(state::RobotState)
    if notAtTop(state)
        state.robot_y -= 1
    end
end

function drop(state::RobotState)
    if state.holds_ball == 1
        state.ball_x = state.robot_x
        state.ball_y = state.robot_y
        state.holds_ball = 0
    end
end

function grab(state::RobotState)
    if state.holds_ball == 0 && state.robot_x == state.ball_x && state.robot_y == state.ball_y
        state.holds_ball = 1
    end
end
