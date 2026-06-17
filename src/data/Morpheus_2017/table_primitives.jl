"""
    MorpheusTable

Small table value used by the Morpheus benchmarks.

`raw` preserves the original rendered artifact table. `columns` names the
column-major `data` vectors used by the DSL operations. `groups` stores
`group_by` state for later `summarise` calls.
"""
struct MorpheusTable
    columns::Vector{Symbol}
    data::Vector{Vector{Any}}
    colindex::Dict{Symbol,Int}
    groups::Vector{Symbol}
    raw::String

    function MorpheusTable(columns::Vector{Symbol}, data::Vector{Vector{Any}},
        colindex::Dict{Symbol,Int}, groups::Vector{Symbol}, raw::String)
        length(columns) == length(data) ||
            throw(ArgumentError("Morpheus table has $(length(columns)) columns and $(length(data)) data vectors"))
        return new(columns, data, colindex, groups, raw)
    end
end

MorpheusTable(columns::Vector{Symbol}, rows::Vector{Vector{Any}};
    groups::Vector{Symbol}=Symbol[], raw::AbstractString="") =
    _morpheus_table_from_rows(columns, rows, groups, String(raw))

function _morpheus_table_from_columns(columns::Vector{Symbol}, data::Vector{Vector{Any}},
    groups::Vector{Symbol}=Symbol[], raw::String="")
    length(unique(columns)) == length(columns) ||
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    nrows = isempty(data) ? 0 : length(first(data))
    all(length(col) == nrows for col in data) ||
        throw(ArgumentError("Morpheus column vectors have inconsistent lengths"))
    return MorpheusTable(copy(columns), copy.(data),
        Dict(c => i for (i, c) in pairs(columns)),
        [c for c in groups if c in columns],
        raw)
end

function _morpheus_table_from_rows(columns::Vector{Symbol}, rows::Vector{Vector{Any}},
    groups::Vector{Symbol}, raw::String)
    length(unique(columns)) == length(columns) ||
        throw(ArgumentError("Duplicate Morpheus columns: $columns"))
    for row in rows
        length(row) == length(columns) ||
            throw(ArgumentError("Morpheus row has $(length(row)) values for $(length(columns)) columns"))
    end
    data = [Any[row[i] for row in rows] for i in eachindex(columns)]
    return _morpheus_table_from_columns(columns, data, groups, raw)
end

function MorpheusTable(raw::AbstractString)
    columns, rows = parse_morpheus_table(raw)
    return MorpheusTable(columns, rows; raw=raw)
end

function Base.getproperty(table::MorpheusTable, name::Symbol)
    name == :rows && return table_rows(table)
    return getfield(table, name)
end

Base.propertynames(table::MorpheusTable, private::Bool=false) =
    private ? (:columns, :data, :colindex, :groups, :raw, :rows) :
    (:columns, :data, :groups, :raw, :rows)

Base.length(table::MorpheusTable) = morpheus_nrows(table)
Base.show(io::IO, table::MorpheusTable) = print(io, isempty(table.raw) ? table_to_string(table) : table.raw)

function Base.:(==)(a::MorpheusTable, b::MorpheusTable)
    a.columns == b.columns || return false
    length(a) == length(b) || return false
    return all(_row_equal(ar, br) for (ar, br) in zip(table_rows(a), table_rows(b)))
end

_row_equal(a, b) = length(a) == length(b) && all(_cell_equal(x, y) for (x, y) in zip(a, b))
_cell_equal(a::Number, b::Number) = isapprox(float(a), float(b); atol=1e-6, rtol=1e-6)
_cell_equal(a, b) = string(a) == string(b)

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
    isempty(lines) && return Symbol[], Vector{Any}[]

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
    isempty(columns) && return Symbol.(split(strip(first(lines)))), Vector{Any}[]
    return columns, [rows_by_index[idx] for idx in row_order]
end

_is_printed_row(line::AbstractString) = occursin(r"^\s*\d+\s+", line)

function _parse_indexed_row(line::AbstractString, columns::Vector{Symbol})
    m = match(r"^\s*(\d+)\s+(.*)$", line)
    m === nothing && throw(ArgumentError("Expected a printed row, got $line"))
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
    if length(parts) != ncols
        parts = split(strip(line))
    end
    if length(parts) > ncols
        parts = vcat(parts[1:ncols-1], [join(parts[ncols:end], " ")])
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
        remaining == 0 && push!(rows, copy(acc))
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
        for tail in _token_partitions(tokens[cut+1:end], n_groups - 1)
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
    lines = [join(string.(table.columns), '\t')]
    for row in table_rows(table)
        push!(lines, join(string.(row), '\t'))
    end
    return join(lines, '\n')
end

morpheus_nrows(table::MorpheusTable) =
    isempty(getfield(table, :data)) ? 0 : length(first(getfield(table, :data)))

function table_rows(table::MorpheusTable)
    data = getfield(table, :data)
    return [Any[col[i] for col in data] for i in 1:morpheus_nrows(table)]
end

function table_column(table::MorpheusTable, column::Symbol)
    idx = get(getfield(table, :colindex), column, nothing)
    idx === nothing && throw(ArgumentError("Unknown Morpheus column $column in $(table.columns)"))
    return getfield(table, :data)[idx]
end

function value_at(table::MorpheusTable, row::Integer, column::Symbol)
    return table_column(table, column)[row]
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
