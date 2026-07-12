function _column_index(table::MorpheusTable, column::Symbol)
    idx = get(morpheus_colindex(table), column, nothing)
    if idx === nothing
        throw(ArgumentError("Unknown Morpheus column $column in $(morpheus_columns(table))"))
    end
    return idx
end

function _selected_columns(table::MorpheusTable, sel::ColumnSelection)
    columns = morpheus_columns(table)
    _check_distinct_columns(sel.columns)
    if any(!(c in columns) for c in sel.columns)
        throw(ArgumentError("Unknown Morpheus column(s) in $columns"))
    end
    if sel.exclude
        excluded = Set(sel.columns)
        return [c for c in columns if !(c in excluded)]
    else
        return copy(sel.columns)
    end
end

function _check_distinct_columns(columns::Vector{Symbol})
    if length(unique(columns)) != length(columns)
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    end
    return columns
end

function _check_fresh_columns(existing::Vector{Symbol}, columns::Symbol...)
    _check_distinct_columns(Symbol[columns...])
    conflicts = [c for c in columns if c in existing]
    if !isempty(conflicts)
        throw(ArgumentError("Cannot create existing Morpheus column(s): $conflicts"))
    end
    return columns
end

_numeric(x) = x isa Number ? float(x) : tryparse(Float64, string(x))
_same_value(a, b) = isequal(a, b) || (a isa Number && b isa Number && isapprox(a, b; atol=1e-6, rtol=1e-6))

function gather(table::MorpheusTable, key_col::Symbol, value_col::Symbol, sel::ColumnSelection)
    if key_col == value_col
        throw(ArgumentError("Gather key and value columns must differ"))
    end
    gathered = _selected_columns(table, sel)
    ids = [c for c in morpheus_columns(table) if !(c in gathered)]
    _check_fresh_columns(ids, key_col, value_col)

    columns = vcat(ids, [key_col, value_col])
    if isempty(gathered)
        return _morpheus_table_from_columns(columns, [Any[] for _ in columns]; semantics=table.semantics)
    end

    df = stack(table.df, gathered; variable_name=key_col, value_name=value_col)
    return _morpheus_table_from_df_nocopy(df[:, columns]; semantics=table.semantics)
end

function spread(table::MorpheusTable, key_col::Symbol, value_col::Symbol)
    if key_col == value_col
        throw(ArgumentError("Spread key and value columns must differ"))
    end
    key_values = table_column(table, key_col)
    value_values = table_column(table, value_col)
    id_cols = [c for c in morpheus_columns(table) if c != key_col && c != value_col]
    new_cols = sort(unique(Symbol(string(value)) for value in key_values); by=string)
    columns = _check_distinct_columns(vcat(id_cols, new_cols))

    id_values = [table_column(table, c) for c in id_cols]
    grouped = Dict{Tuple{Vararg{Any}},Dict{Symbol,Any}}()
    for row_idx in 1:length(table)
        key = Tuple(values[row_idx] for values in id_values)
        output_col = Symbol(string(key_values[row_idx]))
        values = get!(grouped, key, Dict{Symbol,Any}())
        if haskey(values, output_col)
            throw(ArgumentError("Duplicate Morpheus spread key $output_col for row key $key"))
        end
        values[output_col] = value_values[row_idx]
    end

    rows = Vector{Any}[]
    for key in sort(collect(keys(grouped)); by=string)
        values = grouped[key]
        push!(rows, Any[collect(key)..., [get(values, c, missing) for c in new_cols]...])
    end
    return MorpheusTable(columns, rows; semantics=table.semantics)
end

function unite(table::MorpheusTable, new_col::Symbol, c1::Symbol, c2::Symbol)
    if c1 == c2
        throw(ArgumentError("Unite source columns must differ"))
    end
    columns_in = morpheus_columns(table)
    i1, i2 = _column_index(table, c1), _column_index(table, c2)
    insert_at = min(i1, i2)
    keep = [i for i in eachindex(columns_in) if i != i1 && i != i2]
    columns = copy(columns_in[keep])
    if new_col in columns
        throw(ArgumentError("Cannot create existing Morpheus column $new_col"))
    end
    insert!(columns, insert_at, new_col)

    data_in = morpheus_data(table)
    data = copy.(data_in[keep])
    col1, col2 = table_column(table, c1), table_column(table, c2)
    insert!(data, insert_at, Any[string.(col1, "_", col2)...])
    return _morpheus_table_from_columns(columns, data, [c for c in morpheus_groups(table) if c in columns];
        semantics=table.semantics)
end

function separate(table::MorpheusTable, column::Symbol, c1::Symbol, c2::Symbol)
    if c1 == c2
        throw(ArgumentError("Separate output columns must differ"))
    end
    columns_in = morpheus_columns(table)
    columns = copy(columns_in)

    idx = _column_index(table, column)
    splice!(columns, idx:idx, [c1, c2])
    _check_distinct_columns(columns)

    first_values = Any[]
    second_values = Any[]
    for value in table_column(table, column)
        parts = split(string(value), r"[_.|\-]"; limit=2)
        push!(first_values, first(parts))
        push!(second_values, length(parts) == 1 ? "" : parts[2])
    end

    data = copy.(morpheus_data(table))
    splice!(data, idx:idx, [first_values, second_values])
    groups = Symbol[]
    for c in morpheus_groups(table)
        if c == column
            append!(groups, [c1, c2])
        elseif c in columns
            push!(groups, c)
        end
    end
    return _morpheus_table_from_columns(columns, data, groups; semantics=table.semantics)
end

function select(table::MorpheusTable, sel::ColumnSelection)
    columns = _selected_columns(table, sel)
    df = table.df[:, columns]
    return _morpheus_table_from_df_nocopy(df, [c for c in morpheus_groups(table) if c in columns];
        semantics=table.semantics)
end

function filter(table::MorpheusTable, pred::Predicate)
    values = table_column(table, pred.column)
    mask = _predicate_holds.(values, Ref(pred))
    return _morpheus_table_from_df_nocopy(table.df[mask, :], copy(morpheus_groups(table)); semantics=table.semantics)
end

function _predicate_holds(value, pred::Predicate)
    pred.op == :(==) && return _same_value(value, pred.value)
    pred.op == :(!=) && return !_same_value(value, pred.value)
    left = _numeric(value)
    right = _numeric(pred.value)
    if left === nothing || right === nothing
        return false
    end
    pred.op == :> && return left > right
    pred.op == :< && return left < right
    return false
end

function group_by(table::MorpheusTable, sel::ColumnSelection)
    groups = _selected_columns(table, sel)
    group_count = 1
    if !isempty(groups)
        group_count = max(1, nrow(unique(table.df[:, groups])))
    end
    semantics = table.semantics
    grouped_semantics = MorpheusSemantics(semantics.input_columns, semantics.input_values, group_count)
    return _morpheus_table_from_df_nocopy(copy(table.df), groups, morpheus_raw(table); semantics=grouped_semantics)
end

function summarise(table::MorpheusTable, new_col::Symbol, agg::Aggregation)
    groups = morpheus_groups(table)
    _check_fresh_columns(groups, new_col)
    columns = vcat(groups, [new_col])
    grouped = Dict{Tuple{Vararg{Any}},Vector{Int}}()
    for row_idx in 1:length(table)
        key = Tuple(value_at(table, row_idx, c) for c in groups)
        push!(get!(grouped, key, Int[]), row_idx)
    end
    rows = Vector{Any}[]
    if isempty(grouped)
        if isempty(groups)
            push!(rows, Any[_aggregate(table, Int[], agg)])
        end
    else
        for key in sort(collect(keys(grouped)); by=string)
            push!(rows, Any[collect(key)..., _aggregate(table, grouped[key], agg)])
        end
    end
    return MorpheusTable(columns, rows; semantics=table.semantics)
end

function _aggregate(table::MorpheusTable, rows::Vector{Int}, agg::Aggregation)
    agg.op == :count && return length(rows)

    column_values = table_column(table, agg.column::Symbol)
    values = [_numeric(column_values[i]) for i in rows]
    filter!(x -> x !== nothing, values)
    if isempty(values)
        return missing
    end

    agg.op == :sum && return sum(values)
    agg.op == :mean && return sum(values) / length(values)
    return missing
end

function mutate(table::MorpheusTable, new_col::Symbol, expr::ValueExpression)
    _check_fresh_columns(morpheus_columns(table), new_col)
    df = copy(table.df)
    if expr.op == :div_sum
        denom = _column_sum(table, expr.left)
        left_values = table_column(table, expr.left)
        df[!, new_col] = Any[_eval_div_sum(value, denom) for value in left_values]
    else
        df[!, new_col] = _eval_expr(table, expr)
    end
    return _morpheus_table_from_df_nocopy(df, copy(morpheus_groups(table)); semantics=table.semantics)
end

function _eval_div_sum(left, denom)
    lnum = _numeric(left)
    if lnum === nothing || denom === nothing || iszero(denom)
        return missing
    end
    return lnum / denom
end

function _eval_expr(table::MorpheusTable, expr::ValueExpression)
    left = table_column(table, expr.left)
    expr.op == :copy && return Any[left...]
    right = table_column(table, expr.right::Symbol)
    return Any[_eval_binary_expr(l, r, expr.op) for (l, r) in zip(left, right)]
end

function _eval_binary_expr(left, right, op::Symbol)
    lnum, rnum = _numeric(left), _numeric(right)
    if lnum === nothing || rnum === nothing
        return missing
    end
    op == :/ && return iszero(rnum) ? missing : lnum / rnum
    op == :+ && return lnum + rnum
    op == :- && return lnum - rnum
    op == :* && return lnum * rnum
    return missing
end

function _column_sum(table::MorpheusTable, column::Symbol)
    values = [_numeric(value) for value in table_column(table, column)]
    filter!(x -> x !== nothing, values)
    isempty(values) && return nothing
    return sum(values)
end

function arrange(table::MorpheusTable, sel::ColumnSelection)
    columns = _selected_columns(table, sel)
    df = isempty(columns) ? copy(table.df) : sort(table.df, columns)
    return _morpheus_table_from_df_nocopy(df, copy(morpheus_groups(table)); semantics=table.semantics)
end
