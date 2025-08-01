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
function canvas(value, dimensions) # TODO: CartesianIndex a good choice? Wait for `as_tuple`
    mat = fill(value, SMatrix{dimensions[1],dimensions[2]})
    return mat
end

"""
    Get color of `grid` at given location `loc`. 
"""
function index(grid, loc)
    return get(grid, loc, nothing)
end

"""
    Crop grid from `start` point to given `dims`.
"""
function crop(grid, start, dims)
    return grid[start[1]:start[1]+dims[1]-1, start[2]:start[2]+dims[2]-1]
end
# Cell = Tuple(color, (x, y))
# Object = Set(cells)
# Patch = Union(Object, Indices)
# Piece = Union(Grid, Patch) => Grid, Object, Indices
"""
    Mirrors along vertical.
# """
# function vmirror(cell:Tuple{Integer,CartesianIndex})
#     return Tuple(cell[1], CartesianIndex(cell[])) # only x value of index changes
# end

# def vmirror(
#     piece: Piece
# ) -> Piece:
#     """ mirroring along vertical """
#     if isinstance(piece, tuple):
#         return tuple(row[::-1] for row in piece)
#     d = ulcorner(piece)[1] + lrcorner(piece)[1]
#     if isinstance(next(iter(piece))[1], tuple):
#         return frozenset((v, (i, d - j)) for v, (i, j) in piece)
#     return frozenset((i, d - j) for i, j in piece)
