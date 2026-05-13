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

Integer = Int64
Grid = Matrix{Integer}
GridContainer = Vector{Grid}
IntContainer = Vector{Integer}
Boolean = Bool
IntegerTuple = CartesianIndex{2}
Indices = Vector{IntegerTuple}
Object = Vector{Tuple{Integer, IntegerTuple}}
Objects = Vector{Object}

Unsafe = t -> Union{Nothing, t}

Patch = Union{Object, Indices}
Piece = Union{Grid, Patch}
Element = Union{Grid, Object}
Container = Union{Grid, Object, Objects, Indices}

Base.:(==)(a::Indices, b::Indices) = Set(a) == Set(b)
Base.:(==)(a::Object, b::Object) = Set(a) == Set(b)

is_color(a::Integer) = 0 <= a <= 9
is_index(a::Integer) = 0 <= a <= 30


using MLStyle
using StatsBase

"""Empty values for each type"""
empty_grid = Matrix{Integer}(undef, 0, 0)
empty_grid_container = GridContainer([])
empty_object = Object([])
empty_objects = Objects([])
empty_indices = Indices([])
empty_int_container = IntContainer([])

"""Returns the sum of a and b"""
add(a::Integer, b::Integer)::Integer = a + b
add(a::IntegerTuple, b::Integer)::IntegerTuple = a + CartesianIndex(b, b)
add(a::Integer, b::IntegerTuple)::IntegerTuple = CartesianIndex(a, a) + b
add(a::IntegerTuple, b::IntegerTuple)::IntegerTuple = a + b


"""Subtracts b from a"""
subtract(a::Integer, b::Integer)::Integer = a - b
subtract(a::IntegerTuple, b::Integer)::IntegerTuple = a - CartesianIndex(b, b)
subtract(a::Integer, b::IntegerTuple)::IntegerTuple = CartesianIndex(a, a) - b
subtract(a::IntegerTuple, b::IntegerTuple)::IntegerTuple = a - b

"""Returns the product of  a and b"""
multiply(a::Integer, b::Integer)::Integer = a * b
multiply(a::IntegerTuple, b::Integer)::IntegerTuple = CartesianIndex(a[1] * b, a[2] * b)
multiply(a::Integer, b::IntegerTuple)::IntegerTuple = CartesianIndex(a * b[1], a * b[2])
multiply(a::IntegerTuple, b::IntegerTuple)::IntegerTuple = CartesianIndex(a[1] * b[1], a[2] * b[2])

""" Returns the result of integer division of  a and b"""
divide(a::Integer, b::Integer)::Unsafe(Integer) = b != 0 ? a ÷ b : nothing
divide(a::IntegerTuple, b)::Unsafe(CartesianIndex{2}) = b != 0 ? CartesianIndex(a[1] ÷ b, a[2] ÷ b) : nothing
divide(a::Integer, b::IntegerTuple)::Unsafe(CartesianIndex{2}) = !any(iszero, b.I) ? CartesianIndex(a ÷ b[1], a ÷ b[2]) : nothing
divide(a::IntegerTuple, b::IntegerTuple)::Unsafe(CartesianIndex{2}) = !any(iszero, b.I) ? CartesianIndex(a[1] ÷ b[1], a[2] ÷ b[2]) : nothing

"""Inverts the sign of a"""
invert(a::Integer)::Integer = -1 * a
invert(a::IntegerTuple)::IntegerTuple = -1 * a


"""Scales a by two"""
double(a::Integer)::Integer = 2 * a
double(a::IntegerTuple)::IntegerTuple = 2 * a

"""Floor division of a by two"""
halve(a::Integer)::Integer = a ÷ 2
halve(a::IntegerTuple)::IntegerTuple = divide(a, 2)

"""Increment by one"""
increment(a::Integer)::Integer = add(a, 1)
increment(a::IntegerTuple)::IntegerTuple = add(a, 1)

"""Decrement by one"""
decrement(a::Integer)::Integer = subtract(a, 1)
decrement(a::IntegerTuple)::IntegerTuple = subtract(a, 1)

"""Increments positive values, decrements negative. Zero unchanged"""
crement(a::Integer)::Integer = a + (a > 0) - (a < 0)
crement(a::IntegerTuple)::IntegerTuple = CartesianIndex(crement(a[1]), crement(a[2]))

"""Returns sign of (each element of) a, preserving the type of a"""
signof(a::Integer)::Integer = sign(a)
signof(a::IntegerTuple)::IntegerTuple = CartesianIndex(sign(a[1]), sign(a[2]))

"""Returns whether an a is even"""
even(a::Integer)::Boolean = a % 2 == 0

"""Returns wheter a is greater than b"""
greater(a::Integer, b::Integer)::Boolean = a > b

"""Returns whether a is greater than zero"""
positive(a::Integer)::Boolean = a > 0

"""Returns vertically pointing vector"""
toivec(i::Integer)::IntegerTuple = CartesianIndex(i, 0)

"""Returns horizontally pointing vector"""
tojvec(j::Integer)::IntegerTuple = CartesianIndex(0, j)

"""Constructs CartesianIndex from a and b"""
astuple(a::Integer, b::Integer)::IntegerTuple = CartesianIndex(a, b)

"""Flip bool to opposite value"""
flip(a::Boolean)::Boolean = !a

"""Boolean AND (short-circuiting)"""
both(a::Boolean, b::Boolean)::Boolean = a && b

"""Boolean OR (short-circuiting)"""
either(a::Boolean, b::Boolean)::Boolean = a || b

"""Wrapper around `==`"""
equality(a::Integer, b::Integer)::Bool = a == b
equality(a::IntegerTuple, b::IntegerTuple)::Bool = a == b
equality(a::Grid, b::Grid)::Bool = a == b
equality(a::Object, b::Object)::Bool = Set(a) == Set(b) # for Object where order doesn't matter
equality(a::IntContainer, b::IntContainer)::Bool = a == b

"""Whether value is an element of container"""
contained(value::Integer, container::IntContainer)::Bool = value in container
contained(value::IntegerTuple, container::Indices)::Bool = value in container
contained(value::Object, container::Objects)::Bool = value in container

"""Combine two vectors"""
combine(a::Indices, b::Indices)::Indices = vcat(a, b)
combine(a::Object, b::Object)::Object = vcat(a, b)
combine(a::Objects, b::Objects)::Objects = vcat(a, b)
combine(a::IntContainer, b::IntContainer)::IntContainer = vcat(a, b)

"""Intersection of two containers (vectors) a and b"""
intersection(a::Indices, b::Indices)::Indices = intersect(a, b)
intersection(a::Objects, b::Objects)::Objects = intersect(a, b)
intersection(a::Object, b::Object)::Object = intersect(a, b)
intersection(a::IntContainer, b::IntContainer)::IntContainer = intersect(a, b)

"""difference between elements in two containers (vectors) a and b"""
difference(a::Indices, b::Indices)::Indices = setdiff(a, b)
difference(a::Objects, b::Objects)::Objects = setdiff(a, b)
difference(a::Object, b::Object)::Object = setdiff(a, b)
difference(a::IntContainer, b::IntContainer)::IntContainer = setdiff(a, b)

"""Removes duplicate rows/elements from matrix/vector"""
dedupe(grid::Grid)::Grid = isempty(grid) ? grid : permutedims(stack(unique(eachrow(grid))))
dedupe(a::Indices)::Indices = unique(a)
dedupe(a::Object)::Object = unique(a)
dedupe(a::Objects)::Objects = unique(a)
dedupe(a::IntContainer)::IntContainer = unique(a)

"""Order container"""
order(container::Objects)::Objects = sort(collect(container))

"""Order container by custom key `compfunc`"""
order_by(container::Objects, compfunc)::Objects = sort(collect(container), by=compfunc)

"""Repeat item (Grid) to have item a total of num times"""
function repeat_item(item::Grid, num::Integer)::Unsafe(Grid)
    isempty(item) && return item
    !is_index(width(item) * num) && return nothing 
    return repeat(item, 1, num)
end

"""Convert an object to a Grid with background value"""
asgrid(object::Object, color::Integer)::Unsafe(Grid) = is_color(color) ? underpaint(canvas(color, shape(object)), object) : nothing

"""Size of container"""
size_of(container::Container)::Integer = length(container)

"""maximum"""
maximum_of(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? maximum(container) : nothing
maximum_of(container::Grid)::Unsafe(Integer) = !isempty(container) ? maximum(container) : nothing

"""maximum"""
minimum_of(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? minimum(container) : nothing
minimum_of(container::Grid)::Unsafe(Integer) = !isempty(container) ? minimum(container) : nothing

"""maximum by custom function"""
function valmax(container::Objects, compfunc)::Unsafe(Integer)
    isempty(container) && return nothing
    res = map(compfunc, container)
    any(isnothing, res) && return nothing
    return maximum(res)
end

"""minimum by custom function"""
function valmin(container::Objects, compfunc)::Unsafe(Integer)
    isempty(container) && return nothing
    res = map(compfunc, container)
    any(isnothing, res) && return nothing
    return minimum(res)
end

"""returns the container that maximizes the custom function"""
argmax_by(containers::Objects, compfunc)::Unsafe(Object) = let res = compfunc.(containers); (isempty(res) || any(isnothing, res)) ? nothing : containers[argmax(res)] end
argmax_by(containers::GridContainer, compfunc)::Unsafe(Grid) = let res = compfunc.(containers); (isempty(res) || any(isnothing, res)) ? nothing : containers[argmax(res)] end

"""returns the container that maximizes the custom function"""
argmin_by(containers::Objects, compfunc)::Unsafe(Object) = let res = compfunc.(containers); (isempty(res) || any(isnothing, res)) ? nothing : containers[argmin(res)] end
argmin_by(containers::GridContainer, compfunc)::Unsafe(Grid) = let res = compfunc.(containers); (isempty(res) || any(isnothing, res)) ? nothing : containers[argmin(res)] end

"""most common item in container"""
mostcommon(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? mode(container) : nothing
mostcommon(container::Indices)::Unsafe(IntegerTuple) = !isempty(container) ? mode(container) : nothing
mostcommon(container::Objects)::Unsafe(Object) = !isempty(container) ? mode(container) : nothing

"""least common item in container"""
leastcommon(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? argmin(countmap(container)) : nothing
leastcommon(container::Indices)::Unsafe(IntegerTuple) = !isempty(container) ? argmin(countmap(container)) : nothing
leastcommon(container::Objects)::Unsafe(Object) = !isempty(container) ? argmin(countmap(container)) : nothing

"""initialize vector"""
init(value::Integer)::Unsafe(Grid) = is_color(value) ? fill(value, 1, 1) : nothing

"""Row index of lowermost occupied cell"""
lowermost(object::Object)::Unsafe(Integer) = !isempty(object) ? maximum(x[2][1] for x in object) : nothing
lowermost(indices::Indices)::Unsafe(Integer) = !isempty(indices) ? maximum(x[1] for x in indices) : nothing

"""Row index of uppermost occupied cell"""
uppermost(object::Object)::Unsafe(Integer) = !isempty(object) ? minimum(x[2][1] for x in object) : nothing
uppermost(indices::Indices)::Unsafe(Integer) = !isempty(indices) ? minimum(x[1] for x in indices) : nothing

"""Row index of rightmost occupied cell"""
rightmost(object::Object)::Unsafe(Integer) = !isempty(object) ? maximum(x[2][2] for x in object) : nothing
rightmost(indices::Indices)::Unsafe(Integer) = !isempty(indices) ? maximum(x[2] for x in indices) : nothing

"""Row index of leftmost occupied cell"""
leftmost(object::Object)::Unsafe(Integer) = !isempty(object) ? minimum(x[2][2] for x in object) : nothing
leftmost(indices::Indices)::Unsafe(Integer) = !isempty(indices) ? minimum(x[2] for x in indices) : nothing

""" Height of grid or patch"""
height(grid::Grid)::Integer = size(grid)[1]
height(patch::Patch)::Integer = isempty(patch) ? 0 : lowermost(patch) - uppermost(patch) + 1

"""Width of grid or patch"""
width(grid::Grid)::Integer = size(grid)[2]
width(patch::Patch)::Integer = isempty(patch) ? 0 : rightmost(patch) - leftmost(patch) + 1

"""Dimensions (height and width) of grid or patch"""
shape(piece::Piece)::IntegerTuple = CartesianIndex(height(piece), width(piece))

"""Whether height is greater than width"""
portrait(piece::Piece)::Boolean = height(piece) > width(piece)

"""Whether the piece forms a square"""
square(grid::Grid)::Boolean = height(grid) == width(grid)

function square(patch::Patch)::Boolean
    h = height(patch)
    w = width(patch)
    return h == w && h * w == length(patch)
end

"""Whether the piece forms a vertical line"""
vline(piece::Piece)::Boolean = height(piece) == length(piece) && width(piece) == 1

"""Whether the piece forms a horizontal line. """
hline(piece::Piece)::Boolean = width(piece) == length(piece) && height(piece) == 1

"""
    Returns the most common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
mostcolor(grid::Grid)::Unsafe(Integer) = !isempty(grid) ? findmax(countmap(grid))[2] : nothing
mostcolor(object::Object)::Unsafe(Integer) = !isempty(object) ? findmax(countmap(x[1] for x in object))[2] : nothing

"""
    Returns the least common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
leastcolor(grid::Grid)::Unsafe(Integer) = !isempty(grid) ? findmin(countmap(grid))[2] : nothing
leastcolor(object::Object)::Unsafe(Integer) = !isempty(object) ? findmin(countmap(x[1] for x in object))[2] : nothing

"""Number of cells with given color value"""
colorcount(grid::Grid, value::Integer)::Unsafe(Integer) = is_color(value) ? count(==(value), grid) : nothing
colorcount(object::Object, value::Integer)::Unsafe(Integer) = is_color(value) ? count(==(value), x[1] for x in object) : nothing


"""Filters objects by color value. An object is included if its first element matches the color value."""
colorfilter(objects::Objects, value::Integer)::Unsafe(Objects) = is_color(value) ? [obj for obj in objects if first(obj[1]) == value] : nothing
# The Python implementation checks first element to `obj` only. Unclear if intended this way.

"""Return container with only elements of given size"""
sizefilter(container::Objects, size::Integer)::Unsafe(Objects) = is_index(size) ? [x for x in container if length(x) == size] : nothing

"""Returns index of upper left corner."""
function ulcorner(indices::Indices)::Unsafe(IntegerTuple)
    isempty(indices) && return nothing

    min_row = typemax(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        min_row = min(min_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(min_row, min_col)
end

ulcorner(object::Object)::Unsafe(IntegerTuple) = ulcorner(toindices(object))

"""Returns index of upper right corner."""
function urcorner(indices::Indices)::Unsafe(IntegerTuple)
    isempty(indices) && return nothing

    min_row = typemax(Int)
    max_col = typemin(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        min_row = min(min_row, row)
        max_col = max(max_col, col)
    end
    return CartesianIndex(min_row, max_col)
end

urcorner(object::Object)::Unsafe(IntegerTuple) = urcorner(toindices(object))

"""Returns index of lower left corner"""
function llcorner(indices::Indices)::Unsafe(IntegerTuple)
    isempty(indices) && return nothing

    max_row = typemin(Int)
    min_col = typemax(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        min_col = min(min_col, col)
    end
    return CartesianIndex(max_row, min_col)
end

llcorner(object::Object)::Unsafe(IntegerTuple) = llcorner(toindices(object))

"""Returns index of lower right corner."""
function lrcorner(indices::Indices)::Unsafe(IntegerTuple)
    isempty(indices) && return nothing

    max_row = typemin(Int)
    max_col = typemin(Int)
    @inbounds for idx in indices
        row, col = idx[1], idx[2]
        max_row = max(max_row, row)
        max_col = max(max_col, col)
    end
    return CartesianIndex(max_row, max_col)
end

lrcorner(object::Object)::Unsafe(IntegerTuple) = lrcorner(toindices(object))

"""Returns indices"""
toindices(object::Object)::Indices = [i[2] for i in object]
toindices(indices::Indices)::Indices = indices

"""Mirrors along vertical"""
vmirror(grid::Grid)::Grid = reverse(grid, dims=2)

function vmirror(indices::Indices)::Indices
    isempty(indices) && return []

    min_col, max_col = extrema(idx[2] for idx in indices)
    d = min_col + max_col
    return [CartesianIndex(idx[1], d - idx[2]) for idx in indices]
end

function vmirror(object::Object)::Object
    isempty(object) && return []

    min_col, max_col = extrema(idx[2] for (_, idx) in object)
    d = min_col + max_col
    return [(val, CartesianIndex(idx[1], d - idx[2])) for (val, idx) in object]
end

""" Mirrors along horizontal."""
hmirror(grid::Grid)::Grid = reverse(grid, dims=1)

function hmirror(indices::Indices)::Indices
    isempty(indices) && return []

    min_row, max_row = extrema(idx[1] for idx in indices)
    d = min_row + max_row
    return [CartesianIndex(d - idx[1], idx[2]) for idx in indices]
end

function hmirror(object::Object)::Object
    isempty(object) && return []

    min_row, max_row = extrema(idx[1] for (_, idx) in object)
    d = min_row + max_row
    return [(val, CartesianIndex(d - idx[1], idx[2])) for (val, idx) in object]
end

"""Mirrors along diagonal."""
dmirror(grid::Grid)::Grid = permutedims(grid)

function dmirror(indices::Indices)::Indices
    isempty(indices) && return []

    corner = ulcorner(indices)
    a = corner[1]
    b = corner[2]
    return [CartesianIndex(idx[2] - b + a, idx[1] - a + b) for idx in indices]
end

function dmirror(object::Object)::Object
    isempty(object) && return []

    corner = ulcorner(object)
    a = corner[1]
    b = corner[2]
    return [(val, CartesianIndex(idx[2] - b + a, idx[1] - a + b)) for (val, idx) in object]
end

"""Mirrors along the counter-diagonal"""
cmirror(grid::Grid)::Grid = reverse(permutedims(reverse(grid, dims=1)), dims=1)
cmirror(piece::Object)::Object = vmirror(dmirror(vmirror(piece)))
cmirror(piece::Indices)::Indices = vmirror(dmirror(vmirror(piece)))

""" Upscales grid or object by given `factor`"""
function upscale(grid::Grid, factor::Integer)::Unsafe(Grid)
    factor < 0 && return nothing

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

function upscale(object::Object, factor::Integer)::Unsafe(Object)
    isempty(object) && return []
    factor < 0 && return nothing

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

"""Returns the index of the of the patch"""
function center(patch::Patch)::Unsafe(IntegerTuple)
    isempty(patch) && return nothing

    height, width = shape(patch).I
    return CartesianIndex(uppermost(patch) + (height ÷ 2), leftmost(patch) + (width ÷ 2))
end

"""Relative position between two patches a and b."""
function rel_position(a::Patch, b::Patch)::Unsafe(IntegerTuple)
    (isempty(a) || isempty(b)) && return nothing
    # `position()` in Python implementation => renamed due to name clash
    ia, ja = center(a).I
    ib, jb = center(b).I
    return CartesianIndex(sign(ib - ia), sign(jb - ja))
end

"""Indices of corners of given patch."""
corners(patch::Patch)::Unsafe(Indices) = isempty(patch) ? nothing : [ulcorner(patch), urcorner(patch), llcorner(patch), lrcorner(patch)]

"""Horizontal periodicity, i.e. smallest horizontal distance at which pattern repeats. Returns full width if not pattern found."""
function hperiod(object::Object)::Integer
    normalized = normalize(object)
    w = width(normalized)

    for p in 1:(w-1)
        offsetted = shift(normalized, CartesianIndex(0, -p))
        # Keep only cells with non-negative column indices
        pruned = Set((c, CartesianIndex(ind)) for (c, ind) in offsetted if ind[2] >= 0)

        if issubset(pruned, normalized)
            return p
        end
    end

    return w
end

"""Vertical periodicity, i.e. smallest vertical distance at which pattern repeats. Returns full width if not pattern found."""
function vperiod(object::Object)::Integer
    normalized = normalize(object)
    h = height(normalized)


    for p in 1:(h-1)
        offsetted = shift(normalized, CartesianIndex(-p, 0))
        # Keep only cells with non-negative row indices
        pruned = Set((c, CartesianIndex(ind)) for (c, ind) in offsetted if ind[1] >= 0)

        if issubset(pruned, normalized)
            return p
        end
    end

    return h
end


"""Crop grid from start point to given dims"""
function crop(grid::Grid, start::IntegerTuple, dims::IntegerTuple)::Unsafe(Grid)
    row = start[1]
    col = start[2]
    nrows, ncols = Tuple(dims)

    rows = row:row+nrows-1
    cols = col:col+ncols-1

    !checkbounds(Bool, grid, rows, cols) && return nothing

    return grid[rows, cols]
end

"""Recolor patch to given color value"""
recolor(value::Integer, object::Object)::Unsafe(Object) = is_color(value) ? [(value, ind) for ind in toindices(object)] : nothing
recolor(value::Integer, indices::Indices)::Unsafe(Object) = is_color(value) ? [(value, ind) for ind in indices] : nothing

"""
Shift patch in given directions (offset)
"""
function shift(object::Object, directions::IntegerTuple)::Object
    if isempty(object)
        return object
    end
    dx = directions[1] # row
    dy = directions[2] # col
    return [(val, CartesianIndex(ind[1] + dx, ind[2] + dy)) for (val, ind) in object]
end

function shift(indices::Indices, directions::IntegerTuple)::Indices
    isempty(indices) && indices
    dx = directions[1] # row
    dy = directions[2] # col
    return [CartesianIndex(ind[1] + dx, ind[2] + dy) for ind in indices]
end

""" Moves top left corner to origin"""
normalize(patch::Object)::Object = isempty(patch) ? [] : shift(patch, CartesianIndex(-uppermost(patch), -leftmost(patch)))
normalize(patch::Indices)::Indices = isempty(patch) ? [] : shift(patch, CartesianIndex(-uppermost(patch), -leftmost(patch)))

"""Indices of directly adjacent neighbours of a location. 4-connectivity"""
function dneighbors(loc::IntegerTuple)::Indices
    # out-of-bound/negative indices possible => intended?
    offsets = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1))
    return [loc + off for off in offsets]
end

"""Diagonally adjacent indices of a location."""
function ineighbors(loc::IntegerTuple)::Indices
    offsets = (CartesianIndex(-1, -1), CartesianIndex(-1, 1), CartesianIndex(1, -1), CartesianIndex(1, 1))
    return [loc + off for off in offsets]
end

"""All adjacent indices of a location. 8-connectivity."""
neighbors(loc::IntegerTuple)::Indices = [dneighbors(loc); ineighbors(loc)]

"""
Finds connected objects in `grid`.

# Arguments
- `grid`: The input matrix.
- `univalued`: If `true`, only cells of the same color are connected.
- `diagonal`: If `true`, uses 8-connectivity (diagonal neighbors included); otherwise, uses 4-connectivity.
- `without_bg`: If `true`, the most common value (background) is ignored.
"""
function objects(grid::Grid, univalued::Boolean, diagonal::Boolean, without_bg::Boolean)::Objects
    bg = without_bg ? mostcolor(grid) : nothing
    objs = []
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
        obj = []
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

"""
Finds the nth connected object in `grid`.

# Arguments
- `grid`: The input matrix.
- `univalued`: If `true`, only cells of the same color are connected.
- `diagonal`: If `true`, uses 8-connectivity (diagonal neighbors included); otherwise, uses 4-connectivity.
- `without_bg`: If `true`, the most common value (background) is ignored.
- `index`: Index of object in grid
"""
function nth_object(grid::Grid, univalued::Boolean, diagonal::Boolean, without_bg::Boolean, index::Integer)::Unsafe(Object)
    index <= 0 && return nothing
    objs = objects(grid, univalued, diagonal, without_bg)
    index > length(objs) && return nothing
    return objs[index]
end

"""All color in object or grid"""
palette(grid::Grid)::IntContainer = unique(grid)
palette(object::Object)::IntContainer = unique([v[1] for v in object])

"""Splits the grid into objects where each object contains all cells of one color/value"""
function partition(grid::Grid)::Objects
    vals = palette(grid)
    return [
        [(v, idx) for idx in findall(==(v), grid)]
        for v in vals
    ]
end

"""Splits the grid into objects where each object contains all cells of one color/value excluding background"""
function fgpartition(grid::Grid)::Unsafe(Objects)
    isempty(grid) && return []

    pal = palette(grid)
    bg = mostcolor(grid) # background color
    vals = setdiff(pal, bg)
    return [
        [(v, idx) for idx in findall(==(v), grid)]
        for v in vals
    ]
end

"""Returns true if patches a and b share any row index. """
function hmatching(a::Patch, b::Patch)::Boolean
    indices_a = Set(i[1] for i in toindices(a))
    return any(i[1] in indices_a for i in toindices(b))
end

"""Returns true if patches a and b share any column index. """
function vmatching(a::Patch, b::Patch)::Boolean
    indices_a = Set(i[2] for i in toindices(a))
    return any(i[2] in indices_a for i in toindices(b))
end

"""Min. manhattan distance between two patches a and b"""
manhattan(a::Patch, b::Patch)::Unsafe(Integer) = (!isempty(a) && !isempty(b)) ? minimum(abs(ai[1] - bi[1]) + abs(ai[2] - bi[2]) for ai in toindices(a), bi in toindices(b)) : nothing

"""Whether two patches a and b are adjacent"""
adjacent(a::Patch, b::Patch)::Unsafe(Boolean) = (!isempty(a) && !isempty(b)) ? manhattan(a, b) == 1 : nothing

"""Whether a patch is adjacent to a grid border"""
bordering(patch::Patch, grid::Grid)::Boolean = uppermost(patch) == 1 || leftmost(patch) == 0 || lowermost(patch) == height(grid) || rightmost(patch) == width(grid)

"""Returns the center of mass for a patch"""
function centerofmass(patch::Patch)::Unsafe(IntegerTuple)
    isempty(patch) && return nothing

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
numcolors(element::Element)::Integer = length(palette(element))

"""Returns color of an object."""
# Assumes object is uniform in color. 
color(object::Object)::Unsafe(Integer) = !isempty(object) ? first(object)[1] : nothing

"""Returns an object made from indices provided by patch and corresponding values in grid"""
toobject(patch::Patch, grid::Grid)::Unsafe(Object) = checkbounds(Bool, grid, toindices(patch)) ? [(grid[ind], ind) for ind in vec(toindices(patch))] : nothing

"""Converts grid into an object"""
asobject(grid::Grid)::Object = [(grid[idx], idx) for idx in vec(asindices(grid))]

"""Fill value in grid at locations given by patch indices"""
function fill_loc(grid::Grid, value::Integer, patch::Patch)::Unsafe(Grid) # fill() in original. Renamed due to name clash.
    !is_color(value) && return nothing
    grid_filled = copy(grid)
    indices = toindices(patch)
    !checkbounds(Bool, grid, indices) && return nothing
    grid_filled[indices] .= value
    return grid_filled
end

"""Paint object to grid."""
function paint(grid::Grid, object::Object)::Grid
    grid_painted = copy(grid)
    for (val, ind) in object
        if checkbounds(Bool, grid_painted, ind)
            grid_painted[ind] = val
        end
    end
    return grid_painted
end

"""Fills given value at patch indices to the grid if they are background"""
function underfill(grid::Grid, value::Integer, patch::Patch)::Unsafe(Grid)
    !is_color(value) && return nothing
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
function underpaint(grid::Grid, object::Object)::Grid
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
function backdrop(patch::Patch)::Indices
    isempty(patch) && return []
    indices = toindices(patch)
    si, sj = ulcorner(indices).I
    ei, ej = lrcorner(indices).I
    return [CartesianIndex(i, j) for i in range(si, ei) for j in range(sj, ej)]
end


"""Indices inside the patch's bounding box without the patch itself"""
function delta(patch::Patch)::Indices
    isempty(patch) && return []
    return setdiff(backdrop(patch), toindices(patch))
end

"""Direction in which to move until source patch is adjacent to destination."""
function gravitate(source::Patch, destination::Patch)::Unsafe(IntegerTuple)
    (isempty(source) || isempty(destination)) && return nothing

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
function inbox(patch::Patch)::Unsafe(Indices)
    isempty(patch) && return nothing

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
function outbox(patch::Patch)::Unsafe(Indices)
    isempty(patch) && return nothing

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
function box(patch::Patch)::Indices
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
vfrontier(location::IntegerTuple)::Indices = [CartesianIndex(i, location[2]) for i in 1:30]
# 30 is maximum grid size

"""Returns a horizontal frontier, i.e. all horizontal indices (cols 1 to 30) of the row given by location."""
hfrontier(location::IntegerTuple)::Indices = [CartesianIndex(location[1], i) for i in 1:30]
# 30 is maximum grid size

"""Returns all points (cells) on a line between two points (cells) if the line is horizontal, vertical or diagonal."""
function connect(a::IntegerTuple, b::IntegerTuple)::Indices
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
sfilter(container::IntContainer, condition)::IntContainer = filter(condition, container)
sfilter(container::Objects, condition)::Objects = filter(condition, container)
sfilter(container::GridContainer, condition)::GridContainer = filter(condition, container)

"""filter and merge"""
mfilter(containers::Objects, condition)::Object = merge_containers(sfilter(containers, condition))

"""Line from starting point in given direction"""
shoot(start::IntegerTuple, direction::IntegerTuple)::Indices = connect(start, (start[1] + 42 * direction[1], start[2] + 42 * direction[2]))

"""Merge elements of nested container"""
merge_containers(container::Objects)::Object = isempty(container) ? [] : reduce(vcat, container) # also works with non-nested containers. We don't have `ContainerContainer` 
merge_containers(container::Vector{Indices})::Indices = isempty(container) ? [] : reduce(vcat, container)

"""Returns all indices of a grid"""
asindices(grid::Grid)::Indices = vcat(collect(CartesianIndices(grid))...)

"""Returns indices of all grid cells of given value (color)"""
ofcolor(grid::Grid, value::Integer)::Unsafe(Indices) = is_color(value) ? findall(x -> x == value, grid) : nothing

"""Rotates grid by 90 degrees clockwise"""
rot90deg(grid::Grid)::Grid = rotr90(grid, 1)

"""Rotates grid by 180 degrees"""
rot180deg(grid::Grid)::Grid = Base.rot180(grid)

"""Rotates grid by 270 degrees (left-rotate by 90 degrees)"""
rot270deg(grid::Grid)::Grid = Base.rotl90(grid)

"""Downscale grid by given factor."""
downscale(grid::Grid, factor::Integer)::Unsafe(Grid) = factor > 0 ? grid[1:factor:end, 1:factor:end] : nothing

"""Concatenate grid a and grid b horizontally."""
hconcat(a::Grid, b::Grid)::Unsafe(Grid) = size(a, 1) == size(b, 1) ? hcat(a, b) : nothing

"""Concatenate grid a and grid b vertically."""
vconcat(a::Grid, b::Grid)::Unsafe(Grid) = size(a, 2) == size(b, 2) ? vcat(a, b) : nothing

"""Upscale grid horizontally."""
function hupscale(grid::Grid, factor::Integer)::Unsafe(Grid)
    !is_index(width(grid) * factor) && return nothing
    isempty(grid) && return grid
    
    return reduce(vcat, [permutedims(repeat(row, inner=(factor,))) for row in eachrow(grid)])
end

"""Upscale grid vertically."""
function vupscale(grid::Grid, factor::Integer)::Unsafe(Grid)
    !is_index(height(grid) * factor) && return nothing
    isempty(grid) && return grid
    
    return reduce(hcat, [repeat(col, inner=(factor,)) for col in eachcol(grid)])
end


"""Split grid along horizontal into n parts."""
function hsplit(grid::Grid, n::Integer)::Unsafe(GridContainer)
    isempty(grid) && return []
    n <= 0 && return nothing

    _, w_total = size(grid)
    w = w_total ÷ n
    offset = (w_total % n) / n
    from = i -> w*i + 1 + Int(round(i*offset, RoundNearestTiesUp))
    to = i -> from(i) + w - 1
    return [grid[:, from(i):to(i)] for i in 0:n-1]
end

"""Split grid along vertical into n parts"""
function vsplit(grid::Grid, n::Integer)::Unsafe(GridContainer)
    isempty(grid) && return []
    n <= 0 && return nothing

    h_total, _ = size(grid)
    h = h_total ÷ n
    offset = (h_total % n) / n
    from = i -> h*i + 1 + Int(round(i*offset, RoundNearestTiesUp))
    to = i -> from(i) + h - 1
    return [grid[from(i):to(i), :] for i in 0:n-1]
end

"""Cellwise matching of grids a and b. Returns grid with original values where `a[i, j] == b[i,j]`, otherwise `fallback`."""
cellwise(a::Grid, b::Grid, fallback::Integer)::Unsafe(Grid) = (width(a) <= width(b) && height(a) <= height(b) && is_color(fallback)) ? [a[i, j] == b[i, j] ? a[i, j] : fallback for i in axes(a, 1), j in axes(a, 2)] : nothing


"""Substituion of color value replacee with new color replacer."""
replace_color(grid::Grid, replacee::Integer, replacer::Integer)::Unsafe(Grid) = (is_color(replacee) && is_color(replacer)) ? [grid[i, j] == replacee ? replacer : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)] : nothing
# replace in original Python implementation => renamed due to name clash


"""Switches color for cells with value a and b. Other cells remain unchanged."""
switch(grid::Grid, a::Integer, b::Integer)::Unsafe(Grid) = (is_color(a) && is_color(b)) ? [grid[i, j] == a ? b : grid[i, j] == b ? a : grid[i, j] for i in axes(grid, 1), j in axes(grid, 2)] : nothing


"""Trims the borders of the grid, i.e., removes outermost rows and columns"""
trim(grid::Grid)::Grid = grid[2:end-1, 2:end-1]

"""Returns upper half of the grid. For odd number of rows, this excludes the middle row"""
function tophalf(grid::Grid)::Grid
    nrows = size(grid, 1)
    return grid[1:nrows÷2, :]
end

"""Returns lower half of the grid. For odd number of rows, this excludes the middle row"""
function bottomhalf(grid::Grid)::Grid
    nrows = size(grid, 1)
    return grid[nrows-nrows÷2+1:end, :]
end

"""Returns the left half of the grid. For odd number of colums, this excludes the middle column."""
function lefthalf(grid::Grid)::Grid
    ncols = size(grid, 2)
    return grid[:, 1:ncols÷2]
end

"""Returns the right half of the grid. For odd number of colums, this excludes the middle column."""
function righthalf(grid::Grid)::Grid
    ncols = size(grid, 2)
    return grid[:, ncols-ncols÷2+1:end]
end

"""Removes frontiers from the grid, i.e., rows and columns where all cells have the same value"""
function compress(grid::Grid)::Grid
    keep_rows = .![all(x -> x == r[1], r) for r in eachrow(grid)]
    keep_cols = .![all(x -> x == c[1], c) for c in eachcol(grid)]

    return grid[keep_rows, keep_cols]
end

"""Vector of frontiers, i.e., horizontal and vertical rows/columns where all values are the same"""
function frontiers(grid::Grid)::Objects
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
canvas(value::Integer, dimensions::IntegerTuple)::Unsafe(Grid) = (is_index(dimensions[1]) && is_index(dimensions[2]) && is_color(value)) ? fill(value, dimensions[1], dimensions[2]) : nothing

"""Get color of grid at given location loc"""
index(grid::Grid, loc::IntegerTuple)::Unsafe(Integer) = checkbounds(Bool, grid, loc) ? grid[loc] : nothing

"""Returns smalles subgrid that contains the patch"""
subgrid(patch::Patch, grid::Grid)::Unsafe(Grid) = isempty(patch) ? empty_grid : crop(grid, ulcorner(patch), shape(patch))

"""Remove an object from grid by filling with locations with background color."""
cover(grid::Grid, patch::Patch)::Unsafe(Grid) = isempty(grid) ? grid : fill_loc(grid, mostcolor(grid), patch)

"""Moves object on grid by given offset"""
function move(grid::Grid, object::Object, offset::IntegerTuple)::Unsafe(Grid)
    c = cover(grid, object)
    isnothing(c) && return nothing
    paint(c, shift(object, offset))
end

"""Locations where object occurs in grid"""
function occurrences(grid::Grid, object::Object)::Indices
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
function extract(container::IntContainer, condition)::Unsafe(Integer)
    idx = findfirst(condition, container)
    return idx === nothing ? nothing : container[idx]
end

function extract(container::Objects, condition)::Unsafe(Object)
    idx = findfirst(condition, container)
    return idx === nothing ? nothing : container[idx]
end

function extract(container::GridContainer, condition)::Unsafe(Grid)
    idx = findfirst(condition, container)
    return idx === nothing ? nothing : container[idx]
end

"""Return first element of a container"""
firstof(container::Indices)::Unsafe(IntegerTuple) = !isempty(container) ? first(container) : nothing
firstof(container::Objects)::Unsafe(Object) = !isempty(container) ? first(container) : nothing
firstof(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? first(container) : nothing
firstof(container::GridContainer)::Unsafe(Grid) = !isempty(container) ? first(container) : nothing

"""Return last element of a container"""
lastof(container::Indices)::Unsafe(IntegerTuple) = !isempty(container) ? last(container) : nothing
lastof(container::Objects)::Unsafe(Object) = !isempty(container) ? last(container) : nothing
lastof(container::IntContainer)::Unsafe(Integer) = !isempty(container) ? last(container) : nothing
lastof(container::GridContainer)::Unsafe(Grid) = !isempty(container) ? last(container) : nothing

"""Insert element to container"""
insert(value::IntegerTuple, container::Indices)::Indices = push!(copy(container), value)
insert(value::Object, container::Objects)::Objects = push!(copy(container), value)
insert(value::Integer, container::IntContainer)::IntContainer = push!(copy(container), value)

"""Remove value from container"""
remove(value::IntegerTuple, container::Indices)::Indices = filter(!=(value), container)
remove(value::Object, container::Objects)::Objects = filter(!=(value), container)
remove(value::Integer, container::IntContainer)::IntContainer = filter(!=(value), container)

"""Returns other value in container, i.e., first element after removing given value"""
other(value::IntegerTuple, container::Indices)::Unsafe(IntegerTuple) = firstof(remove(value, container))
other(value::Object, container::Objects)::Unsafe(Object) = firstof(remove(value, container))
other(value::Integer, container::IntContainer)::Unsafe(Integer) = firstof(remove(value, container))

"""Returns range between start and stop with given step size"""
interval(start::Integer, stop::Integer, step::Integer)::Unsafe(IntContainer) = step != 0 ? collect(range(start, stop, step=step)) : nothing

"""Cartesian product of two containers a and b"""
cartesian_product(a::IntContainer, b::IntContainer)::Indices = vec(collect(CartesianIndex.(Iterators.product(a, b))))

"""Zip up two CartesianIndex"""
pair(a::IntegerTuple, b::IntegerTuple)::Indices = collect(CartesianIndex.(zip(a.I, b.I)))

# note: some primitives below wouldn't be necessary in Herb

"""if-else condition"""
branch(condition::Boolean, a::Integer, b::Integer)::Integer = condition ? a : b
branch(condition::Boolean, a::IntegerTuple, b::IntegerTuple)::IntegerTuple = condition ? a : b
branch(condition::Boolean, a::Object, b::Object)::Object = condition ? a : b
branch(condition::Boolean, a::Objects, b::Objects)::Objects = condition ? a : b
branch(condition::Boolean, a::Indices, b::Indices)::Indices = condition ? a : b
branch(condition::Boolean, a::Grid, b::Grid)::Grid = condition ? a : b

"""Apply function to each element in container"""
apply_obj_to_obj(func, container::Objects)::Objects = map(func, container)
apply_obj_to_int(func, container::Objects)::IntContainer = map(func, container)

"""Apply each function in container to a value"""
# rapply(container, value) = [f(value) for f in container] # not included in grammar since it can't construct container of functions

"""Apply and merge"""
function mapply(func, container::Union{Indices,Objects})::Unsafe(Indices)
    isempty(container) && return []
    res = map(func, container)
    any(isnothing, res) && return nothing
    return reduce(vcat, res)
end

"""Apply function on two vectors a and b"""
# papply(func, a, b) = func.(a, b) # not included in grammar - only works if a and be are the same length (hard to guarantee in search)

"""""Apply function on two vectors and merge"""
# mpapply(func, a, b) = merge_containers(papply(func, a, b)) # not included (see papply())

"""apply function on cartesian product"""
# prapply(func, a, b) = [func(i, j) for j in b for i in a] # not included in grammar

"""Compose a function from inner and outer"""
# compose(outer, inner) = x -> outer(inner(x)) # not included in grammar

"""Compose from three functions by chaining: h(g(f(x)))"""
# chain(h, g, f) = x -> h(g(f(x))) # not included in grammar

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