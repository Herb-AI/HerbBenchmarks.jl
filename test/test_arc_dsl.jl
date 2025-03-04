using HerbBenchmarks.ARC_DSL

# Define test constants
A = ((1, 0), (0, 1), (1, 0))
B = ((2, 1), (0, 1), (2, 1))



@testset verbose = true "Basic operators" begin
    # @testset verbose = true "identity" begin
    #     @test identity(1) == 1
    #     @test identity("Herb.jl rocks") == "Herb.jl rocks"
    #     @test identity((3, 6)) == (3, 6)
    #     @test identity(1.0) == 1 
    # end
    @testset verbose = true "add" begin
        # Integer
        @test add(1, 2) == 3
        @test add(4, 6) == 10

        # IntegerTuple
        @test add((1, 2), (3, 4)) == (4, 6)

        # Integer and IntegerTuple
        @test add(9, (1, 1)) == (10, 10)
        @test_throws MethodError add(9, (1, 1, 1))
    end
    @testset verbose = true "subtract" begin
        # Integer
        @test subtract(10, 1) == 9
        # IntegerTuple
        @test subtract((8, 9), (3, 4)) == (5, 5)
        # Integer and IntegerTuple
        @test subtract(5, (10, 6)) == (-5, -1) # TODO: we probably want to avoid negative numbers
        @test subtract(5, (1, 2)) == (4, 3)
        # IntegerTuple and Integer
        @test subtract((5,5), 4) == (1, 1)
    end
    @testset verbose = true "multiply" begin
        # Integers
        @test multiply(2, 3) == 6
        @test multiply(4, 3) == 12
        # Integer tuples
        @test multiply((2, 3), (4, 3)) == (8, 9)
        @test_throws MethodError multiply((1, 1, 1), (2, 2, 2))
        # Integer and integer tuple
        @test multiply(2, (3, 4)) == (6, 8)
        @test multiply((3, 4), 2) == (6, 8)
    end
    @testset verbose = true "divide" begin
        # Integers
        @test divide(4, 2) == 2
        @test divide(3, 2) == 1
        # Integer tuples
        @test divide((10, 6), (5, 2)) == (2, 3)
        # Integer and integer tuple
        @test divide((10, 10), 3) == (3, 3) 
        @test divide(10, (2, 4)) == (5, 2) 
        @test divide(3, (10, 10)) == (0, 0)
    end
    @testset verbose = true "invert" begin
        @test invert(1) == -1
        @test invert(-4) == 4
        # Integer tuple
        @test invert((5, 6)) == (-5, -6)
        @test invert((-1, 9)) == (1, -9)
    end
    @testset verbose = true "even" begin
        @test even(1) == false
        @test even(2) == true
    end
    @testset verbose = true "double and halve" begin
        # double
        @test double(1) == 2
        @test double((2, 3)) == (4, 6)

        # halve
        @test halve(2) == 1
        @test halve(5) == 2
        @test halve((10, 9)) == (5, 4)
    end
    @testset verbose = true "flip, equality" begin
        @test flip(false) == true
        @test flip(true) == false
        @test equality(A, A) == true
        @test equality(A, B) == false
    end
end


# IntegerTuple = Tuple{Int, Int}
# IntegerSet = Set([Int])
# Grid = Tuple{Tuple{Int}} = (
# (0, 0, 0)
# (1, 0, 3)
# )
# Cell = Tuple{Int, Tuple{Int, Int}} = (3, (1, 2)) # (color, (x, y))
# Object = Set([Cell])
# Objects = Set([Objects])
# Indices = Set([Tuple{Int, Int}])
# IndicesSet = Set([Indices]) = Set([Tuple{Int, Int}])
# Patch = Union{Object, Indices}
# Element = Union{Object, Grid}
# Piece = Union{Grid, Patch}
# TupleTuple = Tuple{Tuple}
# ContainerContainer = Container[Container]