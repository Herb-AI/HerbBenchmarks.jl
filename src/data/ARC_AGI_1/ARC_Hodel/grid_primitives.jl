"""Returns all indices of a grid"""
asindices(grid) = CartesianIndices(grid)

"""Returns indices of all grid cells of given value (color)"""
ofcolor(grid, value) = findall(x -> x == value, grid)

"""Rotates grid by 90 degrees clockwise"""
rot90deg(grid) = rotr90(grid, 1)

"""Rotates grid by 180 degrees"""
rot180deg(grid) = Base.rot180(grid)

"""Rotates grid by 270 degrees (left-rotate by 90 degrees)"""
rot270deg(grid) = Base.rotl90(grid)

"""Downscale grid by given factor."""
downscale(grid, factor) = grid[1:factor:end, 1:factor:end]

"""Concatenate grid a and grid b horizontally."""
hconcat(a, b) = hcat(a, b)

"""Concatenate grid a and grid b horizontally."""
vconcat(a, b) = vcat(a, b)

"""Upscale grid horizontally."""
hupscale(grid, factor) = reduce(vcat, [repeat(row, inner=(factor,))' for row in eachrow(grid)])


"""Upscale grid vertically."""
vupscale(grid, factor) = reduce(hcat, [repeat(col, inner=(factor,)) for col in eachcol(grid)])


"""Split grid along horizontal into n parts."""
function hsplit(grid::Matrix, n::Integer)
    _, w_total = size(grid)
    w = w_total ÷ n
    offset = w_total % n != 0 ? 1 : 0
    return [grid[:, (w*i+i*offset+1):(w*(i+1)+i*offset)] for i in 0:n-1]
end

"""Split grid along vertica into n parts"""
function vsplit(grid::Matrix, n::Integer)
    h_total, _ = size(grid)
    h = h_total ÷ n
    offset = h_total % n != 0 ? 1 : 0
    return [grid[(h*i+i*offset+1):(h*(i+1)+i*offset), :] for i in 0:n-1]
end

"""Cellwise matching of grids a and b. Returns grid with original values where `a[i, j] == b[i,j]`, otherwise `fallback`."""
cellwise(a, b, fallback) = [a[i, j] == b[i, j] ? a[i, j] : fallback for i in axes(a, 1), j in axes(a, 2)]


"""Substituion of color value replacee with new color replacer."""
replace_color(grid, replacee, replacer) = [grid[i, j] == replacee ? replacer : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)]
# replace in original Python implementation => renamed due to name clash


"""Switches color for cells with value a and b. Other cells remain unchanged."""
switch(grid, a, b) = [grid[i, j] == a ? b : grid[i, j] == b ? a : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)]


"""Trims the borders of the grid, i.e., removes outermost rows and columns"""
trim(grid) = grid[2:end-1, 2:end-1]

"""Returns upper half of the grid. For odd number of rows, this excludes the middle row"""
function tophalf(grid)
    nrows = size(grid, 1)
    return grid[1:nrows÷2, :]
end

"""Returns lower half of the grid. For odd number of rows, this excludes the middle row"""
function bottomhalf(grid)
    nrows = size(grid, 1)
    return grid[nrows-nrows÷2+1:end, :]
end

"""Returns the left half of the grid. For odd number of colums, this excludes the middle column."""
function lefthalf(grid)
    ncols = size(grid, 2)
    return grid[:, 1:ncols÷2]
end

"""Returns the right half of the grid. For odd number of colums, this excludes the middle column."""
function righthalf(grid)
    ncols = size(grid, 2)
    return grid[:, ncols-ncols÷2+1:end]
end

"""Removes frontiers from the grid, i.e., rows and columns where all cells have the same value"""
function compress(grid)
    keep_rows = .![all(x -> x == r[1], r) for r in eachrow(grid)]
    keep_cols = .![all(x -> x == c[1], c) for c in eachcol(grid)]

    return grid[keep_rows, keep_cols]
end

"""Vector of frontiers, i.e., horizontal and vertical rows/columns where all values are the same"""
function frontiers(grid)
    h, w = shape(grid)

    # Find rows and cols where all elements are the same
    row_indices = [i for i in 1:h if length(unique(grid[i, :])) == 1]
    column_indices = [j for j in 1:w if length(unique(grid[:, j])) == 1]

    # horizontal frontiers
    hfrontiers = [
        [(grid[i, j], CartesianIndex(i, j)) for j in 1:w]
        for i in row_indices
    ]

    # vertical frontiers
    vfrontiers = [
        [(grid[i, j], CartesianIndex(i, j)) for i in 1:h]
        for j in column_indices
    ]
    return vcat(hfrontiers, vfrontiers)
end

"""Constructs a grid of given dimensions and fills it with value"""
canvas(value::Integer, dimensions::CartesianIndex) = fill(value, dimensions[1], dimensions[2])


"""Get color of grid at given location loc"""
index(grid, loc) = grid[loc]

"""Returns smalles subgrid that contains the patch"""
subgrid(patch, grid) = crop(grid, ulcorner(patch), shape(patch))

"""Remove an object from grid by filling with locations with background color."""
cover(grid, patch) = fill_loc(grid, mostcolor(grid), patch)

"""Moves object on grid by given offset"""
move(grid, object, offset) = paint(cover(grid, object), shift(object, offset))

"""Locations where object occurs in grid"""
function occurrences(grid, object)
    isempty(object) && return []

    # Normalize and compute dimensions in one pass
    norm = normalize(object)
    oh, ow = shape(object)

    # Unified grid access using indexing
    h, w = shape(grid)

    h2 = h - oh + 1
    w2 = w - ow + 1
    (h2 < 1 || w2 < 1) && return []

    occs = []

    @inbounds for i0 in 1:h2, j0 in 1:w2
        if all(grid[i0+d[1], j0+d[2]] == v for (v, d) in norm)
            push!(occs, CartesianIndex(i0, j0))
        end
    end

    return occs
end