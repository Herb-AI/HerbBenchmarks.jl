function init_gtm(push_state)
    return merge(push_state, Dict(
        :gtm => Dict(
            :position => 1,
            :delay => 0,
            :tracks => [Dict(), Dict(), Dict()],
            :trace => []
        )
    ))
end

function ensure_instruction_map(instr_map)
    if isa(instr_map, Dict)
        return instr_map
    else
        return merge(Dict(
            :instruction => "exec_noop",
            :close => 0,
            :silent => false,
            :random_insertion => false,
            :uuid => JavaUUID.randomUUID()
        ), instr_map)
    end
end

function load_track(push_state, track_index, genome)
    push_state[:gtm][:tracks][track_index] = Dict()
    for (i, instr_map) in enumerate(genome)
        push_state[:gtm][:tracks][track_index][i] = ensure_instruction_map(instr_map)
    end
    return push_state
end

function dump_track(push_state, track_index)
    return [instr_map for instr_map in values(push_state[:gtm][:tracks][track_index]) if !isempty(instr_map)]
end

function trace(trace_info, push_state)
    push_state[:gtm][:trace] = push_state[:gtm][:trace] * [trace_info]
    return push_state
end

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
