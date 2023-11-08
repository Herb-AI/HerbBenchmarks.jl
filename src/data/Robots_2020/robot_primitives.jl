function atTop(state::Dict{Symbol, Any})
    return state[:robot_y] == 1
end

function atBottom(state::Dict{Symbol, Any})
    return state[:robot_y] == state[:size]
end

function atLeft(state::Dict{Symbol, Any})
    return state[:robot_x] == 1
end

function atRight(state::Dict{Symbol, Any})
    return state[:robot_x] == state[:size]
end

function notAtTop(state::Dict{Symbol, Any})
    return !atTop(state)
end

function notAtBottom(state::Dict{Symbol, Any})
    return !atBottom(state)
end

function notAtLeft(state::Dict{Symbol, Any})
    return !atLeft(state)
end

function notAtRight(state::Dict{Symbol, Any})
    return !atRight(state)
end

function moveRight(state::Dict{Symbol, Any})
    if notAtRight(state)
        state[:robot_x] += 1
    end
end

function moveDown(state::Dict{Symbol, Any})
    if notAtBottom(state)
        state[:robot_y] += 1
    end
end

function moveLeft(state::Dict{Symbol, Any})
    if notAtLeft(state)
        state[:robot_x] -= 1
    end
end

function moveUp(state::Dict{Symbol, Any})
    if notAtTop(state)
        state[:robot_y] -= 1
    end
end

function drop(state::Dict{Symbol, Any})
    if state[:holds_ball] == 1
        state[:ball_x] = state[:robot_x]
        state[:ball_y] = state[:robot_y]
        state[:holds_ball] = 0
    end
end

function grab(state::Dict{Symbol, Any})
    if state[:holds_ball] == 0 && state[:robot_x] == state[:ball_x] && state[:robot_y] == state[:ball_y]
        state[:holds_ball] = 1
    end
end
