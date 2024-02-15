using Random

function push_item(item, item_type, state)
    if haskey(state, item_type)
        state[item_type] = [item; state[item_type]]
    else
        state[item_type] = [item]
    end
    return state
end

function boolean_rand(state)
    push_item(rand([true,false]), :boolean, state)
end

function integer_rand(state)
    push_item(rand(1:1000), :integer, state)
end

function float_rand(state)
    push_item(rand(Float64), :float, state)
end

function code_rand(state)
    if !(isempty(state[:integer]))
        if isempty(global_atom_generators)
            println("code_rand: global-atom-generators is empty.")
            return state
        else
            push_item(random_push_code(max(1, abs(mod(state[:integer][1], max_points_in_random_expressions))), global_atom_generators),
                :code,
                pop_item(:integer, state))
        end
    end
    return state
end

function code_rand_atom(state)
    if isempty(global_atom_generators)
        println("code_rand_atom: global_atom_generators is empty.")
    else
        push_item(rand(global_atom_generators), :code, state)
    end
    return state
end

function string_rand(state)   
    str_length = rand(min_random_string_length:max_random_string_length) 
    rand_string = join(rand(['\n', '\t', [Char(id) for id in 32:126]...], str_length), "")
    
    push_item(rand_string, :string, state)
    return state
end

function char_rand(state)
    char_set = vcat(['\n', '\t'], Char(32):Char(126))
    rand_char = rand(char_set)
    
    push_item(rand_char, :char, state)
    return state
end

