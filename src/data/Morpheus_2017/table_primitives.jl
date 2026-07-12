"""
    MorpheusTable

Small table value used by the Morpheus benchmarks.

`df` stores the table data. `raw` preserves the original rendered artifact table.
`groups` stores `group_by` state for later `summarise` calls. `semantics` carries
the input universe and abstract group cardinality used by the Morpheus specifications.
"""
struct MorpheusSemantics
    input_columns::Set{String}
    input_values::Set{Any}
    group_count::Union{Int,Nothing}
end

struct MorpheusTable
    df::DataFrame
    groups::Vector{Symbol}
    raw::String
    semantics::MorpheusSemantics

    MorpheusTable(df::DataFrame, groups::Vector{Symbol}, raw::String, semantics::MorpheusSemantics) =
        new(df, groups, raw, semantics)

    MorpheusTable(columns::Vector{Symbol}, rows::AbstractVector; groups::Vector{Symbol}=Symbol[],
        raw::AbstractString="", semantics::Union{MorpheusSemantics,Nothing}=nothing) =
        _morpheus_table_from_rows(columns, rows, groups, String(raw); semantics=semantics)

    MorpheusTable(df::DataFrame; groups::Vector{Symbol}=Symbol[], raw::AbstractString="",
        semantics::Union{MorpheusSemantics,Nothing}=nothing) =
        _morpheus_table_from_df(df, groups, String(raw); semantics=semantics)
end

function MorpheusTable(raw::AbstractString)
    columns, rows = parse_morpheus_table(raw)
    return MorpheusTable(columns, rows; raw=raw)
end

function _morpheus_dataframe(columns::Vector{Symbol}, data::Vector{Vector{Any}})
    if isempty(columns)
        return DataFrame()
    end
    return DataFrame([columns[i] => copy(data[i]) for i in eachindex(columns)])
end

function _morpheus_table_from_df(df::DataFrame, groups::Vector{Symbol}=Symbol[], raw::String="";
    semantics::Union{MorpheusSemantics,Nothing}=nothing)

    return _morpheus_table_from_df_nocopy(copy(df), groups, raw; semantics=semantics)
end

function _morpheus_table_from_df_nocopy(df::DataFrame, groups::Vector{Symbol}=Symbol[], raw::String="";
    semantics::Union{MorpheusSemantics,Nothing}=nothing)
    columns = morpheus_columns(df)
    table_semantics = semantics
    if isnothing(semantics)
        table_semantics = MorpheusSemantics(_morpheus_column_set(columns),
            _morpheus_value_set(columns, morpheus_data(df)), 1)
    end
    return MorpheusTable(df, [c for c in groups if c in columns], raw, table_semantics)
end

function _morpheus_table_from_columns(columns::Vector{Symbol}, data::Vector{Vector{Any}},
    groups::Vector{Symbol}=Symbol[], raw::String=""; semantics::Union{MorpheusSemantics,Nothing}=nothing)

    if length(unique(columns)) != length(columns)
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    end
    if length(columns) != length(data)
        throw(ArgumentError("Morpheus table has $(length(columns)) columns and $(length(data)) data vectors"))
    end
    nrows = isempty(data) ? 0 : length(first(data))
    if any(length(col) != nrows for col in data)
        throw(ArgumentError("Morpheus column vectors have inconsistent lengths"))
    end
    return _morpheus_table_from_df_nocopy(_morpheus_dataframe(columns, data), groups, raw; semantics=semantics)
end

function _morpheus_table_from_rows(columns::Vector{Symbol}, rows::AbstractVector, groups::Vector{Symbol}, raw::String;
    semantics::Union{MorpheusSemantics,Nothing}=nothing)

    if length(unique(columns)) != length(columns)
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    end
    for row in rows
        if !(row isa AbstractVector)
            throw(ArgumentError("Morpheus row is not a vector: $row"))
        end
        if length(row) != length(columns)
            throw(ArgumentError("Morpheus row has $(length(row)) values for $(length(columns)) columns"))
        end
    end
    data = [Any[row[i] for row in rows] for i in eachindex(columns)]
    return _morpheus_table_from_columns(columns, data, groups, raw; semantics=semantics)
end

Base.length(table::MorpheusTable) = morpheus_nrows(table)
Base.show(io::IO, table::MorpheusTable) =
    print(io, isempty(morpheus_raw(table)) ? table_to_string(table) : morpheus_raw(table))

function Base.:(==)(a::MorpheusTable, b::MorpheusTable)
    if morpheus_columns(a) != morpheus_columns(b) || length(a) != length(b)
        return false
    end
    return all(_row_equal(ar, br) for (ar, br) in zip(table_rows(a), table_rows(b)))
end

_row_equal(a, b) = length(a) == length(b) && all(_cell_equal(x, y) for (x, y) in zip(a, b))
_cell_equal(a::Number, b::Number) = isapprox(float(a), float(b); atol=1e-6, rtol=1e-6)
_cell_equal(a::Symbol, b::AbstractString) = String(a) == b
_cell_equal(a::AbstractString, b::Symbol) = a == String(b)
_cell_equal(a, b) = isequal(a, b)

morpheus_columns(df::DataFrame) = Symbol.(names(df))
morpheus_columns(table::MorpheusTable) = morpheus_columns(table.df)

function morpheus_data(df::DataFrame)
    columns = morpheus_columns(df)
    return [Any[value for value in df[!, column]] for column in columns]
end
morpheus_data(table::MorpheusTable) = morpheus_data(table.df)

morpheus_colindex(table::MorpheusTable) = Dict(c => i for (i, c) in pairs(morpheus_columns(table)))
morpheus_groups(table::MorpheusTable) = table.groups
morpheus_raw(table::MorpheusTable) = table.raw
morpheus_semantics(table::MorpheusTable) = table.semantics

_morpheus_semantic_atom(value::Symbol) = String(value)
_morpheus_semantic_atom(value) = value

_morpheus_column_set(columns::Vector{Symbol}) = Set(String.(columns))

function _morpheus_value_set(columns::Vector{Symbol}, data::Vector{Vector{Any}})
    values = Set{Any}(String.(columns))
    for column in data, value in column
        push!(values, _morpheus_semantic_atom(value))
    end
    return values
end

function _morpheus_with_input_origin(table::MorpheusTable, input::MorpheusTable; group_count::Union{Int,Nothing})
    semantics = MorpheusSemantics(
        _morpheus_column_set(morpheus_columns(input)),
        _morpheus_value_set(morpheus_columns(input), morpheus_data(input)),
        group_count,
    )
    return MorpheusTable(table.df; groups=copy(morpheus_groups(table)), raw=morpheus_raw(table), semantics=semantics)
end

morpheus_row_count(table::MorpheusTable)::Int = length(table)
morpheus_column_count(table::MorpheusTable)::Int = length(morpheus_columns(table))

function morpheus_group_count(table::MorpheusTable)::Int
    count = table.semantics.group_count
    isnothing(count) && throw(ArgumentError("Morpheus group cardinality is unknown"))
    return count
end

function morpheus_new_column_count(table::MorpheusTable)::Int
    return length(setdiff(_morpheus_column_set(morpheus_columns(table)), table.semantics.input_columns))
end

function morpheus_new_value_count(table::MorpheusTable)::Int
    values = _morpheus_value_set(morpheus_columns(table), morpheus_data(table))
    return length(setdiff(values, table.semantics.input_values))
end

function parse_morpheus_table(raw::AbstractString)
    lines = split(strip(replace(String(raw), "\r\n" => "\n")), '\n')
    filter!(line -> !isempty(strip(line)), lines)
    filter!(line -> !startswith(strip(line), "---"), lines)
    filter!(line -> !startswith(strip(line), "Source:"), lines)
    filter!(line -> !startswith(strip(line), "Groups:"), lines)
    filter!(line -> !startswith(strip(line), "# A tibble"), lines)
    filter!(line -> !startswith(strip(line), "# ..."), lines)
    filter!(line -> !startswith(strip(line), "<"), lines)
    filter!(line -> !occursin(r"^\s*(?:<[^>]+>\s*)+$", line), lines)
    if isempty(lines)
        throw(ArgumentError("Morpheus table is empty"))
    end
    columns = Symbol[]
    rows_by_index = Dict{Int,Vector{Any}}()
    row_order = Int[]
    i = firstindex(lines)
    while i <= lastindex(lines)
        header_lines = String[]
        while i <= lastindex(lines) && !_is_printed_row(lines[i])
            push!(header_lines, strip(lines[i]))
            i += 1
        end
        isempty(header_lines) && break
        chunk_columns = Symbol.(split(join(header_lines, " ")))
        append!(columns, chunk_columns)
        while i <= lastindex(lines) && _is_printed_row(lines[i])
            row_index, values = _parse_indexed_row(lines[i], chunk_columns)
            if !haskey(rows_by_index, row_index)
                rows_by_index[row_index] = Any[]
                push!(row_order, row_index)
            end
            append!(rows_by_index[row_index], values)
            i += 1
        end
    end
    if isempty(columns)
        throw(ArgumentError("Morpheus table has no columns"))
    end
    return columns, [rows_by_index[idx] for idx in row_order]
end

_is_printed_row(line::AbstractString) = occursin(r"^\s*\d+\s+", line)

function _parse_indexed_row(line::AbstractString, columns::Vector{Symbol})
    m = match(r"^\s*(\d+)\s+(.*)$", line)
    if m === nothing
        throw(ArgumentError("Expected a printed row, got $line"))
    end
    return parse(Int, m.captures[1]), _parse_row(m.captures[2], columns)
end

function _parse_row(line::AbstractString, columns::Vector{Symbol})
    ncols = length(columns)
    parts = split(strip(line), r"\s{2,}"; keepempty=false)
    if length(parts) < ncols
        candidates = _expanded_rows(String.(parts), ncols)
        if !isempty(candidates)
            parts = first(sort(candidates; by=candidate -> -_row_parse_score(candidate, columns)))
        end
    end
    if length(parts) > ncols
        parts = vcat(parts[1:(ncols-1)], [join(parts[ncols:end], " ")])
    elseif length(parts) < ncols
        parts = vcat(parts, fill("", ncols - length(parts)))
    end
    return Any[_parse_cell(part) for part in parts]
end

function _expanded_rows(parts::Vector{String}, target::Integer)
    rows = Vector{Vector{String}}()
    _expand_rows!(rows, String[], parts, firstindex(parts), target)
    return rows
end

function _expand_rows!(rows::Vector{Vector{String}}, acc::Vector{String},
    parts::Vector{String}, idx::Integer, remaining::Integer)
    if idx > lastindex(parts)
        if remaining == 0
            push!(rows, copy(acc))
        end
        return
    end
    min_after = length(parts) - idx
    tokens = split(parts[idx])
    max_groups = min(length(tokens), remaining - min_after)
    max_groups < 1 && return
    for n_groups in 1:max_groups
        for partition in _token_partitions(String.(tokens), n_groups)
            append!(acc, partition)
            _expand_rows!(rows, acc, parts, idx + 1, remaining - n_groups)
            resize!(acc, length(acc) - n_groups)
        end
    end
end

function _token_partitions(tokens::Vector{String}, n_groups::Integer)
    n_groups == 1 && return [[join(tokens, " ")]]
    partitions = Vector{Vector{String}}()
    max_first = length(tokens) - n_groups + 1
    for cut in 1:max_first
        head = join(tokens[1:cut], " ")
        for tail in _token_partitions(tokens[(cut+1):end], n_groups - 1)
            push!(partitions, vcat([head], tail))
        end
    end
    return partitions
end

function _row_parse_score(parts::Vector{String}, columns::Vector{Symbol})
    score = 0
    for (part, column) in zip(parts, columns)
        name = lowercase(string(column))
        parsed = _parse_cell(part)
        if parsed isa Number
            score += 3
            _numeric_column_name(name) && (score += 4)
        elseif occursin(r"^\d{4}-\d{2}-\d{2}$", strip(part))
            score += occursin("date", name) ? 8 : 2
        elseif occursin(r"^[+-]?\d+(?:\.\d+)?\s+\S", strip(part))
            score -= 8
        end
        if occursin("|", part)
            score += occursin("topic", name) ? 5 : 1
            score -= 2 * length(collect(eachmatch(r"\s+", part)))
        elseif occursin(r"\s", part)
            _name_column_name(name) && (score += 2)
            _compact_column_name(name) && (score -= 2)
        end
    end
    return score
end

_numeric_column_name(name::AbstractString) =
    occursin(r"(?:day|time|rate|count|num|score|value|amount|total|sum|mean|avg|freq|ratio|percent|size|factor|order|occ|read|salary|rating|dist|hour|gear|cyl|mpg|carb|year|yr|^x\d*$|^y\d*$|^z\d*$|^n$)", name)
_name_column_name(name::AbstractString) =
    occursin(r"(?:name|title|school|topic|expr|address)", name)
_compact_column_name(name::AbstractString) =
    occursin(r"(?:value|topic|type|key|var|code|id|year|yr|group|factor)", name)

function _parse_cell(part::AbstractString)
    text = strip(part)
    isempty(text) && return ""
    text in ("NA", "NaN") && return missing
    if occursin(r"^[+-]?\d+$", text)
        return parse(Int, text)
    elseif occursin(r"^[+-]?(?:\d+\.\d*|\.\d+)(?:[eE][+-]?\d+)?$", text) ||
           occursin(r"^[+-]?\d+[eE][+-]?\d+$", text)
        return parse(Float64, text)
    else
        return text
    end
end

function table_to_string(table::MorpheusTable)
    lines = [join(string.(morpheus_columns(table)), '\t')]
    for row in table_rows(table)
        push!(lines, join(string.(row), '\t'))
    end
    return join(lines, '\n')
end

morpheus_nrows(table::MorpheusTable) = nrow(table.df)

function table_rows(table::MorpheusTable)
    columns = morpheus_columns(table)
    return [Any[table.df[row, column] for column in columns] for row in 1:morpheus_nrows(table)]
end

function table_column(table::MorpheusTable, column::Symbol)
    try
        return table.df[!, column]
    catch err
        if err isa ArgumentError
            throw(ArgumentError("Unknown Morpheus column $column in $(morpheus_columns(table))"))
        end
        rethrow()
    end
end

function value_at(table::MorpheusTable, row::Integer, column::Symbol)
    try
        return table.df[row, column]
    catch err
        if err isa ArgumentError
            throw(ArgumentError("Unknown Morpheus column $column in $(morpheus_columns(table))"))
        end
        rethrow()
    end
end

struct ColumnSelection
    columns::Vector{Symbol}
    exclude::Bool
end

struct Aggregation
    op::Symbol
    column::Union{Symbol,Nothing}
end

struct Predicate
    op::Symbol
    column::Symbol
    value::Any
end

struct ValueExpression
    op::Symbol
    left::Symbol
    right::Union{Symbol,Nothing}
end

col(x::Symbol) = x
newcol(x::Symbol) = x
lit(x) = x
cols(c::Symbol) = ColumnSelection([c], false)
cols2(c1::Symbol, c2::Symbol) = ColumnSelection([c1, c2], false)
cols3(c1::Symbol, c2::Symbol, c3::Symbol) = ColumnSelection([c1, c2, c3], false)
not_cols(c::Symbol) = ColumnSelection([c], true)
not_cols2(c1::Symbol, c2::Symbol) = ColumnSelection([c1, c2], true)
not_cols3(c1::Symbol, c2::Symbol, c3::Symbol) = ColumnSelection([c1, c2, c3], true)
function union_cols(a::ColumnSelection, b::ColumnSelection)
    a.exclude == b.exclude ||
        throw(ArgumentError("Cannot combine include and exclude column selections"))
    return ColumnSelection(unique(vcat(a.columns, b.columns)), a.exclude)
end

mean_agg(c::Symbol) = Aggregation(:mean, c)
sum_agg(c::Symbol) = Aggregation(:sum, c)
count_agg() = Aggregation(:count, nothing)

positive(c::Symbol) = Predicate(:>, c, 0)
negative(c::Symbol) = Predicate(:<, c, 0)
eq_value(c::Symbol, v) = Predicate(:(==), c, v)
neq_value(c::Symbol, v) = Predicate(:(!=), c, v)
lt_value(c::Symbol, v) = Predicate(:<, c, v)
gt_value(c::Symbol, v) = Predicate(:>, c, v)

copy_expr(c::Symbol) = ValueExpression(:copy, c, nothing)
div_expr(c1::Symbol, c2::Symbol) = ValueExpression(:/, c1, c2)
div_sum_expr(c::Symbol) = ValueExpression(:div_sum, c, nothing)
add_expr(c1::Symbol, c2::Symbol) = ValueExpression(:+, c1, c2)
sub_expr(c1::Symbol, c2::Symbol) = ValueExpression(:-, c1, c2)
mul_expr(c1::Symbol, c2::Symbol) = ValueExpression(:*, c1, c2)
