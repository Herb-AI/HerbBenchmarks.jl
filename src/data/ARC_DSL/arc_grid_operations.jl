"""
	Returns all indices of a `Grid`.
"""
function asindices(grid)
    return CartesianIndices(grid) # TODO: only collect if necessary. iterable might be enough
end

"""
	Returns indices of all grid cells of given `value` (color)
"""
function ofcolor(grid, value)
    return findall(x -> x == value, grid)
end

"""
    Rotates grid by 90 degrees clockwise
"""
function rot90(grid)
    return rotr90(grid, 1)
end

"""
    Rotates grid by 180 degrees
"""
function rot180(grid)
    return Base.rot180(grid)
end

"""
    Rotates grid by 270 degrees (left-rotate by 90 degrees)
"""
function rot270(grid)
    return Base.rotl90(grid)
end

"""
    Downscale grid by given factor.
"""
function downscale(grid, factor)
    grid[1:factor:end, 1:factor:end]
end

"""
    Concatenate grid a and grid b horizontally.
"""
function hconcat(a, b)
    hcat(a, b)
end

"""
    Concatenate grid a and grid b horizontally.
"""
function vconcat(a, b)
    vcat(a, b)
end

"""
    Upscale grid horizontally.
"""
function hupscale(grid, factor)
    return reduce(vcat, [repeat(row, inner=(factor,))' for row in eachrow(grid)])

end

"""
    Upscale grid vertically.
"""
function vupscale(grid, factor)
    return reduce(hcat, [repeat(col, inner=(factor,)) for col in eachcol(grid)])
end


"""
    Split grid horizontally in
"""
# function hsplit(grid::Grid, factor::Integer)
#     # TODO
# end

"""
    Cellwise matching of grids `a` and `b`. Returns grid with original values where `a[i, j] == b[i,j]`, otherwise `fallback`.
"""
function cellwise(a, b, fallback)
    nrows, ncols = size(a)
    # TODO: return Matrix of type a ?
    return [a[i, j] == b[i, j] ? a[i, j] : fallback for i in axes(a, 1), j in axes(a, 2)]
end

"""
    Substituion of color value `replacee` with new color `replacer`.
"""
function replace(grid, replacee, replacer)
    nrows, ncols = size(grid)
    # TODO: Does it have to be SMatrix?
    mat = SMatrix{nrows,ncols,UInt8}(grid[i, j] == replacee ? replacer : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2))
    return mat
end

"""
    Switches color for cells with value `a` and `b`. Other cells remain unchanged.
"""
function switch(grid, a, b)
    nrows, ncols = size(grid)
    mat = SMatrix{nrows,ncols,UInt8}(grid[i, j] == a ? b : grid[i, j] == b ? a : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2))
    return mat
end

"""
    Trims the borders of the grid, i.e., removes outermost rows and columns.
"""
function trim(grid)
    return grid[2:end-1, 2:end-1]
end

"""
    Returns upper half of the grid. For odd number of rows, this excludes the middle row.
"""
function tophalf(grid)
    nrows = size(grid, 1)
    return grid[1:nrows÷2, :]
end

"""
    Returns lower half of the grid. For odd number of rows, this excludes the middle row. 
"""
function bottomhalf(grid)
    nrows = size(grid, 1)
    return grid[nrows-nrows÷2+1:end, :]
end

"""
    Returns the left half of the grid. For odd number of colums, this excludes the middle column.
"""
function lefthalf(grid)
    ncols = size(grid, 2)
    return grid[:, 1:ncols÷2]
end

"""
    Returns the right half of the grid. For odd number of colums, this excludes the middle column.
"""
function righthalf(grid)
    ncols = size(grid, 2)
    return grid[:, ncols-ncols÷2+1:end]
end

"""
    Removes frontiers from the grid, i.e., rows and columns where all cells have the same value
"""
function compress(grid)
    keep_rows = .![all(x -> x == r[1], r) for r in eachrow(grid)]
    keep_cols = .![all(x -> x == c[1], c) for c in eachcol(grid)]

    return grid[keep_rows, keep_cols]
end

"""
    Constructs a grid of given `dimensions` and fills it with `value`.
"""
function canvas(value::Integer, dimensions::CartesianIndex)
    return fill(value, dimensions[1], dimensions[2])
end

"""
    Get color of `grid` at given location `loc`. 
"""
function index(grid, loc)
    return grid[loc]
end

"""
    Crop grid from `start` point to given `dims`.
"""
function crop(grid, start, dims)
    return grid[start[1]:start[1]+dims[1]-1, start[2]:start[2]+dims[2]-1]
end

"""
    Returns `CartesianIndex` of upper left corner.
"""
function ulcorner(indices) # Vector{CartesianIndex}
    min_row = typemax(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        min_row = min(min_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(min_row, min_col)
end
# Patch = Union{Object, Indices}
# Object = Vector{Tuple{Integer, CartesianIndex}}
function ulcorner(cells::Vector{<:Tuple{<:Integer,CartesianIndex}}) # TODO: make type more specific?
    return ulcorner(toindices(cells))
end

"""
    Returns `CartesianIndex` of upper right corner.
"""
function urcorner(indices::Vector{CartesianIndex{2}})
    min_row = typemax(Int)
    max_col = typemin(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        min_row = min(min_row, row)
        max_col = max(max_col, col)
    end
    return CartesianIndex(min_row, max_col)
end

urcorner(cells::Vector{<:Tuple{<:Integer,CartesianIndex}}) = urcorner(toindices(cells))

"""
    Returns `CartesianIndex` of lower left corner.
"""
function llcorner(indices::Vector{CartesianIndex{2}})
    max_row = typemin(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(max_row, min_col)
end

llcorner(cells::Vector{<:Tuple{<:Integer,CartesianIndex}}) = llcorner(toindices(cells))

"""
    Returns `CartesianIndex` of lower right corner.
"""
function lrcorner(indices::Vector{CartesianIndex{2}})
    max_row = typemin(Int)
    max_col = typemin(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        max_col = max(max_col, col)
    end
    return CartesianIndex(max_row, max_col)
end

lrcorner(cells::Vector{<:Tuple{<:Integer,CartesianIndex}}) = lrcorner(toindices(cells))

"""
    Returns indices
"""
function toindices(cells::Vector{<:Tuple{<:Integer,CartesianIndex}})
    return [i[2] for i in cells]
end


"""
        Mirrors along vertical.
"""
function vmirror(grid)
    return reverse(grid, dims=2)
end

function vmirror(indices::AbstractVector)
    min_col, max_col = extrema(idx[2] for idx in indices)
    d = min_col + max_col
    # result = Vector{CartesianIndex{2}}(undef, length(indices))
    # @inbounds for i in eachindex(indices)
    #     idx = indices[i]
    #     result[i] = CartesianIndex(idx[1], d - idx[2])
    # end
    # return result
    return [CartesianIndex(idx[1], d - idx[2]) for idx in indices]
end

function vmirror(object::Vector{<:Tuple{<:Integer,CartesianIndex}})
    min_col, max_col = extrema(idx[2] for (_, idx) in object)
    d = min_col + max_col
    return [(val, CartesianIndex(idx[1], d - idx[2])) for (val, idx) in object]
end

"""
        Mirrors along horizontal.
"""
function hmirror(grid)
    return reverse(grid, dims=1)
end

function hmirror(indices::AbstractVector)
    min_row, max_row = extrema(idx[1] for idx in indices)
    d = min_row + max_row
    return [CartesianIndex(d - idx[1], idx[2]) for idx in indices]
end

function hmirror(object::Vector{<:Tuple{<:Integer,CartesianIndex}})
    min_row, max_row = extrema(idx[1] for (_, idx) in object)
    d = min_row + max_row
    return [(val, CartesianIndex(d - idx[1], idx[2])) for (val, idx) in object]
end

"""
        Mirrors along diagonal.
"""
function dmirror(grid)
    return transpose(grid)
end

function dmirror(indices::AbstractVector)
    corner = ulcorner(indices)
    a = corner[1]
    b = corner[2]
    return [CartesianIndex(idx[2] - b + a, idx[1] - a + b) for idx in indices]
end

function dmirror(object::Vector{<:Tuple{<:Integer,CartesianIndex}})
    corner = ulcorner(object)
    a = corner[1]
    b = corner[2]
    return [(val, CartesianIndex(idx[2] - b + a, idx[1] - a + b)) for (val, idx) in object]
end

# Piece = Union[Grid, Patch]
# Patch = Union{Object, Indices}
# Object = Vector{Tuple{Integer, CartesianIndex}}