"""
    Row index of lowermost occupied cell
"""
function lowermost(object::Vector{<:Tuple})
    return maximum(x[2][1] for x in object)
end

function lowermost(indices)
    return maximum(x[1] for x in indices)
end


"""
    Row index of uppermost occupied cell
"""
function uppermost(object::Vector{<:Tuple})
    return minimum(x[2][1] for x in object)
end

function uppermost(indices)
    return minimum(x[1] for x in indices)
end


"""
    Row index of rightmost occupied cell
"""
function rightmost(object::Vector{<:Tuple})
    return maximum(x[2][2] for x in object)
end

function rightmost(indices)
    return maximum(x[2] for x in indices)
end


"""
    Row index of leftmost occupied cell
"""
function leftmost(object::Vector{<:Tuple})
    return minimum(x[2][2] for x in object)
end

function leftmost(indices)
    return minimum(x[2] for x in indices)
end


"""
    Height of grid or patch
"""
function height(grid::Matrix)
    return size(grid)[1] # TODO
end

function height(patch)
    return lowermost(patch) - uppermost(patch) + 1
end

"""
    Width of grid or patch
"""
function width(grid::Matrix)
    return size(grid)[2] # TODO
end

function width(patch)
    return rightmost(patch) - leftmost(patch) + 1
end

"""
    Dimensions (height and width) of grid or patch
"""
function shape(piece)
    return (height(piece), width(piece))
end

"""
    Whether height is greater than width
"""
function portrait(piece)
    return height(piece) > width(piece)
end

"""
    Whether the piece forms a squaer
"""
function square(grid::Matrix)
    return height(grid) == width(grid)
end

function square(patch)
    h = height(patch)
    w = width(patch)
    return h == w && h * w == length(patch)
end

"""
    Whether the piece forms a vertical line
"""
function vline(piece)
    return height(piece) == length(piece) && width(piece) == 1
end

"""
    Whether the piece forms a horizontal line. 
    
"""
function hline(piece)
    return width(piece) == length(piece) && height(piece) == 1
end

"""
    Returns the most common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
function mostcolor(grid::Matrix)
    return findmax(countmap(grid))[2]
end

function mostcolor(object)
    return findmax(countmap(x[1] for x in object))[2]
end

"""
    Returns the least common colour. If there is a tie, the first value in the iteration order
    of the dictionary is returned. Note that the order is not guaranteed. 
"""
function leastcolor(grid::Matrix)
    return findmin(countmap(grid))[2]
end

function leastcolor(object)
    return findmin(countmap(x[1] for x in object))[2]
end

"""
    Number of cells with given color value.
"""
function colorcount(grid::Matrix, value)
    return count(==(value), grid)
end

function colorcount(element, value)
    return count(==(value), x[1] for x in element)
end

"""
    Filters objects by color value. An object is included if its first element matches the color value.
"""
function colorfilter(objects, value)
    # TODO: The Python implementation checks first element to `obj` only. Unclear if intended this way.
    return [obj for obj in objects if first(obj[1]) == value]
end

"""
    Return container with only elements of given size.
"""
function sizefilter(container, size)
    return [x for x in container if length(x) == size]
end

"""
    Crop grid from `start` point to given `dims`.
"""
function crop(grid, start, dims)
    row = start[1]
    col = start[2]
    nrows, ncols = dims
    return grid[row:row+nrows-1, col:col+ncols-1]
end

"""
    Recolor patch to given color value.
"""
function recolor(value, object::Vector{<:Tuple})
    return [(value, ind) for ind in toindices(object)]
end

function recolor(value, indices)
    return [(value, ind) for ind in indices]
end

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

"""
    Moves top left corner to origin
"""
function normalize(patch)
    if isempty(patch)
        return patch
    end
    return shift(patch, (-uppermost(patch), -leftmost(patch)))
end

"""
    Indices of directly adjacent neighbours of a location `loc`. 4-connectivity.
"""
function dneighbors(loc)
    # out-of-bound/negative indices possible => intended?
    offsets = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1))
    return [loc + off for off in offsets]
end

"""
    Diagonally adjacent indices of a location.
"""
function ineighbors(loc)
    offsets = (CartesianIndex(-1, -1), CartesianIndex(-1, 1), CartesianIndex(1, -1), CartesianIndex(1, 1))
    return [loc + off for off in offsets]
end

"""
    All adjacent indices of a location. 8-connectivity.
"""
function neighbors(loc)
    return [dneighbors(loc); ineighbors(loc)]
end

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

"""
    All color in object or grid
"""
function palette(grid::Matrix)
    return unique(grid)
end

function palette(object)
    return unique([v[1] for v in object])
end
# element: object or grid => object (vector of cells)