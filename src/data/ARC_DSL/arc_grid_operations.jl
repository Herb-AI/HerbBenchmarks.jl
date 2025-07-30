"""
	Returns all indices of a `Grid`.
"""
function asindices(grid::Grid)
    items = SVector{length(grid)}(
        CartesianIndex(row, col) for row in axes(grid.mat, 1), col in axes(grid.mat, 2)
    )
    return Indices(items)
end

"""
	Returns indices of all grid cells of given `value` (color)
"""
function ofcolor(grid::Grid, value::Integer)
    Indices(findall(x -> x == value, grid.mat))
end

"""
    Rotates grid by 90 degrees clockwise
"""
function rot90(grid::Grid)
    Grid(rotr90(grid.mat, 1))
end

"""
    Rotates grid by 180 degrees
"""
function rot180(grid::Grid)
    Grid(Base.rot180(grid.mat))
end

"""
    Rotates grid by 270 degrees (left-rotate by 90 degrees)
"""
function rot270(grid::Grid)
    Grid(Base.rotl90(grid.mat))
end

"""
    Downscale grid by given factor.
"""
function downscale(grid::Grid, factor::Integer)
    Grid(grid.mat[1:factor:end, 1:factor:end])
end

"""
    Concatenate grid a and grid b horizontally.
"""
function hconcat(a::Grid, b::Grid)
    Grid(hcat(a.mat, b.mat))
end

"""
    Concatenate grid a and grid b horizontally.
"""
function vconcat(a::Grid, b::Grid)
    Grid(vcat(a.mat, b.mat))
end

"""
    Upscale grid horizontally.
"""
function hupscale(grid::Grid, factor::Integer)
    mat = reduce(vcat, [repeat(row, inner=(factor,))' for row in eachrow(grid.mat)])
    return Grid(mat)
end

"""
    Upscale grid vertically.
"""
function vupscale(grid::Grid, factor::Integer)
    mat = reduce(hcat, [repeat(col, inner=(factor,)) for col in eachcol(grid.mat)])
    return Grid(mat)
end


"""
    Split grid horizontally in
"""
function hsplit(grid::Grid, factor::Integer)
    # TODO
end

"""
    Cellwise matching. Returns grid with original values where `a[i, j] == b[i,j]`, otherwise `fallback`.
"""
function cellwise(a::Grid, b::Grid, fallback::Integer)
    nrows, ncols = size(a.mat)
    mat = SMatrix{nrows,ncols,UInt8}(a.mat[i, j] == b.mat[i, j] ? a.mat[i, j] : fallback for i in axes(a.mat, 1), j in axes(a.mat, 2))
    return Grid(mat)
end

"""
    Substituion of color `replacee` with new color `replacer`.
"""
function replace(grid::Grid, replacee::Integer, replacer::Integer)
    nrows, ncols = size(grid.mat)
    mat = SMatrix{nrows,ncols,UInt8}(grid.mat[i, j] == replacee ? replacer : grid.mat[i, j] for i in axes(grid.mat, 1), j in axes(grid.mat, 2))
    return Grid(mat)
end

"""
    Switches color for cells with value `a` and `b`. Other cells remain unchanged.
"""
function switch(grid::Grid, a::Integer, b::Integer)
    nrows, ncols = size(grid.mat)
    mat = SMatrix{nrows,ncols,UInt8}(grid.mat[i, j] == a ? b : grid.mat[i, j] == b ? a : grid.mat[i, j] for i in axes(grid.mat, 1), j in axes(grid.mat, 2))
    return Grid(mat)
end

"""
    Trims the borders of the grid, i.e., removes outermost rows and columns.
"""
function trim(grid::Grid)
    mat = grid.mat[2:end-1, 2:end-1]
    return Grid(mat)
end

"""
    Returns upper half of the grid. For odd number of rows, this excludes the middle row.
"""
function tophalf(grid::Grid)
    nrows = size(grid.mat, 1)
    return Grid(grid.mat[1:nrows÷2, :])
end

"""
    Returns lower half of the grid. For odd number of rows, this excludes the middle row. 
"""
function bottomhalf(grid::Grid)
    nrows = size(grid.mat, 1)
    return Grid(grid.mat[nrows-nrows÷2+1:end, :])
end

"""
    Returns the left half of the grid. For odd number of colums, this excludes the middle column.
"""
function lefthalf(grid::Grid)
    ncols = size(grid.mat, 2)
    return Grid(grid.mat[:, 1:ncols÷2])
end

"""
    Returns the right half of the grid. For odd number of colums, this excludes the middle column.
"""
function righthalf(grid::Grid)
    ncols = size(grid.mat, 2)
    return Grid(grid.mat[:, ncols-ncols÷2+1:end])
end

"""
    Removes frontiers from the grid, i.e., rows and columns where all cells have the same value
"""
function compress(grid::Grid)
    keep_rows = .![all(x -> x == r[1], r) for r in eachrow(grid.mat)]
    keep_cols = .![all(x -> x == c[1], c) for c in eachcol(grid.mat)]

    return Grid(grid.mat[keep_rows, keep_cols])
end
