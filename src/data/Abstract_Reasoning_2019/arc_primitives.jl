# Define a struct to represent the grid
struct Grid
    width::Int
    height::Int
    data::Matrix{Int}
end

Grid(mat::Matrix{Int}) = Grid(size(mat)..., mat)


function initState(raw_grid::Vector{Int})
    return Grid(array_to_matrix(raw_grid))
end

"""
Helper function to transform the input vector to a matrix of square form. If length is not a squared integer, then iteratively adjust the factors a,b such that a<b and `a*b = length(input_array)`
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

function returnState(grid::Grid)
    return (grid.mat')[:] # transform and flatten matrix
end

# Initialize a grid with zeros
function init_grid(width::Int, height::Int)
    return Grid(width, height, zeros(Int, height, width))
end


# Clone a grid
function clone_grid(grid::Grid)
    return Grid(grid.width, grid.height, copy(grid.data))
end

# Resize the grid
function resize_grid(grid::Grid, new_width::Int, new_height::Int)
    new_grid = clone_grid(grid)
    new_data = zeros(Int, new_height, new_width)
    for i in 1:min(grid.height, new_height), j in 1:min(grid.width, new_width)
        new_data[i, j] = grid.data[i, j]
    end
    return Grid(new_data)
end

# Copy grid content
function copy_from_input(source::Grid)
    return clone_grid(source)
end

# Reset the grid to zeros
function reset_grid(grid::Grid)
    new_grid = clone_grid(grid)
    fill!(new_grid.data, 0)
    return new_grid
end

# Set a cell's color (value)
function set_cell(grid::Grid, row::Int, col::Int, color::Int)
    new_grid = clone_grid(grid)
    new_grid.data[row, col] = color
    return new_grid
end

# Select function to return a list of coordinates within a rectangle (defined by top-left and bottom-right corners). 
function select(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int)
    selected_cells = []
    if start_row > end_row || start_col > end_col
        return selected_cells
    end

    for i in start_row:min(end_row, grid.height), j in start_col:min(end_col, grid.width)
        push!(selected_cells, (i, j))
    end
    return selected_cells
end

# Distinguish between two cases, as you cannot paste from arbitrary previous grids, but just the current one
# Select and paste from the input grid to the same grid
function select_and_paste(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(grid)
    for (i, row) in enumerate(start_row:end_row) # TODO: can this be done better?
        for (j, col) in enumerate(start_col:end_col)
            new_grid.data[paste_row+i-1, paste_col+j-1] = grid.data[row, col]
        end
    end
    return new_grid
end

# Select and paste from an input grid to a target grid
function select_and_paste(input_grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, target_grid::Grid, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(target_grid)
    for (i, row) in enumerate(start_row:end_row)
        for (j, col) in enumerate(start_col:end_col)
            new_grid.data[paste_row+i-1, paste_col+j-1] = input_grid.data[row, col]
        end
    end

    return new_grid

end

"""
Applies the floodfill algorithm to a Grid. The algorithm starts with the cell at the given row and column and changes the color of all connected cells to the given color.
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
