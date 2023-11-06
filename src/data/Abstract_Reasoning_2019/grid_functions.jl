# Define a struct to represent the grid
struct Grid
    width::Int
    height::Int
    data::Matrix{Int}
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
    new_grid.width = new_width
    new_grid.height = new_height
    new_grid.data = new_data
    return new_grid
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

# Select function to return a list of coordinates within a rectangle
function select(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int)
    selected_cells = []
    #@TODO add check such that start_* < end_*
    for i in start_row:min(end_row, grid.height), j in start_col:min(end_col, grid.width)
        push!(selected_cells, (i, j))
    end
    return selected_cells
end

# Distinguish between two cases, as you cannot paste from arbitrary previous grids, but just the current one
function select_and_paste(grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(grid)
    selected_cells = select(grid, start_row, start_col, end_row, end_col)
    for (i,j) in selected_cells
        new_grid[paste_row+i-1, paste_col+j-1] = grid[i,j]
    end
    return new_grid
end

function select_and_paste(input_grid::Grid, start_row::Int, start_col::Int, end_row::Int, end_col::Int, target_grid::Grid, paste_row::Int, paste_col::Int)
    new_grid = clone_grid(target_grid)
    selected_cells = select(input_grid, start_row, start_col, end_row, end_col)
    for (i,j) in selected_cells
        new_grid[paste_row+i-1, paste_col+j-1] = input_grid[i,j]
    end
    return new_grid
end

# Floodfill function to fill all connected cells with a new value
function floodfill(grid::Grid, row::Int, col::Int, color::Int)
    old_value = grid.data[row, col]
    if old_value == color
        return grid
    end

    new_grid = clone_grid(grid)
    function floodfill_recursive(r, c)
        if r < 1 || r > new_grid.height || c < 1 || c > new_grid.width || new_grid.data[r, c] != old_value
            return
        end
        new_grid.data[r, c] = color
        floodfill_recursive(r-1, c)
        floodfill_recursive(r+1, c)
        floodfill_recursive(r, c-1)
        floodfill_recursive(r, c+1)
    end

    floodfill_recursive(row, col)
    return new_grid
end
