# Define a struct to represent the grid
struct Grid
    width::Int
    height::Int
    data::Matrix{Int}
end

Grid(mat::Matrix{Int}) = Grid(size(mat)..., mat)