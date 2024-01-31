function char_lowercase(state)
    if !isempty(state[:char])
        cha = state[:char][1]
        state[:char] = state[:char][2:end]
        state[:char] = [isupper(cha) ? Char(Int(cha) + 32) : cha; state[:char]]
    end
    return state
end

function char_uppercase(state)
    if !isempty(state[:char])
        cha = state[:char][1]
        state[:char] = state[:char][2:end]
        state[:char] = [islower(cha) ? Char(Int(cha) - 32) : cha; state[:char]]
    end
    return state
end

function char_iswhitespace(state)
    if !isempty(state[:char])
        item = state[:char][1]
        state[:char] = state[:char][2:end]
        state[:boolean] = [item == '\n' || item == ' ' || item == '\t'; state[:boolean]]
    end
    return state
end

function char_isdigit(state)
    if !isempty(state[:char])
        item = state[:char][1]
        state[:char] = state[:char][2:end]
        state[:boolean] = [isdigit(item); state[:boolean]]
    end
    return state
end

function char_isletter(state)
    if !isempty(state[:char])
        item = state[:char][1]
        state[:char] = state[:char][2:end]
        state[:boolean] = [isletter(item); state[:boolean]]
    end
    return state
end

function char_fromfloat(state)
    if !isempty(state[:float])
        item = state[:float][1]
        state[:float] = state[:float][2:end]
        state[:char] = [Char(mod(Int(item), 128)); state[:char]]
    end
    return state
end

function char_frominteger(state)
    if !isempty(state[:integer])
        item = state[:integer][1]
        state[:integer] = state[:integer][2:end]
        state[:char] = [Char(mod(item, 128)); state[:char]]
    end
    return state
end

function char_allfromstring(state)
    if isempty(state[:string])
        return state
    else
        char_list = reverse(state[:string][1])
        loop_state = popfirst!(state[:string])
        while !isempty(char_list)
            loop_state[:char] = [first(char_list); loop_state[:char]]
            char_list = rest(char_list)
        end
        return char_allfromstring(loop_state)
    end
end
