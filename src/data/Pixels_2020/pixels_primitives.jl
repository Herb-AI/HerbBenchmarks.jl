mutable struct PixelState
    matrix::Matrix{Bool}
    position::Tuple{Int, Int}
    PixelState(matrix::Matrix{Bool}) = new(matrix, (1,1))
end

function initState(matrix::Matrix{Bool})
    return PixelState(matrix)
end

function getMatrix(state::PixelState)
    return state.matrix
end

# Transition functions
function moveRight(state::PixelState)
    if notAtRight(state)
        state.position = (state.position[1] + 1, state.position[2])
    end
end

function moveDown(state::PixelState)
    if notAtBottom(state)
        state.position = (state.position[1], state.position[2] + 1)
    end
end

function moveLeft(state::PixelState)
    if notAtLeft(state)
        state.position = (state.position[1] - 1, state.position[2])
    end
end

function moveUp(state::PixelState)
    if notAtTop(state)
        state.position = (state.position[1], state.position[2] - 1)
    end
end

function draw(state::PixelState)
    state.matrix[state.position[2], state.position[1]] = true
end

# Boolean conditions
atTop(state::PixelState) = state.position[2] == 1
atBottom(state::PixelState) = state.position[2] == size(state.matrix, 1)
atLeft(state::PixelState) = state.position[1] == 1
atRight(state::PixelState) = state.position[1] == size(state.matrix, 2)
notAtTop(state::PixelState) = !atTop(state)
notAtBottom(state::PixelState) = !atBottom(state)
notAtLeft(state::PixelState) = !atLeft(state)
notAtRight(state::PixelState) = !atRight(state)
