using HerbBenchmarks.Abstract_Reasoning_2019

@testset "Abstract_Reasoning_2019: Grid struct" begin
    # Test Grid struct
    mat = [1 2 3; 4 5 6; 7 8 9]
    grid = Grid(mat)
    @test grid.width == 3
    @test grid.height == 3
    @test grid.data == mat

    # Test initialise grid state
    vec = collect(1:9)
    grid = Abstract_Reasoning_2019.initState(vec)
    @test grid.width == 3
    @test grid.height == 3
    @test grid.data == [1 2 3; 4 5 6; 7 8 9]

    # Test array_to_matrix
    vec = collect(1:10)
    mat = Abstract_Reasoning_2019.array_to_matrix(vec)
    @test size(mat) == (3, 4)

    # Test initialise grid with zeros
    grid = Abstract_Reasoning_2019.init_grid(3, 3)
    @test grid.width == 3
    @test grid.height == 3
    @test sum(grid.data) == 0

    # Test resize grid
    mat = [0 1 0; 1 0 1; 1 1 1]
    grid = Grid(mat)
    new_grid = Abstract_Reasoning_2019.resize_grid(grid, 5, 5)
    @test new_grid.width == 5
    @test new_grid.height == 5
    @test new_grid.data[1:3, 1:3] == mat
    @test all(new_grid.data[end-1:end, end-1:end] .== 0)
end