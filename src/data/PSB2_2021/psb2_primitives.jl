"""
Function for replacing a character in a string.
"""
function replace_in_string(str, int, char) 
    arr = collect(str)
    arr[int] = char
    join(arr)
    return join(arr)
end

"""
Function to merge different grammars.
"""
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


"""
Custom implementation of a while loop with a condition and a body. 

Loop is terminated either when condition is false or when `max_steps` is reached.
"""
function command_while(condition::Any, body::Any, max_steps::Int=1000)
    counter = max_steps;
    res = nothing
    
    while condition && counter > 0
        res = eval(body)
        counter -= 1
    end
    return res
end
