function boolean_and(state)
    if length(state[:boolean]) >= 2
        result = stack_ref(state[:boolean], 0) && stack_ref(state[:boolean], 1)
        return push_item(result, :boolean, pop_item(pop_item(state, :boolean), :boolean))
    end
    return state
end

function boolean_or(state)
    if length(state[:boolean]) >= 2
        result = stack_ref(state[:boolean], 0) || stack_ref(state[:boolean], 1)
        return push_item(result, :boolean, pop_item(pop_item(state, :boolean), :boolean))
    end
    return state
end

function boolean_not(state)
    if !isempty(state[:boolean])
        result = !stack_ref(state[:boolean], 0)
        return push_item(result, :boolean, pop_item(state, :boolean))
    end
    return state
end

function boolean_xor(state)
    if length(state[:boolean]) >= 2
        result = xor(stack_ref(state[:boolean], 0), stack_ref(state[:boolean], 1))
        return push_item(result, :boolean, pop_item(pop_item(state, :boolean), :boolean))
    end
    return state
end

function boolean_invert_first_then_and(state)
    if length(state[:boolean]) >= 2
        result = !stack_ref(state[:boolean], 0) && stack_ref(state[:boolean], 1)
        return push_item(result, :boolean, pop_item(pop_item(state, :boolean), :boolean))
    end
    return state
end

function boolean_invert_second_then_and(state)
    if length(state[:boolean]) >= 2
        result = stack_ref(state[:boolean], 0) && !stack_ref(state[:boolean], 1)
        return push_item(result, :boolean, pop_item(pop_item(state, :boolean), :boolean))
    end
    return state
end

function boolean_frominteger(state)
    if !isempty(state[:integer])
        result = !iszero(stack_ref(state[:integer], 0))
        return push_item(result, :boolean, pop_item(state, :integer))
    end
    return state
end

function boolean_fromfloat(state)
    if !isempty(state[:float])
        result = !iszero(stack_ref(state[:float], 0))
        return push_item(result, :boolean, pop_item(state, :float))
    end
    return state
end
