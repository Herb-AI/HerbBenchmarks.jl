# The components of Neo's Morpheus DSL, on DataFrames. Neo (https://github.com/utopia-group/neo):
# src/org/genesys/language/MorpheusGrammar.java (grammar),
# src/org/genesys/interpreter/MorpheusInterpreter.java and
# src/org/genesys/interpreter/morpheus/*.java (semantics), on Neo's fork of krangl
# (https://github.com/fredfeng/krangl, src/main/kotlin/krangl/Reshape.kt and Columns.kt).
#
# Tables are `DataFrame`s. `group_by` returns a `GroupedDataFrame`, which `summarise`
# aggregates per group; every other component works on the ungrouped table. Columns are
# 1-based indices (Neo: 0-based); column lists are vectors of indices or `Not(...)` of one.
# New columns get generated names (see `_fresh`); outputs are compared with `same_table`,
# which ignores column names, as Neo does. generate.py mirrors this file.

const AnyTable = Union{AbstractDataFrame,GroupedDataFrame}

_ungroup(t::AbstractDataFrame) = t
_ungroup(t::GroupedDataFrame) = parent(t)

_name(df::AbstractDataFrame, i::Int) = names(df)[i]  # throws if out of range, as in Neo

_content(df::AbstractDataFrame) = (names(df), collect(eachcol(df)))
_content(g::GroupedDataFrame) = (_content(parent(g)), groupcols(g))

"""
    _fresh(n, op, input) -> Vector{String}

Names for `n` new columns made by operation `op` (a tuple of its name and arguments) on
table `input`. Neo takes them from a global counter (MORPHEUS1, MORPHEUS2, ...). Here they
are derived from the operation and its input, so evaluation is deterministic and two
columns get the same name only if the same computation made them (`inner_join` joins on
the columns its tables share).
"""
_fresh(n, op, input) =
    ["MORPHEUS_" * string(hash((op, i, _content(input))) % UInt32; base=16, pad=8) for i in 1:n]

"""
    select(table, cols)

Neo's `select`: the columns `cols` (a vector of indices, kept in that order, or `Not` of
one, keeping the other columns in table order).
"""
select(t::AnyTable, cols) = DataFrames.select(_ungroup(t), cols)

"""
    group_by(table, cols)

Neo's `group_by`: groups in order of first appearance. As in Neo, `cols` cannot be a `Not`.
"""
function group_by(t::AnyTable, cols)
    cols isa AbstractVector || throw(ArgumentError("group_by takes a list of columns, not a negated one"))
    return groupby(_ungroup(t), cols; sort=false)
end

"""
    inner_join(left, right)

Neo's `inner_join`: joins on all columns the two tables share, which come first in the
result (then the other columns of `left`, then those of `right`). Without shared columns,
every row of `left` is combined with every row of `right`.
"""
function inner_join(a::AnyTable, b::AnyTable)
    a, b = _ungroup(a), _ungroup(b)
    on = intersect(names(a), names(b))
    isempty(on) && return crossjoin(a, b)
    return DataFrames.select!(innerjoin(a, b; on=on, order=:left), on, :)
end

"""
    gather(table, cols)

Neo's `gather` (tidyr's): the columns `cols` become key-value pairs, in two new columns
after the other columns. The values stay numbers if all gathered columns are numeric, and
become strings otherwise.
"""
function gather(t::AnyTable, cols)
    df = _ungroup(t)
    gathered = names(df, cols)
    isempty(gathered) && throw(ArgumentError("gather needs at least one column"))
    key, value = _fresh(2, (:gather, gathered), df)
    long = stack(df, gathered; variable_name=key, value_name=value)
    eltype(long[!, value]) <: Real || (long[!, value] = string.(long[!, value]))
    return long
end

"""
    spread(table, key, value)

Neo's `spread` (tidyr's): one new column per distinct value of column `key` (in order of
first appearance), holding column `value`; one row per combination of the other columns.
Throws, as Neo fails, if a combination has no value or more than one for a key, or if a
new column name is already taken.
"""
function spread(t::AnyTable, key::Int, value::Int)
    df = _ungroup(t)
    k, v = _name(df, key), _name(df, value)
    k == v && throw(ArgumentError("spread: the key and value columns must differ"))
    ids = setdiff(names(df), [k, v])
    levels = unique(df[!, k])
    new = string.(levels)
    (allunique(new) && isdisjoint(new, ids)) || throw(ArgumentError("spread: the new column names clash"))
    groups = groupby(df, ids; sort=false)
    out = DataFrame([c => [g[1, c] for g in groups] for c in ids])
    for (x, name) in zip(levels, new)
        out[!, name] = [_spread_cell(g, k, v, x) for g in groups]
    end
    return out
end

function _spread_cell(g, k, v, x)
    rows = findall(isequal(x), g[!, k])
    length(rows) == 1 || throw(ArgumentError("spread: needs exactly one value per row and key"))
    return g[only(rows), v]
end

"""
    unite(table, col1, col2)

Neo's `unite` (tidyr's): replaces the two columns by one with their values joined by
"_", at the position of the first of them.
"""
function unite(t::AnyTable, col1::Int, col2::Int)
    df = _ungroup(t)
    a, b = _name(df, col1), _name(df, col2)
    a == b && throw(ArgumentError("unite: the two columns must differ"))
    (new,) = _fresh(1, (:unite, a, b), df)
    out = DataFrames.select(df, Not([a, b]))
    insertcols!(out, min(col1, col2), new => string.(df[!, a], "_", df[!, b]))
    return out
end

const SEPARATOR = r"\.|-|_|\|"  # Neo's src/org/genesys/interpreter/morpheus/Separate.java

"""
    separate(table, col)

Neo's `separate` (tidyr's): splits a column of strings at `.`, `-`, `_` or `|` into two
string columns, in its place. Throws unless every value splits into exactly two parts.
"""
function separate(t::AnyTable, col::Int)
    df = _ungroup(t)
    c = _name(df, col)
    eltype(df[!, c]) <: AbstractString || throw(ArgumentError("separate: needs a column of strings"))
    parts = [split(x, SEPARATOR) for x in df[!, c]]
    all(p -> length(p) == 2, parts) || throw(ArgumentError("separate: every value must split into two parts"))
    first_part, second_part = _fresh(2, (:separate, c), df)
    out = DataFrames.select(df, Not(c))
    insertcols!(out, col, first_part => String.(first.(parts)), second_part => String.(last.(parts)))
    return out
end

"""Neo's `mean` aggregator."""
mean(xs) = sum(xs) / length(xs)

# Neo's aggregators are mean, min, sum and count; here mean, minimum, sum and length.
# count (length) is the number of rows; the others need a numeric column and give a Float64.
function _aggregate(f, xs)
    f === length && return length(xs)
    eltype(xs) <: Real || throw(ArgumentError("summarise: needs a numeric column"))
    return float(f(xs))
end

"""
    summarise(table, aggregator, col)

Neo's `summarise` (dplyr's): aggregates column `col` per group of a `group_by` table (the
group columns, then the result), or over the whole table (one row).
"""
function summarise(t::AnyTable, f, col::Int)
    c = _name(_ungroup(t), col)
    (new,) = _fresh(1, (:summarise, nameof(f), c), t)
    t isa GroupedDataFrame && return combine(t, c => (xs -> _aggregate(f, xs)) => new)
    return DataFrame(new => [_aggregate(f, t[!, c])])
end

"""
    filter(table, op, col, value)

Neo's `filter` (dplyr's): the rows where `op(x, value)` holds for the value `x` in column
`col`. As in Neo: `>` and `<` need a numeric column and an integer constant, and `<` is
"not `>`" (it keeps values equal to the constant); `==` and `!=` compare as Java's
`equals`, so values of a different type are never equal.
"""
function filter(t::AnyTable, op, col::Int, value)
    df = _ungroup(t)
    xs = df[!, _name(df, col)]
    if op === (>) || op === (<)
        (eltype(xs) <: Real && value isa Int) ||
            throw(ArgumentError("filter: > and < need a numeric column and an integer constant"))
        keep = op === (>) ? xs .> value : .!(xs .> value)
    elseif op === (==) || op === (!=)
        equal = [typeof(x) === typeof(value) && x == value for x in xs]
        keep = op === (==) ? equal : .!equal
    else
        throw(ArgumentError("filter: unknown comparison $op"))
    end
    return df[keep, :]
end

"""
    mutate(table, op, col1, col2)

Neo's `mutate` (dplyr's): adds a column `op(x, y)` of the values in two numeric columns
(Neo's only operation is `/`).
"""
function mutate(t::AnyTable, op, col1::Int, col2::Int)
    df = _ungroup(t)
    a, b = _name(df, col1), _name(df, col2)
    (eltype(df[!, a]) <: Real && eltype(df[!, b]) <: Real) ||
        throw(ArgumentError("mutate: needs numeric columns"))
    (new,) = _fresh(1, (:mutate, nameof(op), a, b), df)
    out = copy(df)
    out[!, new] = op.(df[!, a], df[!, b])
    return out
end

const NUMBER = r"^-?\d+(\.\d+)?$"

"""
    same_table(a, b) -> Bool

Neo's check that a program's output matches the expected table (`hasSameContents` in
Neo's fork of krangl, src/main/kotlin/krangl/Reshape.kt): the tables have the same number of rows and columns, and every row
of each, taken as a set of strings, is covered by some row of the other. Strings that look
like numbers are equal if they differ by less than 1e-5. Column names, column order and
row order are ignored (a row is a set, so this is looser than equality up to them).
Programs name new columns themselves, so compare outputs with this, not `==`.
"""
function same_table(a::AnyTable, b::AnyTable)
    a, b = _ungroup(a), _ungroup(b)
    size(a) == size(b) || return false
    ra, rb = _row_sets(a), _row_sets(b)
    return _covered(ra, rb) && _covered(rb, ra)
end
same_table(a, b) = false

_row_sets(df) = [Set(string.(values(row))) for row in eachrow(df)]
_covered(ra, rb) = all(r -> any(s -> all(x -> any(y -> _approx_eq(x, y), s), r), rb), ra)

function _approx_eq(x::AbstractString, y::AbstractString)
    if occursin(NUMBER, x) && occursin(NUMBER, y)
        return abs(parse(Float64, x) - parse(Float64, y)) < 1e-5
    end
    return x == y
end
