"""initialize vector"""
init(value) = [value]

"""Row index of lowermost occupied cell"""
lowermost(object::Vector{<:Tuple}) = maximum(x[2][1] for x in object)
lowermost(indices) = maximum(x[1] for x in indices)

"""Row index of uppermost occupied cell"""
uppermost(object::Vector{<:Tuple}) = minimum(x[2][1] for x in object)
uppermost(indices) = minimum(x[1] for x in indices)

"""Row index of rightmost occupied cell"""
rightmost(object::Vector{<:Tuple}) = maximum(x[2][2] for x in object)
rightmost(indices) = maximum(x[2] for x in indices)

"""Row index of leftmost occupied cell"""
leftmost(object::Vector{<:Tuple}) = minimum(x[2][2] for x in object)
leftmost(indices) = minimum(x[2] for x in indices)

""" Height of grid or patch"""
height(grid::Matrix) = size(grid)[1]
height(patch) = lowermost(patch) - uppermost(patch) + 1

"""Width of grid or patch"""
width(grid::Matrix) = size(grid)[2]
width(patch) = rightmost(patch) - leftmost(patch) + 1

"""Dimensions (height and width) of grid or patch"""
shape(piece) = (height(piece), width(piece))

"""Whether height is greater than width"""
portrait(piece) = height(piece) > width(piece)

"""Whether the piece forms a square"""
square(grid::Matrix) = height(grid) == width(grid)

function square(patch)
    h = height(patch)
    w = width(patch)
    return h == w && h * w == length(patch)
end

"""Whether the piece forms a vertical line"""
vline(piece) = height(piece) == length(piece) && width(piece) == 1

"""Whether the piece forms a horizontal line. """
hline(piece) = width(piece) == length(piece) && height(piece) == 1

"""
    Returns the most common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
mostcolor(grid::Matrix) = findmax(countmap(grid))[2]
mostcolor(object) = findmax(countmap(x[1] for x in object))[2]

"""
    Returns the least common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
leastcolor(grid::Matrix) = findmin(countmap(grid))[2]
leastcolor(object) = findmin(countmap(x[1] for x in object))[2]

"""Number of cells with given color value"""
colorcount(grid::Matrix, value) = count(==(value), grid)
colorcount(element, value) = count(==(value), x[1] for x in element)


"""Filters objects by color value. An object is included if its first element matches the color value."""
colorfilter(objects, value) = [obj for obj in objects if first(obj[1]) == value]
# The Python implementation checks first element to `obj` only. Unclear if intended this way.

"""Return container with only elements of given size"""
function sizefilter(container, size)
    return [x for x in container if length(x) == size]
end

"""Returns index of upper left corner."""
function ulcorner(indices)
    min_row = typemax(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        min_row = min(min_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(min_row, min_col)
end

ulcorner(object::Vector{<:Tuple}) = ulcorner(toindices(object))

"""Returns index of upper right corner."""
function urcorner(indices)
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

"""Returns index of lower left corner"""
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

"""Returns index of lower right corner."""
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

"""Returns indices"""
toindices(object::Vector{<:Tuple}) = [i[2] for i in object]
toindices(indices) = indices

"""Mirrors along vertical"""
vmirror(grid) = reverse(grid, dims=2)

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

""" Mirrors along horizontal."""
hmirror(grid) = reverse(grid, dims=1)

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

"""Mirrors along diagonal."""
dmirror(grid) = transpose(grid)

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

"""Mirrors along the counter-diagonal"""
cmirror(grid) = reverse(transpose(reverse(grid, dims=1)), dims=1)

cmirror(piece::AbstractVector) = vmirror(dmirror(vmirror(piece)))

""" Upscales grid or object by given `factor`"""
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

"""Returns the index of the center of the patch"""
function center(patch)
    height, width = shape(patch)
    return CartesianIndex(uppermost(patch) + (height ÷ 2), leftmost(patch) + (width ÷ 2))
end

"""Relative position between two patches a and b."""
function rel_position(a, b)
    # `position()` in Python implementation => renamed due to name clash
    ia, ja = center(a).I
    ib, jb = center(b).I
    return CartesianIndex(sign(ib - ia), sign(jb - ja))
end

"""Indices of corners of given patch."""
corners(patch) = [ulcorner(patch), urcorner(patch), llcorner(patch), lrcorner(patch)]

"""Horizontal periodicity, i.e. smallest horizontal distance at which pattern repeats. Returns full width if not pattern found."""
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

"""Vertical periodicity, i.e. smallest vertical distance at which pattern repeats. Returns full width if not pattern found."""
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


"""Crop grid from start point to given dims"""
function crop(grid, start, dims)
    row = start[1]
    col = start[2]
    nrows, ncols = dims
    return grid[row:row+nrows-1, col:col+ncols-1]
end

"""Recolor patch to given color value"""
recolor(value, object::Vector{<:Tuple}) = [(value, ind) for ind in toindices(object)]
recolor(value, indices) = [(value, ind) for ind in indices]

"""
Shift patch in given directions (offset)
"""
function shift(object::Vector{<:Tuple}, directions)
    if isempty(object)
        return object
    end
    dx = directions[1] # row
    dy = directions[2] # col
    return [(val, CartesianIndex(ind[1] + dx, ind[2] + dy)) for (val, ind) in object]
end

function shift(indices, directions)
    if isempty(indices)
        return indices
    end
    dx = directions[1] # row
    dy = directions[2] # col
    return [CartesianIndex(ind[1] + dx, ind[2] + dy) for ind in indices]
end

""" Moves top left corner to origin"""
function normalize(patch)
    if isempty(patch)
        return patch
    end
    return shift(patch, (-uppermost(patch), -leftmost(patch)))
end

"""Indices of directly adjacent neighbours of a location. 4-connectivity"""
function dneighbors(loc)
    # out-of-bound/negative indices possible => intended?
    offsets = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1))
    return [loc + off for off in offsets]
end

"""Diagonally adjacent indices of a location."""
function ineighbors(loc)
    offsets = (CartesianIndex(-1, -1), CartesianIndex(-1, 1), CartesianIndex(1, -1), CartesianIndex(1, 1))
    return [loc + off for off in offsets]
end

"""All adjacent indices of a location. 8-connectivity."""
neighbors(loc) = [dneighbors(loc); ineighbors(loc)]

"""
Finds connected objects in `grid`.

# Arguments
- `grid`: The input matrix.
- `univalued`: If `true`, only cells of the same color are connected.
- `diagonal`: If `true`, uses 8-connectivity (diagonal neighbors included); otherwise, uses 4-connectivity.
- `without_bg`: If `true`, the most common value (background) is ignored.
"""
function objects(grid, univalued, diagonal, without_bg)
    bg = without_bg ? mostcolor(grid) : nothing
    objs = Set()
    occupied = Set()
    indices = asindices(grid)

    for loc in indices
        if loc in occupied
            continue
        end
        val = grid[loc]
        if without_bg && val == bg
            continue
        end
        obj = Set()
        cands = Set{CartesianIndex}()  # Changed: specify type
        push!(cands, loc)
        while !isempty(cands)
            new_cands = Set()
            for c in cands
                v = grid[c]
                if univalued ? (v == val) : (v != bg)
                    push!(obj, (v, c))
                    push!(occupied, c)
                    # get new candidates
                    neigh = diagonal ? neighbors(c) : dneighbors(c) # get all neighbours
                    inbounds = [n for n in neigh if checkbounds(Bool, grid, n)] # filter for inbounds
                    for n in inbounds  # Changed: use loop instead of union!
                        push!(new_cands, n)
                    end
                end
            end
            cands = setdiff(new_cands, occupied)
        end
        if !isempty(obj)
            push!(objs, obj)
        end
    end
    return objs
end

"""All color in object or grid"""
palette(grid::Matrix) = unique(grid)
palette(object) = unique([v[1] for v in object])

"""Splits the grid into objects where each object contains all cells of one color/value"""
function partition(grid)
    vals = palette(grid)
    return [
        [(v, idx) for idx in findall(==(v), grid)]
        for v in vals
    ]
end

"""Splits the grid into objects where each object contains all cells of one color/value excluding background"""
function fgpartition(grid)
    pal = palette(grid)
    bg = mostcolor(grid) # background color
    vals = setdiff(pal, bg)
    return [
        [(v, idx) for idx in findall(==(v), grid)]
        for v in vals
    ]
end

"""Returns true if patches a and b share any row index. """
function hmatching(a, b)
    indices_a = Set(i[1] for i in toindices(a))
    return any(i[1] in indices_a for i in toindices(b))
end

"""Returns true if patches a and b share any column index. """
function vmatching(a, b)
    indices_a = Set(i[2] for i in toindices(a))
    return any(i[2] in indices_a for i in toindices(b))
end

"""Min. manhattan distance between two patches a and b"""
manhattan(a, b) = minimum(abs(ai[1] - bi[1]) + abs(ai[2] - bi[2]) for ai in toindices(a), bi in toindices(b))

"""Whether two patches a and b are adjacent"""
adjacent(a, b) = manhattan(a, b) == 1

"""Whether a patch is adjacent to a grid border"""
function bordering(patch, grid)
    return uppermost(patch) == 1 || leftmost(patch) == 0 || lowermost(patch) == height(grid) || rightmost(patch) == width(grid)
end

"""Returns the center of mass for a patch"""
function centerofmass(patch)
    n = length(patch)
    sum_rows = 0
    sum_cols = 0
    for idx in toindices(patch)
        sum_rows += idx[1]
        sum_cols += idx[2]
    end
    return CartesianIndex(sum_rows ÷ n, sum_cols ÷ n)
end

"""Number of different colors in the element (object or grid)."""
numcolors(element) = length(palette(element))

"""Returns color of an object."""
# Assumes object is uniform in color. 
color(object) = first(object)[1]

"""Returns an object made from indices provided by patch and corresponding values in grid"""
toobject(patch, grid) = [(grid[ind], ind) for ind in toindices(patch)]

"""Converts grid into an object"""
asobject(grid) = [(grid[idx], idx) for idx in asindices(grid)]

"""Fill value in grid at locations given by patch indices"""
function fill_loc(grid, value, patch) # fill() in original. Renamed due to name clash.
    grid_filled = copy(grid)
    indices = toindices(patch)
    grid_filled[indices] .= value
    return grid_filled
end

"""Paint object to grid."""
function paint(grid, object)
    grid_painted = copy(grid)
    for (val, ind) in object
        if checkbounds(Bool, grid_painted, ind)
            grid_painted[ind] = val
        end
    end
    return grid_painted
end

"""Fills given value at patch indices to the grid if they are background"""
function underfill(grid, value, patch)
    bg = mostcolor(grid)
    grid_painted = copy(grid)
    indices = toindices(patch)
    for ind in indices
        if checkbounds(Bool, grid_painted, ind) && grid_painted[ind] == bg
            grid_painted[ind] = value
        end
    end
    return grid_painted
end

"""Paints object to the grid where grid is background """
function underpaint(grid, object)
    bg = mostcolor(grid)
    grid_painted = copy(grid)
    for (val, ind) in object
        if checkbounds(Bool, grid_painted, ind) && grid_painted[ind] == bg
            grid_painted[ind] = val
        end
    end
    return grid_painted
end

"""Indices of bounding box of patch"""
function backdrop(patch)
    isempty(patch) && return []
    indices = toindices(patch)
    si, sj = ulcorner(indices).I
    ei, ej = lrcorner(indices).I
    return [CartesianIndex(i, j) for i in range(si, ei) for j in range(sj, ej)]
end


"""Indices inside the patch's bounding box without the patch itself"""
function delta(patch)
    isempty(patch) && return []
    return setdiff(backdrop(patch), toindices(patch))
end

"""Direction in which to move until source patch is adjacent to destination."""
function gravitate(source, destination)
    si, sj = center(source).I
    di, dj = center(destination).I

    # Initial direction
    i, j = if vmatching(source, destination)
        (si < di ? 1 : -1, 0)
    else
        (0, sj < dj ? 1 : -1)
    end

    direction = CartesianIndex(i, j)
    total_movement = direction
    c = 0

    while !adjacent(source, destination) && c < 42
        c += 1
        total_movement += direction
        source = shift(source, direction)
    end

    return total_movement - direction
end

"""Inbox for patch, i.e., inner rectangular border around patch"""
function inbox(patch)
    ai, aj = uppermost(patch) + 1, leftmost(patch) + 1
    bi, bj = lowermost(patch) - 1, rightmost(patch) - 1
    si, sj = min(ai, bi), min(aj, bj)
    ei, ej = max(ai, bi), max(aj, bj)

    vlines = vcat([CartesianIndex(i, sj) for i in si:ei],
        [CartesianIndex(i, ej) for i in si:ei])

    hlines = vcat([CartesianIndex(si, j) for j in sj:ej],
        [CartesianIndex(ei, j) for j in sj:ej])

    return unique(vcat(vlines, hlines))
end


"""Outbox for patch, i.e., outer rectangular border around patch"""
function outbox(patch)
    ai, aj = uppermost(patch) - 1, leftmost(patch) - 1
    bi, bj = lowermost(patch) + 1, rightmost(patch) + 1
    si, sj = min(ai, bi), min(aj, bj)
    ei, ej = max(ai, bi), max(aj, bj)

    vlines = vcat([CartesianIndex(i, sj) for i in si:ei],
        [CartesianIndex(i, ej) for i in si:ei])

    hlines = vcat([CartesianIndex(si, j) for j in sj:ej],
        [CartesianIndex(ei, j) for j in sj:ej])

    return unique(vcat(vlines, hlines))
end

"""Outline of patch"""
function box(patch)
    isempty(patch) && return [] # not sure why inbox and outbox don't check for this
    ai, aj = ulcorner(patch).I
    bi, bj = lrcorner(patch).I
    si, sj = min(ai, bi), min(aj, bj)
    ei, ej = max(ai, bi), max(aj, bj)

    vlines = vcat([CartesianIndex(i, sj) for i in si:ei],
        [CartesianIndex(i, ej) for i in si:ei])

    hlines = vcat([CartesianIndex(si, j) for j in sj:ej],
        [CartesianIndex(ei, j) for j in sj:ej])

    return unique(vcat(vlines, hlines))
end


"""Returns a vertical frontier, i.e. all vertical indices (rows 1 to 30) of the column given by location"""
vfrontier(location) = [CartesianIndex(i, location[2]) for i in 1:30]
# 30 is maximum grid size

"""Returns a horizontal frontier, i.e. all horizontal indices (cols 1 to 30) of the row given by location."""
hfrontier(location) = [CartesianIndex(location[1], i) for i in 1:30]
# 30 is maximum grid size

"""Returns all points (cells) on a line between two points (cells) if the line is horizontal, vertical or diagonal."""
function connect(a, b)
    ai = a[1]
    aj = a[2]
    bi = b[1]
    bj = b[2]

    si = min(ai, bi)
    ei = max(ai, bi)
    sj = min(aj, bj)
    ej = max(aj, bj)

    if ai == bi
        # Horizontal line
        return [CartesianIndex(ai, j) for j in sj:ej]
    elseif aj == bj
        # Vertical line
        return [CartesianIndex(i, aj) for i in si:ei]
    elseif bi - ai == bj - aj
        # Diagonal: down-right or up-left
        return [CartesianIndex(i, j) for (i, j) in zip(si:ei, sj:ej)]
    elseif bi - ai == aj - bj
        # Diagonal: down-left or up-right
        return [CartesianIndex(i, j) for (i, j) in zip(si:ei, ej:-1:sj)]
    else
        return CartesianIndex{2}[]
    end
end

"""filter container for elements that satisfy condition (provided as function)"""
sfilter(container, condition) = filter(condition, container)

"""filter and merge"""
mfilter(container, func) = merge_containers(sfilter(container, func))

"""Line from starting point in given direction"""
shoot(start, direction) = connect(start, (start[1] + 42 * direction[1], start[2] + 42 * direction[2]))

"""Merge elements of nested containers"""
merge_containers(containers) = reduce(vcat, containers)