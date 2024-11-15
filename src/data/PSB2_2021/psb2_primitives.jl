"""
Function for replacing the character at index 'int' with new character 'char'.
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
    grammar_to_construct = ContextSensitiveGrammar()
    for g in gs
        for i in eachindex(g.rules)
            ex = :($(g.types[i]) = $(g.rules[i]))
            add_rule!(grammar_to_construct, ex)
        end
    end
    return grammar_to_construct
end


"""
Custom implementation of a while loop with a condition and a body. 

Loop is terminated either when condition is false or when `max_steps` is reached.
"""
function command_while(condition::Any, body::Any, max_steps::Int=1000)
    counter = max_steps;
    res = nothing
    
    while eval(condition) && counter > 0
        res = eval(body)
        counter -= 1
    end
    return res
end
