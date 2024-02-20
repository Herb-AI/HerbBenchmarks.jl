function replace_in_string(str, int, char) 
    arr = collect(str)
    arr[int] = char
    join(arr)
    return join(arr)
end


function merge_grammar(gs::Vector{ContextSensitiveGrammar})
    new_grammar = @csgrammar begin end
    for g in gs
        for i in eachindex(g.rules)
            ex = :($(g.types[i]) = $(g.rules[i]))
            add_rule!(new_grammar, ex)
        end
    end
    return new_grammar
end