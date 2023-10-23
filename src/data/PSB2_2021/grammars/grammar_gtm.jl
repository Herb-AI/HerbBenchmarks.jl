include("util.jl")

function gtm_left(state)
    if haskey(state[:gtm], :position)
        state[:gtm][:position] -= 1
        return trace("gtm_left", state)
    end
    return state
end

function gtm_right(state)
    if haskey(state[:gtm], :position)
        state[:gtm][:position] += 1
        return trace("gtm_right", state)
    end
    return state
end

function gtm_inc_delay(state)
    if haskey(state[:gtm], :delay)
        state[:gtm][:delay] += 1
        return trace("gtm_inc_delay", state)
    end
    return state
end

function gtm_dec_delay(state)
    if haskey(state[:gtm], :delay)
        state[:gtm][:delay] -= 1
        return trace("gtm_dec_delay", state)
    end
    return state
end

function gtm_dub1(state)
    if haskey(state[:gtm], :position)
        pos = state[:gtm][:position]
        delay = state[:gtm][:delay]
        if haskey(state[:gtm][:tracks][1], pos)
            state[:gtm][:tracks][0][pos] = state[:gtm][:tracks][1][pos - delay]
            state[:gtm][:position] += 1
        end
        return trace("gtm_dub1", state)
    end
    return state
end
