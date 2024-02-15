function exec_noop(state)
    return state
end

function code_noop(state)
    return state
end

function noop_open_paren(state)
    return state
end

function noop_delete_prev_paren_pair(state)
    return state
end

function code_append(state)
    if !isempty(rest(state[:code]))
        new_item = not_lazy([ensure_list(stack_ref(:code, 0, state)); ensure_list(stack_ref(:code, 1, state))])
        if count_points(new_item) <= global_max_points
            return push_item(new_item, :code, pop_item(:code, pop_item(:code, state)))
        end
    end
    return state
end

function code_atom(state)
    if !isempty(state[:code])
        return push_item(!isa(stack_ref(:code, 0, state), AbstractArray{Any}), :boolean, pop_item(:code, state))
    end
    return state
end

function code_car(state)
    if !isempty(state[:code]) && length(ensure_list(stack_ref(:code, 0, state))) > 0
        return push_item(first(ensure_list(stack_ref(:code, 0, state))), :code, pop_item(:code, state))
    end
    return state
end

function code_cdr(state)
    if !isempty(state[:code])
        return push_item(rest(ensure_list(stack_ref(:code, 0, state))), :code, pop_item(:code, state))
    end
    return state
end

function code_cons(state)
    if !isempty(rest(state[:code]))
        new_item = cons(stack_ref(:code, 1, state), ensure_list(stack_ref(:code, 0, state)))
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(new_item, :code, pop_item(:code, pop_item(:code, state)))
        end
    end
    return state
end

function code_do(state)
    if !isempty(state[:code])
        return push_item(stack_ref(:code, 0, state), :exec, push_item("code_pop", :exec, state))
    end
    return state
end

function code_do_star(state)
    if !isempty(state[:code])
        return push_item(stack_ref(:code, 0, state), :exec, pop_item(:code, state))
    end
    return state
end

function code_do_star_range(state)
    if !isempty(state[:code]) && !isempty(state[:integer]) && !isempty(rest(state[:integer]))
        to_do = first(state[:code])
        current_index = first(state[:integer])
        destination_index = first(state[:integer])
        args_popped = pop_item(:integer, pop_item(:integer, pop_item(:code, state)))
        increment = current_index < destination_index ? 1 : current_index > destination_index ? -1 : 0
        if increment == 0
            continuation = args_popped
        else
            continuation = push_item([current_index + increment, destination_index, "code_quote", to_do, "code_do_star_range"], :exec, args_popped)
        end
        return push_item(to_do, :exec, push_item(current_index, :integer, continuation))
    end
    return state
end

function exec_do_star_range(state)
    if !isempty(state[:exec]) && !isempty(state[:integer]) && !isempty(rest(state[:integer]))
        to_do = first(state[:exec])
        current_index = first(state[:integer])
        destination_index = first(state[:integer])
        args_popped = pop_item(:integer, pop_item(:integer, pop_item(:exec, state)))
        increment = current_index < destination_index ? 1 : current_index > destination_index ? -1 : 0
        if increment == 0
            continuation = args_popped
        else
            continuation = push_item([current_index + increment, destination_index, "exec_do_star_range", to_do], :exec, args_popped)
        end
        return push_item(to_do, :exec, push_item(current_index, :integer, continuation))
    end
    return state
end

function code_do_star_count(state)
    if !isempty(state[:integer]) && first(state[:integer]) >= 1 && !isempty(state[:code])
        return push_item([0, first(state[:integer]) - 1, "code_quote", first(state[:code]), "code_do_star_range"], :exec, pop_item(:integer, pop_item(:code, state)))
    end
    return state
end

function exec_do_star_count(state)
    if !isempty(state[:integer]) && first(state[:integer]) >= 1 && !isempty(state[:exec])
        return push_item([0, first(state[:integer]) - 1, "exec_do_star_range", first(state[:exec])], :exec, pop_item(:integer, pop_item(:exec, state)))
    end
    return state
end

function exec_while(state)
    if isempty(state[:exec])
        return state
    end
    if isempty(state[:boolean])
        return pop_item(:exec, state)
    end
    if !stack_ref(:boolean, 0, state)
        return pop_item(:exec, pop_item(:boolean, state))
    end
    block = stack_ref(:exec, 0, state)
    return pop_item(:boolean, push_item(block, :exec, push_item("exec_while", :exec, state)))
end

function exec_do_star_while(state)
    if isempty(state[:exec])
        return state
    end
    block = stack_ref(:exec, 0, state)
    return push_item(block, :exec, push_item("exec_while", :exec, state))
end

function code_map(state)
    if !isempty(state[:code]) && !isempty(state[:exec])
        return push_item(
            [doall([list("code_quote", item, first(state[:exec])) for item in ensure_list(first(state[:code]))]);
            "code_wrap";
            doall([list("code_cons", item) for item in rest(ensure_list(first(state[:code])))])],
            :exec,
            pop_item(:code, pop_item(:exec, state))
        )
    end
    return state
end

function code_fromboolean(state)
    if !isempty(state[:boolean])
        return push_item(first(state[:boolean]), :code, pop_item(:boolean, state))
    end
    return state
end

function code_fromfloat(state)
    if !isempty(state[:float])
        return push_item(first(state[:float]), :code, pop_item(:float, state))
    end
    return state
end

function code_frominteger(state)
    if !isempty(state[:integer])
        return push_item(first(state[:integer]), :code, pop_item(:integer, state))
    end
    return state
end

function code_quote(state)
    if !isempty(state[:exec])
        return push_item([stack_ref(:exec, 0, state)], :exec, push_item("exec_quote", :exec, state))
    end
    return state
end

function code_if(state)
    if !isempty(state[:boolean]) && !isempty(rest(state[:code]))
        return push_item(
            first(state[:boolean]) ? first(rest(state[:code])) : first(state[:code]),
            :exec,
            pop_item(:boolean, pop_item(:code, pop_item(:code, state))
        ))
    end
    return state
end

function exec_if(state)
    if !isempty(state[:boolean]) && !isempty(rest(state[:exec]))
        return push_item(
            first(state[:boolean]) ? first(state[:exec]) : first(rest(state[:exec])),
            :exec,
            pop_item(:boolean, pop_item(:exec, pop_item(:exec, state))
        ))
    end
    return state
end

function exec_when(state)
    if !isempty(state[:boolean]) && !isempty(state[:exec])
        if first(state[:boolean])
            return pop_item(:boolean, state)
        else
            return pop_item(:boolean, pop_item(:exec, state))
        end
    end
    return state
end

function code_length(state)
    if !isempty(state[:code])
        return push_item(length(ensure_list(first(state[:code]))), :integer, pop_item(:code, state))
    end
    return state
end

function code_list(state)
    if !isempty(rest(state[:code]))
        new_item = [first(rest(state[:code])); first(state[:code])]
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(new_item, :code, pop_item(:code, pop_item(:code, state)))
        end
    end
    return state
end

function code_wrap(state)
    if !isempty(state[:code])
        new_item = [first(state[:code])]
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(new_item, :code, pop_item(:code, state))
        end
    end
    return state
end

function code_member(state)
    if !isempty(rest(state[:code]))
        return push_item(
            !isempty(findall(x -> x == first(rest(state[:code])), ensure_list(first(state[:code])))),
            :boolean,
            pop_item(:code, pop_item(:code, state))
        )
    end
    return state
end

function code_nth(state)
    if !isempty(state[:integer]) && !isempty(state[:code]) && !isempty(ensure_list(first(state[:code])))
        return push_item(
            getindex(ensure_list(first(state[:code])), mod(abs(first(state[:integer])), length(ensure_list(first(state[:code]))))),
            :code,
            pop_item(:integer, pop_item(:code, state))
        )
    end
    return state
end

function code_nthcdr(state)
    if !isempty(state[:integer]) && !isempty(state[:code]) && !isempty(ensure_list(first(state[:code])))
        return push_item(
            drop(ensure_list(first(state[:code])), mod(abs(first(state[:integer])), length(ensure_list(first(state[:code]))))),
            :code,
            pop_item(:integer, pop_item(:code, state))
        )
    end
    return state
end

function code_null(state)
    if !isempty(state[:code])
        return push_item(!(isa(first(state[:code]), AbstractArray{Any}) && isempty(first(state[:code]))), :boolean, pop_item(:code, state))
    end
    return state
end

function code_size(state)
    if !isempty(state[:code])
        return push_item(count_points(first(state[:code])), :integer, pop_item(:code, state))
    end
    return state
end

function code_extract(state)
    if !isempty(state[:code]) && !isempty(state[:integer])
        return push_item(code_at_point(first(state[:code]), first(state[:integer])), :code, pop_item(:integer, pop_item(:code, state)))
    end
    return state
end

function code_insert(state)
    if !isempty(rest(state[:code])) && !isempty(state[:integer])
        new_item = insert_code_at_point(first(state[:code]), first(state[:integer]), second(state[:code]))
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(new_item, :code, pop_item(:code, pop_item(:code, pop_item(:integer, state))))
        end
    end
    return state
end

function code_subst(state)
    if !isempty(rest(state[:code])) && !isempty(rest(state[:code])) && !isempty(rest(rest(state[:code])))
        new_item = subst(stack_ref(:code, 2, state), stack_ref(:code, 1, state), stack_ref(:code, 0, state))
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(new_item, :code, pop_item(:code, pop_item(:code, pop_item(:code, state))))
        end
    end
    return state
end

function code_contains(state)
    if !isempty(rest(state[:code])) && !isempty(state[:code])
        return push_item(
            !isempty(stack_ref(:code, 1, state) in ensure_list(stack_ref(:code, 0, state))),
            :boolean,
            pop_item(:code, pop_item(:code, state))
        )
    end
    return state
end

function code_container(state)
    if !isempty(state[:code]) && !isempty(rest(state[:code]))
        return push_item(
            containing_subtree(stack_ref(:code, 0, state), stack_ref(:code, 1, state)),
            :code,
            pop_item(:code, pop_item(:code, state))
        )
    end
    return state
end

function code_position(state)
    if !isempty(rest(state[:code])) && !isempty(state[:code])
        positions = []
        for (idx, elt) in enumerate(ensure_list(stack_ref(:code, 0, state)))
            if elt == stack_ref(:code, 1, state)
                push!(positions, idx)
            end
        end
        position = isempty(positions) ? -1 : first(positions)
        return push_item(position, :integer, pop_item(:code, pop_item(:code, state)))
    end
    return state
end

function exec_k(state)
    if !isempty(state[:exec]) && !isempty(rest(state[:exec]))
        return push_item(first(state[:exec]), :exec, pop_item(:exec, pop_item(:exec, state))
    end
    return state
end

function exec_s(state)
    if !isempty(state[:exec]) && !isempty(rest(state[:exec])) && !isempty(rest(rest(state[:exec]))
        stk = state[:exec]
        x = first(stk)
        y = first(rest(stk))
        z = first(rest(rest(stk)))
        if count_points([y, z]) <= global_max_points && height_of_nested_list([y, z]) <= global_max_nested_depth
            return push_item(x, :exec, push_item(z, :exec, push_item([y, z], :exec, pop_item(:exec, pop_item(:exec, pop_item(:exec, state))))))
        end
    end
    return state
end

function exec_y(state)
    if !isempty(state[:exec])
        new_item = [exec_y, first(state[:exec])]
        if count_points(new_item) <= global_max_points && height_of_nested_list(new_item) <= global_max_nested_depth
            return push_item(first(state[:exec]), :exec, push_item(new_item, :exec, pop_item(:exec, state))
        end
    end
    return state
end
