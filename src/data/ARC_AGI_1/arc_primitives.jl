#=
    ARC-AGI-1 Primitives
    
    Primitive functions based on Michael Hodel's Python implementation

=#


# Some primitives are not needed in Herb and hence not impemented:
# `chain`, `composer`, `power`, `matcher`, `lbind`, `rbind`, `fork`, `totuple`
# 
# 
#=
    Types
    
    Core Types:
    - Grid: Matrix{Int} — 2D matrix of integers (color values 0-9)
    - Integer: Int — Integer scalar
    - Boolean: Bool — Boolean true/false value
    - IntegerTuple: CartesianIndex{2} — 2D coordinate pair (row, col)
    - Indices: Vector{CartesianIndex} — List of grid positions
    - Object: Vector{Tuple{Int, CartesianIndex}} — Colored patch (color, position) pairs
    - Objects: Vector{Object} — List of objects
    
    Union Types:
    - Patch: Object | Indices — Spatial regions (colored or uncolored)
    - Piece: Grid | Patch — Any spatial data
    - Element: Object | Grid — Things with colors
    - Container: Grid | Object | Objects | Indices — Generic containers
=#

using MLStyle
using StatsBase

"""Returns the sum of a and b"""
add(a, b) = a + b
add(a::CartesianIndex{N}, b::Integer) where N = a + CartesianIndex(ntuple(_ -> b, N))
add(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) + b


"""Subtracts b from a"""
subtract(a, b) = a - b
subtract(a::CartesianIndex{N}, b::Integer) where N = a - CartesianIndex(ntuple(_ -> b, N))
subtract(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) - b

"""Returns the product of  a and b"""
multiply(a, b) = a * b
multiply(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] * b[i], N))

""" Returns the result of integer division of  a and b"""
divide(a, b) = a ÷ b
divide(a::CartesianIndex{N}, b) where N = CartesianIndex(ntuple(i -> a[i] ÷ b, N))
divide(a, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> a ÷ b[i], N))
divide(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] ÷ b[i], N))

"""Inverts the sign of a"""
invert(a) = -1 * a


"""Scales a by two"""

double(a) = a * 2

"""Floor division of a by two"""
halve(a::Integer) = a ÷ 2
halve(a::CartesianIndex) = divide(a, 2)

"""Increment by one"""
increment(a) = add(a, 1)

"""Decrement by one"""
decrement(a) = subtract(a, 1)

"""Increments positive values, decrements negative. Zero unchanged"""
crement(a) = a + (a > 0) - (a < 0)
crement(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> crement(a[i]), N))

"""Returns sign of (each element of) a, preserving the type of a"""
signof(a) = sign(a)
signof(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> sign(a[i]), N))

"""Returns whether an a is even"""
even(a) = a % 2 == 0

"""Returns wheter a is greater than b"""
greater(a, b) = a > b

"""Returns whether a is greater than zero"""
positive(a) = a > 0

"""Returns vertically pointing vector"""
toivec(i) = CartesianIndex(i, 0)

"""Returns horizontally pointing vector"""
tojvec(j) = CartesianIndex(0, j)

"""Constructs CartesianIndex from a and b"""
astuple(a, b) = CartesianIndex(a, b)

"""Flip bool to opposite value"""
flip(a) = !a

"""Boolean AND (short-circuiting)"""
both(a, b) = a && b

"""Boolean OR (short-circuiting)"""
either(a, b) = a || b

"""Wrapper around `==`"""
equality(a, b) = a == b
equality(a::Vector, b::Vector) = Set(a) == Set(b) # for Object where order doesn't matter

"""Whether value is an element of container"""
contained(value, container) = value in container

"""Combine two vectors"""
combine(a, b) = vcat(a, b)

"""Intersection of two containers (vectors) a and b"""
intersection(a, b) = intersect(a, b)

"""difference between elements in two containers (vectors) a and b"""
difference(a, b) = setdiff(a, b)

"""Removes duplicate rows/elements from matrix/vector"""
dedupe(grid::Matrix) = stack(unique(eachrow(grid)))'
dedupe(a) = unique(a)

"""Order container"""
order(container) = sort(collect(container))

"""Order container by custom key `compfunc`"""
order_by(container, compfunc) = sort(collect(container), by=compfunc)

"""Repeat item (Grid) to have item a total of num times"""
repeat_item(item, num) = hcat([item for i in 1:num]...)

"""Size of container"""
size_of(container) = length(container)

"""maximum"""
maximum_of(container) = maximum(container)

"""maximum"""
minimum_of(container) = minimum(container)

"""maximum by custom function"""
function valmax(container, compfunc; default=0)
    isempty(container) && return compfunc(default)
    return maximum(compfunc(x) for x in container)
end

"""minimum by custom function"""
function valmin(container, compfunc; default=0)
    isempty(container) && return compfunc(default)
    return minimum(compfunc(x) for x in container)
end

"""returns the container that maximizes the custom function"""
argmax_by(containers, compfunc) = containers[argmax(compfunc.(containers))]

"""returns the container that maximizes the custom function"""
argmin_by(containers, compfunc) = containers[argmin(compfunc.(containers))]

"""most common item in container"""
mostcommon(container) = mode(container)

"""least common item in container"""
leastcommon(container) = argmin(countmap(container))

"""initialize vector"""
init(value) = fill(value, 1, 1)

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
shape(piece) = CartesianIndex(height(piece), width(piece))

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
    height, width = shape(patch).I
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

"""filter container for elements that satisfy predicate function (provided as function)"""
sfilter(container, condition) = filter(condition, container)

"""filter and merge"""
mfilter(containers, condition) = merge_containers(sfilter(containers, condition))

"""Line from starting point in given direction"""
shoot(start, direction) = connect(start, (start[1] + 42 * direction[1], start[2] + 42 * direction[2]))

"""Merge elements of nested container"""
merge_containers(container) = reduce(vcat, container) # also works with non-nested containers. We don't have `ContainerContainer` 

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
    h, w = shape(grid).I

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
subgrid(patch, grid) = crop(grid, ulcorner(patch), shape(patch).I)

"""Remove an object from grid by filling with locations with background color."""
cover(grid, patch) = fill_loc(grid, mostcolor(grid), patch)

"""Moves object on grid by given offset"""
move(grid, object, offset) = paint(cover(grid, object), shift(object, offset))

"""Locations where object occurs in grid"""
function occurrences(grid, object)
    isempty(object) && return []

    # Normalize and compute dimensions in one pass
    norm = normalize(object)
    oh, ow = shape(object).I

    # Unified grid access using indexing
    h, w = shape(grid).I

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

"""Return first element of container that fulfills given condition"""
function extract(container, condition)
    idx = findfirst(condition, container)
    return idx === nothing ? nothing : container[idx]
end

"""Return first element of a container"""
firstof(container) = first(container)

"""Return last element of a container"""
lastof(container) = last(container)

"""Insert element to container"""
insert(value, container) = push!(copy(container), value)

"""Remove value from container"""
remove(value, container) = filter(!=(value), container)

"""Returns other value in container, i.e., first element after removing given value"""
other(value, container) = firstof(remove(value, container))

"""Returns range between start and stop with given step size"""
interval(start, stop, step) = range(start, stop, step=step)

"""Cartesian product of two containers a and b"""
cartesian_product(a, b) = vec(collect(CartesianIndex.(Iterators.product(a, b))))

"""Zip up two CartesianIndex"""
pair(a, b) = collect(CartesianIndex.(zip(a.I, b.I)))

# note: some primitives below wouldn't be necessary in Herb

"""if-else condition"""
branch(condition, a, b) = condition ? a : b

"""Apply function to each element in container"""
apply(func, container) = map(func, container)

"""Apply each function in container to a value"""
rapply(container, value) = [f(value) for f in container] # not included in grammar since it can't construct container of functions

"""Apply and merge"""
mapply(func, container) = merge_containers(apply(func, container)) # not included in grammar

"""Apply function on two vectors a and b"""
papply(func, a, b) = func.(a, b) # not included in grammar - only works if a and be are the same length (hard to guarantee in search)

"""""Apply function on two vectors and merge"""
mpapply(func, a, b) = merge_containers(papply(func, a, b)) # not included (see papply())

"""apply function on cartesian product"""
prapply(func, a, b) = [func(i, j) for j in b for i in a] # not included in grammar

"""Compose a function from inner and outer"""
compose(outer, inner) = x -> outer(inner(x)) # not included in grammar

"""Compose from three functions by chaining: h(g(f(x)))"""
chain(h, g, f) = x -> h(g(f(x))) # not included in grammar

"""Negates predicate function"""
negate(f) = x -> !f(x)

"""
Given predicates f and g, returns a predicate that is true when both f(x) and g(x) are true.
"""
conjunct(f, g) = x -> f(x) && g(x)

"""
Given predicates f and g, returns a predicate that is true when either f(x) or g(x) is true.
"""
disjunct(f, g) = x -> f(x) || g(x)

#=
    ARC-AGI-1 basic primitives
    
    A "naive" primitive implementation

=#

# Define a struct to represent the grid
struct Grid
    width::Int
    height::Int
    data::Matrix{Int}
end

Grid(mat::Matrix{Int}) = Grid(size(mat)..., mat)

"""
Returns a new `Grid` initialized from a one-dimensional vector of integers (`raw_grid`).
"""
function initState(raw_grid::Vector{Int})
    return Grid(array_to_matrix(raw_grid))
end

"""
Helper function to transform the input vector to a matrix of square form. 
    
If length is not a squared integer, then iteratively adjust the factors a,b such that a<b and `a*b = length(input_array)`
"""
function array_to_matrix(arr::Vector{T}) where {T}
    n = length(arr)
    a = isqrt(n)  # Start with the integer square root of n
    b = a

    # Adjust a and b to meet the requirements
    while a * b < n || b < a
        if a * b < n
            b += 1
        elseif b < a
            a -= 1
        end
    end

    # Create the matrix and fill it
    mat = Matrix{T}(undef, a, b)
    fill!(mat, 0)

    for i in 1:n
        row = div(i - 1, b) + 1
        col = rem(i - 1, b) + 1
        mat[row, col] = arr[i]
    end

    return mat
end

"""
Returns the `Grid` data as a one-dimensional vector.
"""
function returnState(grid::Grid)
    return (grid.mat')[:] # transform and flatten matrix @TODO: grid struct has no field `mat`
end

"""
Initializes a `Grid` of given width and height with zeros.
"""
function init_grid(width::Int, height::Int)
    return Grid(width, height, zeros(Int, height, width))
end


"""
Returns a new `Grid` cloned from the input `grid`.

"""
function clone_grid(grid::Grid)
    return Grid(grid.width, grid.height, copy(grid.data))
end

"""Return a new `Grid` based on the input `grid`, resized to the new width and height.

Data is copied to the new `Grid` from the top-left corner of the grid. 
If the new dimensions are smaller than the current dimensions, the grid is cropped.  
If the new dimensions are larger, the grid is padded with zeros.
"""
function resize_grid(grid::Grid, new_width::Int, new_height::Int)
    new_grid = clone_grid(grid)
    new_data = zeros(Int, new_height, new_width)
    for i in 1:min(grid.height, new_height), j in 1:min(grid.width, new_width)
        new_data[i, j] = grid.data[i, j]
    end
    return Grid(new_data)
end

"""
Wrapper around `clone_grid`. 
"""
# @TODO: Why clone and copy_from_input?
function copy_from_input(source::Grid)
    return clone_grid(source)
end

"""
Creates a new `Grid` instance with the same dimensions as the input `grid`, 
but sets all values within `Grid.data` to zero. 
"""
function reset_grid(grid::Grid)
    new_grid = clone_grid(grid)
    fill!(new_grid.data, 0)
    return new_grid
end

"""
Returns a copy of the input `grid` with the value at the cel at position `row` and `col` set to `color`.
"""
function set_cell(grid::Grid, row::Int, col::Int, color::Int)
    new_grid = clone_grid(grid)
    new_grid.data[row, col] = color
    return new_grid
end

"""
Returns a list of coordinates within a rectangle defined by the top-left and bottom-right corners. 
"""
function select(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int) # redundant function
    selected_cells = []
    if start_row > end_row || start_col > end_col
        return selected_cells
    end

    for i in start_row:min(end_row, grid.height), j in start_col:min(end_col, grid.width)
        push!(selected_cells, (i, j))
    end
    return selected_cells
end

"""
Selects a rectangular region from the input `grid` and pastes it at the specified position into the copy of a grid. 

The function is overloaded to work either on a single grid or between two grids.
"""
function select_and_paste(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(grid) # Copy of the input grid to paste into.
    new_grid.data[paste_row:paste_row+end_row-start_row, paste_col:paste_col+end_col-start_col] = grid.data[start_row:end_row, start_col:end_col]
    return new_grid
end

function select_and_paste(input_grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, target_grid::Grid, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(target_grid) # Copy of the target grid to paste into.
    new_grid.data[paste_row:paste_row+end_row-start_row, paste_col:paste_col+end_col-start_col] = input_grid.data[start_row:end_row, start_col:end_col]
    return new_grid

end

"""
Applies the floodfill algorithm to a Grid. 

The algorithm starts with the cell at the given row and column and changes the color of all connected cells to the given color.
"""
function floodfill(grid::Grid, row::Int, col::Int, color::Int)
    old_value = grid.data[row, col]
    if old_value == color # No need to floodfill if the color is the same
        return grid
    end

    new_grid = clone_grid(grid)
    function floodfill_recursive(r, c)
        if r < 1 || r > new_grid.height || c < 1 || c > new_grid.width || new_grid.data[r, c] != old_value
            return
        end
        new_grid.data[r, c] = color
        floodfill_recursive(r - 1, c)
        floodfill_recursive(r + 1, c)
        floodfill_recursive(r, c - 1)
        floodfill_recursive(r, c + 1)
    end

    floodfill_recursive(row, col)
    return new_grid
end
