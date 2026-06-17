function _column_index(table::MorpheusTable, column::Symbol)
    idx = get(table.colindex, column, nothing)
    idx === nothing && throw(ArgumentError("Unknown Morpheus column $column in $(table.columns)"))
    return idx
end

function _selected_columns(table::MorpheusTable, sel::ColumnSelection)
    if sel.exclude
        excluded = Set(sel.columns)
        return [c for c in table.columns if !(c in excluded)]
    else
        return [c for c in sel.columns if c in table.columns]
    end
end

function _check_distinct_columns(columns::Vector{Symbol})
    length(unique(columns)) == length(columns) ||
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    return columns
end

function _check_fresh_columns(existing::Vector{Symbol}, columns::Symbol...)
    _check_distinct_columns(Symbol[columns...])
    conflicts = [c for c in columns if c in existing]
    isempty(conflicts) ||
        throw(ArgumentError("Cannot create existing Morpheus column(s): $conflicts"))
    return columns
end

_numeric(x) = x isa Number ? float(x) : tryparse(Float64, string(x))
_same_value(a, b) = a == b || (a isa Number && b isa Number && isapprox(float(a), float(b); atol=1e-6, rtol=1e-6))

function gather(table::MorpheusTable, key_col::Symbol, value_col::Symbol, sel::ColumnSelection)
    key_col != value_col || throw(ArgumentError("gather key and value columns must differ"))
    gathered = _selected_columns(table, sel)
    ids = [c for c in table.columns if !(c in gathered)]
    _check_fresh_columns(ids, key_col, value_col)

    columns = vcat(ids, [key_col, value_col])
    data = [Any[] for _ in columns]
    id_vectors = [table_column(table, c) for c in ids]
    gathered_vectors = [(c, table_column(table, c)) for c in gathered]
    for row_idx in 1:length(table)
        id_values = Any[col[row_idx] for col in id_vectors]
        for (gathered_col, gathered_values) in gathered_vectors
            for (out_idx, value) in pairs(id_values)
                push!(data[out_idx], value)
            end
            push!(data[length(ids) + 1], gathered_col)
            push!(data[length(ids) + 2], gathered_values[row_idx])
        end
    end
    return _morpheus_table_from_columns(columns, data)
end

function spread(table::MorpheusTable, key_col::Symbol, value_col::Symbol)
    key_values = table_column(table, key_col)
    value_values = table_column(table, value_col)
    id_cols = [c for c in table.columns if c != key_col && c != value_col]
    new_cols = sort(unique(Symbol(string(value)) for value in key_values); by=string)
    columns = _check_distinct_columns(vcat(id_cols, new_cols))

    grouped = Dict{Tuple{Vararg{Any}},Dict{Symbol,Any}}()
    for row_idx in 1:length(table)
        key = Tuple(value_at(table, row_idx, c) for c in id_cols)
        values = get!(grouped, key, Dict{Symbol,Any}())
        values[Symbol(string(key_values[row_idx]))] = value_values[row_idx]
    end

    rows = Vector{Any}[]
    for key in sort(collect(keys(grouped)); by=string)
        values = grouped[key]
        push!(rows, Any[collect(key)..., [get(values, c, missing) for c in new_cols]...])
    end
    return MorpheusTable(columns, rows)
end

function unite(table::MorpheusTable, new_col::Symbol, c1::Symbol, c2::Symbol)
    i1, i2 = _column_index(table, c1), _column_index(table, c2)
    insert_at = min(i1, i2)
    keep = [i for i in eachindex(table.columns) if i != i1 && i != i2]
    columns = copy(table.columns[keep])
    new_col in columns &&
        throw(ArgumentError("Cannot create existing Morpheus column $new_col"))
    insert!(columns, insert_at, new_col)

    data = copy.(getfield(table, :data)[keep])
    col1, col2 = table_column(table, c1), table_column(table, c2)
    insert!(data, insert_at, Any[string(col1[i], "_", col2[i]) for i in 1:length(table)])
    return _morpheus_table_from_columns(columns, data,
        [c for c in table.groups if c in columns])
end

function separate(table::MorpheusTable, column::Symbol, c1::Symbol, c2::Symbol)
    idx = _column_index(table, column)
    columns = copy(table.columns)
    splice!(columns, idx:idx, [c1, c2])
    _check_distinct_columns(columns)

    first_values = Any[]
    second_values = Any[]
    for value in table_column(table, column)
        parts = split(string(value), r"[_.|\-]"; limit=2)
        push!(first_values, first(parts))
        push!(second_values, length(parts) == 1 ? "" : parts[2])
    end

    data = copy.(getfield(table, :data))
    splice!(data, idx:idx, [first_values, second_values])
    groups = [c == column ? c1 : c for c in table.groups if c in table.columns]
    return _morpheus_table_from_columns(columns, data, groups)
end

function select(table::MorpheusTable, sel::ColumnSelection)
    columns = _selected_columns(table, sel)
    data = [copy(table_column(table, c)) for c in columns]
    return _morpheus_table_from_columns(columns, data,
        [c for c in table.groups if c in columns])
end

function filter(table::MorpheusTable, pred::Predicate)
    values = table_column(table, pred.column)
    kept = [i for i in 1:length(table) if _predicate_holds(values[i], pred)]
    data = [Any[col[i] for i in kept] for col in getfield(table, :data)]
    return _morpheus_table_from_columns(copy(table.columns), data, copy(table.groups))
end

function _predicate_holds(value, pred::Predicate)
    pred.op == :(==) && return _same_value(value, pred.value)
    pred.op == :(!=) && return !_same_value(value, pred.value)
    left = _numeric(value)
    right = _numeric(pred.value)
    (left === nothing || right === nothing) && return false
    pred.op == :> && return left > right
    pred.op == :< && return left < right
    return false
end

function group_by(table::MorpheusTable, sel::ColumnSelection)
    return _morpheus_table_from_columns(copy(table.columns), copy.(getfield(table, :data)),
        _selected_columns(table, sel), table.raw)
end

function summarise(table::MorpheusTable, new_col::Symbol, agg::Aggregation)
    groups = table.groups
    _check_fresh_columns(groups, new_col)
    columns = vcat(groups, [new_col])
    grouped = Dict{Tuple{Vararg{Any}},Vector{Int}}()
    for row_idx in 1:length(table)
        key = Tuple(value_at(table, row_idx, c) for c in groups)
        push!(get!(grouped, key, Int[]), row_idx)
    end
    isempty(grouped) && (grouped[()] = Int[])

    rows = Vector{Any}[]
    for key in sort(collect(keys(grouped)); by=string)
        push!(rows, Any[collect(key)..., _aggregate(table, grouped[key], agg)])
    end
    return MorpheusTable(columns, rows)
end

function _aggregate(table::MorpheusTable, rows::Vector{Int}, agg::Aggregation)
    agg.op == :count && return length(rows)
    values = [_numeric(table_column(table, agg.column::Symbol)[i]) for i in rows]
    filter!(x -> x !== nothing, values)
    isempty(values) && return missing
    agg.op == :sum && return sum(values)
    agg.op == :mean && return sum(values) / length(values)
    return missing
end

function mutate(table::MorpheusTable, new_col::Symbol, expr::ValueExpression)
    _check_fresh_columns(table.columns, new_col)
    columns = vcat(table.columns, [new_col])
    data = copy.(getfield(table, :data))
    push!(data, Any[_eval_expr(table, row_idx, expr) for row_idx in 1:length(table)])
    return _morpheus_table_from_columns(columns, data, copy(table.groups))
end

function _eval_expr(table::MorpheusTable, row_idx::Integer, expr::ValueExpression)
    left = value_at(table, row_idx, expr.left)
    expr.op == :copy && return left
    if expr.op == :div_sum
        lnum = _numeric(left)
        denom = _column_sum(table, expr.left)
        (lnum === nothing || denom === nothing || iszero(denom)) && return missing
        return lnum / denom
    end
    right = value_at(table, row_idx, expr.right::Symbol)
    lnum, rnum = _numeric(left), _numeric(right)
    (lnum === nothing || rnum === nothing) && return missing
    expr.op == :/ && return iszero(rnum) ? missing : lnum / rnum
    expr.op == :+ && return lnum + rnum
    expr.op == :- && return lnum - rnum
    expr.op == :* && return lnum * rnum
    return missing
end

function _column_sum(table::MorpheusTable, column::Symbol)
    values = [_numeric(value) for value in table_column(table, column)]
    filter!(x -> x !== nothing, values)
    isempty(values) && return nothing
    return sum(values)
end

function inner_join(left::MorpheusTable, right::MorpheusTable)
    keys = [c for c in left.columns if c in right.columns]
    isempty(keys) && return _cross_join(left, right)
    right_extra = [c for c in right.columns if !(c in keys)]
    columns = vcat(left.columns, right_extra)
    rows = Vector{Any}[]
    for lidx in 1:length(left), ridx in 1:length(right)
        if all(_same_value(value_at(left, lidx, k), value_at(right, ridx, k)) for k in keys)
            push!(rows, Any[
                [value_at(left, lidx, c) for c in left.columns]...,
                [value_at(right, ridx, c) for c in right_extra]...,
            ])
        end
    end
    return MorpheusTable(columns, rows)
end

function arrange(table::MorpheusTable, sel::ColumnSelection)
    columns = _selected_columns(table, sel)
    order = sort(collect(1:length(table));
        by=row_idx -> Tuple(string(value_at(table, row_idx, c)) for c in columns))
    data = [Any[col[i] for i in order] for col in getfield(table, :data)]
    return _morpheus_table_from_columns(copy(table.columns), data, copy(table.groups))
end

function _cross_join(left::MorpheusTable, right::MorpheusTable)
    right_cols = [c in left.columns ? Symbol(string(c, "_right")) : c for c in right.columns]
    columns = vcat(left.columns, right_cols)
    rows = Vector{Any}[]
    for lidx in 1:length(left), ridx in 1:length(right)
        push!(rows, Any[
            [value_at(left, lidx, c) for c in left.columns]...,
            [value_at(right, ridx, c) for c in right.columns]...,
        ])
    end
    return MorpheusTable(columns, rows)
end
