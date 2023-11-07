# Transformation primitives
function moveRight(state::Dict{Symbol, Any})
    state[:pos] = min(state[:pos] + 1, length(state[:_arg_1]))
end

function moveLeft(state::Dict{Symbol, Any})
    state[:pos] = max(state[:pos] - 1, 1)
end

function makeUppercase(state::Dict{Symbol, Any})
    if state[:pos] <= length(state[:_arg_1])
        str = state[:_arg_1]
        state[:_arg_1] = str[1:state[:pos]-1] * uppercase(str[state[:pos]]) * str[state[:pos]+1:end]
    end
end

function makeLowercase(state::Dict{Symbol, Any})
    if state[:pos] <= length(state[:_arg_1])
        str = state[:_arg_1]
        state[:_arg_1] = str[1:state[:pos]-1] * lowercase(str[state[:pos]]) * str[state[:pos]+1:end]
    end
end

function drop(state::Dict{Symbol, Any})
    if state[:pos] <= length(state[:_arg_1])
        str = state[:_arg_1]
        state[:_arg_1] = str[1:state[:pos]-1] * str[state[:pos]+1:end]
    end
end

# Boolean primitives
function atEnd(state::Dict{Symbol, Any})
    return state[:pos] == length(state[:_arg_1])
       
end

function notAtEnd(state::Dict{Symbol, Any})
    return state[:pos] != length(state[:_arg_1])
end

function atStart(state::Dict{Symbol, Any})
    return state[:pos] == 1
end

function notAtStart(state::Dict{Symbol, Any})
    return state[:pos] != 1
end

function isLetter(state::Dict{Symbol, Any})
    return state[:pos] <= length(state[:_arg_1]) && isletter(state[:_arg_1][state[:pos]])
end

function isNotLetter(state::Dict{Symbol, Any})
    return state[:pos] > length(state[:_arg_1]) || !isletter(state[:_arg_1][state[:pos]])
end

function isUppercase(state::Dict{Symbol, Any})
    return state[:pos] <= length(state[:_arg_1]) && isuppercase(state[:_arg_1][state[:pos]])
end

function isNotUppercase(state::Dict{Symbol, Any})
    return state[:pos] > length(state[:_arg_1]) || !isuppercase(state[:_arg_1][state[:pos]])
end

function isLowercase(state::Dict{Symbol, Any})
    return state[:pos] <= length(state[:_arg_1]) && islowercase(state[:_arg_1][state[:pos]])
end

function isNotLowercase(state::Dict{Symbol, Any})
    return state[:pos] > length(state[:_arg_1]) || !islowercase(state[:_arg_1][state[:pos]])
end

function isNumber(state::Dict{Symbol, Any})
    return state[:pos] <= length(state[:_arg_1]) && isdigit(state[:_arg_1][state[:pos]])
end

function isNotNumber(state::Dict{Symbol, Any})
    return state[:pos] > length(state[:_arg_1]) || !isdigit(state[:_arg_1][state[:pos]])
end

function isSpace(state::Dict{Symbol, Any})
    return state[:pos] <= length(state[:_arg_1]) && isspace(state[:_arg_1][state[:pos]])
end

function isNotSpace(state::Dict{Symbol, Any})
    return state[:pos] > length(state[:_arg_1]) || !isspace(state[:_arg_1][state[:pos]])
end
       
