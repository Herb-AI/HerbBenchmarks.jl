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
function rot90deg(grid)
    return rotr90(grid, 1)
end

"""
    Rotates grid by 180 degrees
"""
function rot180deg(grid)
    return Base.rot180(grid)
end

"""
    Rotates grid by 270 degrees (left-rotate by 90 degrees)
"""
function rot270deg(grid)
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
    Split `grid` along horizontal into `n` parts.
"""
function hsplit(grid::Matrix, n::Integer)
    _, w_total = size(grid)
    w = w_total ÷ n
    offset = w_total % n != 0 ? 1 : 0
    return [grid[:, (w*i+i*offset+1):(w*(i+1)+i*offset)] for i in 0:n-1]
end

"""
    Split `grid` along vertica into `n` parts 
"""
function vsplit(grid::Matrix, n::Integer)
    h_total, _ = size(grid)
    h = h_total ÷ n
    offset = h_total % n != 0 ? 1 : 0
    return [grid[(h*i+i*offset+1):(h*(i+1)+i*offset), :] for i in 0:n-1]
end

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
function replace_color(grid, replacee, replacer)
    # replace in original Python implementation => renamed due to name clash
    return [grid[i, j] == replacee ? replacer : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)]
end

"""
    Switches color for cells with value `a` and `b`. Other cells remain unchanged.
"""
function switch(grid, a, b)
    return [grid[i, j] == a ? b : grid[i, j] == b ? a : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)]
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

function ulcorner(object::Vector{<:Tuple})
    return ulcorner(toindices(object))
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

urcorner(object::Vector{<:Tuple}) = urcorner(toindices(object))

"""
    Returns `CartesianIndex` of lower left corner.
"""
function llcorner(indices)
    max_row = typemin(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(max_row, min_col)
end

llcorner(object::Vector{<:Tuple}) = llcorner(toindices(object))

"""
    Returns `CartesianIndex` of lower right corner.
"""
function lrcorner(indices)
    max_row = typemin(Int)
    max_col = typemin(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        max_col = max(max_col, col)
    end
    return CartesianIndex(max_row, max_col)
end

lrcorner(object::Vector{<:Tuple}) = lrcorner(toindices(object))

"""
    Returns indices
"""
function toindices(object::Vector{<:Tuple})
    return [i[2] for i in object]
end

function toindices(indices)
    return indices
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

"""
    Mirrors along the counter-diagonal.
"""
function cmirror(grid)
    # n = size(grid, 1)
    # mirrored = similar(grid)
    # for i in 1:n, j in 1:n
    #     mirrored[i, j] = grid[n+1-j, n+1-i]
    # end
    # return mirrored
    # alternative:
    reverse(transpose(reverse(grid, dims=1)), dims=1)
end

function cmirror(piece::AbstractVector)
    # vmirror(dmirror(vmirror(piece)))
    return vmirror(dmirror(vmirror(piece)))
end

""" 
    Upscales `grid` or `object` by given `factor`. 
"""
function upscale(grid::AbstractMatrix, factor)
    rows, cols = size(grid)
    upscaled = Matrix{eltype(grid)}(undef, rows * factor, cols * factor)
    for i in 1:rows
        for j in 1:cols
            value = grid[i, j]
            for irep in 0:factor-1
                for jrep in 0:factor-1
                    upscaled[(i-1)*factor+irep+1, (j-1)*factor+jrep+1] = value
                end
            end
        end
    end
    return upscaled
end

function upscale(object, factor)
    isempty(object) && return []

    corner = ulcorner(object)
    di_inv, dj_inv = Tuple(corner)
    normed_obj = shift(object, CartesianIndex(-di_inv, -dj_inv))

    o = [(value, CartesianIndex(i * factor + io, j * factor + jo))
         for (value, idx) in normed_obj
         for (i, j) in (Tuple(idx),)
         for io in 0:(factor-1)
         for jo in 0:(factor-1)]

    return shift(o, CartesianIndex(di_inv, dj_inv))
end

"""
    Returns smalles subgrid that contains the patch
"""
function subgrid(patch, grid)
    return crop(grid, ulcorner(patch), shape(patch))
end

"""
    Returns the index of the center of the patch
"""
function center(patch)
    height, width = shape(patch)
    return CartesianIndex(uppermost(patch) + (height ÷ 2), leftmost(patch) + (width ÷ 2))
end

"""
    Relative position between two patches `a` and `b`.
"""
function rel_position(a, b)
    # `position()` in Python implementation => renamed due to name clash
    ia, ja = center(a).I
    ib, jb = center(b).I
    return CartesianIndex(sign(ib - ia), sign(jb - ja))
end

"""
    Indices of corners of given `patch`.
"""
function corners(patch)
    return [ulcorner(patch), urcorner(patch), llcorner(patch), lrcorner(patch)]
end

"""
    Remove an object from grid by filling with locations with background color.
"""
function cover(grid, patch)
    return fill_loc(grid, mostcolor(grid), patch)
end

"""
    Moves `object` on `grid` by given `offset`
"""
function move(grid, object, offset)
    return paint(cover(grid, object), shift(object, offset))
end


"""
    Vector of frontiers, i.e., horizontal and vertical rows/columns where all values are the same
"""
function frontiers(grid)
    h, w = shape(grid)

    # Find rows and cols where all elements are the same
    row_indices = [i for i in 1:h if length(unique(grid[i, :])) == 1]
    column_indices = [j for j in 1:w if length(unique(grid[:, j])) == 1]

    # horizontal frontiers
    hfrontiers = [
        [(grid[i, j], CartesianIndex(i, j)) for j in 1:w] # TODO: why Set()
        for i in row_indices
    ]

    # vertical frontiers
    vfrontiers = [
        [(grid[i, j], CartesianIndex(i, j)) for i in 1:h]
        for j in column_indices
    ]
    return vcat(hfrontiers, vfrontiers)
end

"""
    Horizontal periodicity, i.e. smallest horizontal distance at which pattern repeats. Returns full width if not pattern found.
"""
function hperiod(object)
    normalized = normalize(object)
    w = width(normalized)

    for p in 1:(w-1)
        offsetted = shift(normalized, (0, -p))
        # Keep only cells with non-negative column indices
        pruned = Set((c, CartesianIndex(ind)) for (c, ind) in offsetted if ind[2] >= 0)

        if issubset(pruned, normalized)
            return p
        end
    end

    return w
end

"""
    Vertical periodicity, i.e. smallest vertical distance at which pattern repeats. Returns full width if not pattern found.
# """
function vperiod(object)
    normalized = normalize(object)
    h = height(normalized)


    for p in 1:(h-1)
        offsetted = shift(normalized, (-p, 0))
        # Keep only cells with non-negative row indices
        pruned = Set((c, CartesianIndex(ind)) for (c, ind) in offsetted if ind[1] >= 0)

        if issubset(pruned, normalized)
            return p
        end
    end

    return h
end
