mutable struct State
    str::String
    pointer::Int
    State(s::String) = new(s, 1)  # Initialize the pointer to 1 (not 0, since Julia is 1-indexed)
end

function getString(state::State) 
    return state.str
end

function initState(s::String) 
    return State(s)
end

# Define the transformation functions
function moveRight(state::State)
    state.pointer = min(state.pointer + 1, length(state.str))
end

function moveLeft(state::State)
    state.pointer = max(state.pointer - 1, 1)
end

function makeUppercase(state::State)
    if state.pointer <= length(state.str)
        state.str = state.str[1:state.pointer-1] * uppercase(state.str[state.pointer]) * state.str[state.pointer+1:end]
    end
end

function makeLowercase(state::State)
    if state.pointer <= length(state.str)
        state.str = state.str[1:state.pointer-1] * lowercase(state.str[state.pointer]) * state.str[state.pointer+1:end]
    end
end

function drop(state::State)
    if state.pointer <= length(state.str)
        state.str = state.str[1:state.pointer-1] * state.str[state.pointer+1:end]
    end
end

# Define the boolean conditions
atEnd(state::State) = state.pointer == length(state.str)
notAtEnd(state::State) = state.pointer != length(state.str)
atStart(state::State) = state.pointer == 1
notAtStart(state::State) = state.pointer != 1
isLetter(state::State) = state.pointer <= length(state.str) && isletter(state.str[state.pointer])
isNotLetter(state::State) = state.pointer > length(state.str) || !isletter(state.str[state.pointer])
isUppercase(state::State) = state.pointer <= length(state.str) && isuppercase(state.str[state.pointer])
isNotUppercase(state::State) = state.pointer > length(state.str) || !isuppercase(state.str[state.pointer])
isLowercase(state::State) = state.pointer <= length(state.str) && islowercase(state.str[state.pointer])
isNotLowercase(state::State) = state.pointer > length(state.str) || !islowercase(state.str[state.pointer])
isNumber(state::State) = state.pointer <= length(state.str) && isdigit(state.str[state.pointer])
isNotNumber(state::State) = state.pointer > length(state.str) || !isdigit(state.str[state.pointer])
isSpace(state::State) = state.pointer <= length(state.str) && isspace(state.str[state.pointer])
isNotSpace(state::State) = state.pointer > length(state.str) || !isspace(state.str[state.pointer])
