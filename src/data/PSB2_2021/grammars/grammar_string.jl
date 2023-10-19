function string_frominteger(state)
    if length(state[:integer]) > 0
        item = state[:integer][1]
        state[:integer] = state[:integer][2:end]
        push!(state[:string], string(item))
    end
    return state
end

function string_fromfloat(state)
    if length(state[:float]) > 0
        item = state[:float][1]
        state[:float] = state[:float][2:end]
        push!(state[:string], string(item))
    end
    return state
end

function string_fromboolean(state)
    if length(state[:boolean]) > 0
        item = state[:boolean][1]
        state[:boolean] = state[:boolean][2:end]
        push!(state[:string], string(item))
    end
    return state
end

function string_fromchar(state)
    if length(state[:char]) > 0
        item = state[:char][1]
        state[:char] = state[:char][2:end]
        push!(state[:string], string(item))
    end
    return state
end

function string_concat(state)
    if length(state[:string]) > 1
        if length(join(state[:string])) <= max_string_length
            result = join(popfirst!(state[:string]), popfirst!(state[:string]))
            push!(state[:string], result)
        end
    end
    return state
end

function string_conjchar(state)
    if length(state[:string]) > 0 && length(state[:char]) > 0
        result = string(state[:string][1], state[:char][1])
        if length(result) <= max_string_length
            state[:string] = state[:string][2:end]
            state[:char] = state[:char][2:end]
            push!(state[:string], result)
        end
    end
    return state
end

function string_take(state)
    if length(state[:string]) > 0 && length(state[:integer]) > 0
        count = state[:integer][1]
        string_val = state[:string][1]
        state[:string] = state[:string][2:end]
        state[:integer] = state[:integer][2:end]
        push!(state[:string], string_val[1:count])
    end
    return state
end

function string_substring(state)
    if length(state[:string]) > 0 && length(state[:integer]) > 1
        string_val = state[:string][1]
        first_index = min(length(string_val), max(0, state[:integer][2]))
        second_index = min(length(string_val), max(first_index, state[:integer][1]))
        state[:string] = state[:string][2:end]
        state[:integer] = state[:integer][3:end]
        push!(state[:string], string_val[first_index:second_index])
    end
    return state
end

function string_first(state)
    if length(state[:string]) > 0 && !isempty(state[:string][1])
        char_val = state[:string][1][1]
        state[:string][1] = state[:string][1][2:end]
        push!(state[:char], char_val)
    end
    return state
end

function string_last(state)
    if length(state[:string]) > 0 && !isempty(state[:string][1])
        char_val = state[:string][1][end]
        state[:string][1] = state[:string][1][1:end-1]
        push!(state[:char], char_val)
    end
    return state
end

function string_nth(state)
    if length(state[:string]) > 0 && length(state[:integer]) > 0 && !isempty(state[:string][1])
        string_val = state[:string][1]
        index = state[:integer][1] % length(string_val)
        state[:string][1] = string_val[2:end]
        state[:integer] = state[:integer][2:end]
        push!(state[:char], string_val[index])
    end
    return state
end

function string_rest(state)
    if length(state[:string]) > 0
        string_val = state[:string][1]
        state[:string] = state[:string][2:end]
        push!(state[:string], string_val[2:end])
    end
    return state
end

function string_butlast(state)
    if length(state[:string]) > 0
        string_val = state[:string][1]
        state[:string] = state[:string][2:end]
        push!(state[:string], string_val[1:end-1])
    end
    return state
end

function string_length(state)
    if length(state[:string]) > 0
        length_val = length(state[:string][1])
        state[:string] = state[:string][2:end]
        push!(state[:integer], length_val)
    end
    return state
end

function string_reverse(state)
    if length(state[:string]) > 0
        string_val = state[:string][1]
        state[:string] = state[:string][2:end]
        push!(state[:string], reverse(string_val))
    end
    return state
end

function string_parse_to_chars(state)
    if length(state[:string]) > 0
        char_list = reverse(collect(state[:string][1]))
        state[:string] = state[:string][2:end]
        for char in char_list
            push!(state[:string], string(char))
        end
    end
    return state
end

function string_split(state)
    if length(state[:string]) > 0
        words = filter(x -> !isempty(x), split(trim(state[:string][1]), r"\s+"))
        state[:string] = state[:string][2:end]
        for word in words
            push!(state[:string], word)
        end
    end
    return state
end

function string_emptystring(state)
    if isempty(state[:string])
        return state
    else
        result_boolean = isempty(state[:string][end])
        push!(state[:boolean], result_boolean)
        pop!(state[:string])
        return state
    end
end

function string_contains(state)
    if length(state[:string]) < 2
        return state
    else
        sub = state[:string][end]
        full = state[:string][end - 1]
        result_boolean = occursin(sub, full)
        push!(state[:boolean], result_boolean)
        pop!(state[:string])
        pop!(state[:string])
        return state
    end
end

function string_containschar(state)
    if isempty(state[:string]) || isempty(state[:char])
        return state
    else
        sub = string(state[:char][end])
        full = state[:string][end - 1]
        index = searchindex(full, sub)
        result = !isnothing(index)
        push!(state[:boolean], result)
        pop!(state[:char])
        pop!(state[:string])
        return state
    end
end

function string_indexofchar(state)
    if isempty(state[:string]) || isempty(state[:char])
        return state
    else
        sub = string(state[:char][end])
        full = state[:string][end - 1]
        index = searchindex(full, sub)
        push!(state[:integer], isnothing(index) ? 0 : index)
        pop!(state[:char])
        pop!(state[:string])
        return state
    end
end

function string_occurrencesofchar(state)
    if isempty(state[:string]) || isempty(state[:char])
        return state
    else
        ch = state[:char][end]
        st = state[:string][end - 1]
        occ = count(==(ch), st)
        push!(state[:integer], occ)
        pop!(state[:char])
        pop!(state[:string])
        return state
    end
end

function string_replace(state)
    if length(state[:string]) < 3
        return state
    else
        result = replace(state[:string][end - 2], state[:string][end - 1], state[:string][end])
        if length(result) <= max_string_length
            push!(state[:string], result)
            pop!(state[:string])
            pop!(state[:string])
            pop!(state[:string])
        end
        return state
    end
end

function string_replacefirst(state)
    if length(state[:string]) < 3
        return state
    else
        result = replacefirst(state[:string][end - 2], state[:string][end - 1], state[:string][end])
        if length(result) <= max_string_length
            push!(state[:string], result)
            pop!(state[:string])
            pop!(state[:string])
            pop!(state[:string])
        end
        return state
    end
end

function string_replacechar(state)
    if isempty(state[:string]) || length(state[:char]) < 2
        return state
    else
        result = replace(state[:string][end - 1], string(state[:char][end - 1]), string(state[:char][end]))
        if length(result) <= max_string_length
            push!(state[:string], result)
            pop!(state[:char])
            pop!(state[:char])
            pop!(state[:string])
        end
        return state
    end
end

function string_replacefirstchar(state)
    if isempty(state[:string]) || length(state[:char]) < 2
        return state
    else
        result = replacefirst(state[:string][end - 1], string(state[:char][end - 1]), string(state[:char][end]))
        if length(result) <= max_string_length
            push!(state[:string], result)
            pop!(state[:char])
            pop!(state[:char])
            pop!(state[:string])
        end
        return state
    end
end

function string_removechar(state)
    if isempty(state[:string]) || isempty(state[:char])
        return state
    else
        result = replace(state[:string][end - 1], string(state[:char][end]), "")
        push!(state[:string], result)
        pop!(state[:char])
        pop!(state[:string])
        return state
    end
end

function string_setchar(state)
    if isempty(state[:string]) || isempty(state[:char]) || isempty(state[:integer])
        return state
    else
        s = state[:string][end]
        item = string(state[:char][end])
        index = isempty(s) ? 0 : state[:integer][end]
        result = isempty(s) ? s : string(s)[1:index - 1] * item * string(s)[index + 1:end]
        push!(state[:string], result)
        pop!(state[:char])
        pop!(state[:integer])
        pop!(state[:string])
        return state
    end
end

function string_capitalize(state)
    if isempty(state[:string])
        return state
    else
        cap = state[:string][end]
        push!(state[:string], string(Capitalize(cap)))
        pop!(state[:string])
        return state
    end
end

function string_uppercase(state)
    if isempty(state[:string])
        return state
    else
        up = state[:string][end]
        push!(state[:string], uppercase(up))
        pop!(state[:string])
        return state
    end
end

function string_lowercase(state)
    if isempty(state[:string])
        return state
    else
        low = state[:string][end]
        push!(state[:string], lowercase(low))
        pop!(state[:string])
        return state
    end
end

function exec_string_iterate(state)
    if isempty(state[:string]) || isempty(state[:exec])
        return state
    else
        s = state[:string][end]
        if isempty(s)
            pop!(state[:string])
            pop!(state[:exec])
        elseif isempty(s[2:end])
            pop!(state[:string])
            push!(state[:char], s[1])
        else
            pop!(state[:string])
            push!(state[:exec], "exec_string_iterate")
            push!(state[:exec], join(s[2:end]))
            push!(state[:exec], state[:exec][end - 1])
            push!(state[:char], s[1])
        end
        return state
    end
end

function string_sort(state)
    if isempty(state[:string])
        return state
    else
        stri = state[:string][end]
        push!(state[:string], join(sort(collect(stri))))
        pop!(state[:string])
        return state
    end
end

function string_includes(state)
    if length(state[:string]) > 1
        stri = state[:string][2]
        substr = state[:string][1]
        state[:string] = state[:string][3:end]
        state[:boolean] = stringoccurs(substr, stri)
    end
    return state
end

function string_indexof(state)
    if length(state[:string]) > 1
        stri = state[:string][2]
        substr = state[:string][1]
        state[:string] = state[:string][3:end]
        index = findfirst(occursin(substr, stri))
        if index !== nothing
            state[:integer] = index
        end
    end
    return state
end
