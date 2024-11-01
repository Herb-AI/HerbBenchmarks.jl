using HerbBenchmarks.ARC_DSL

@testset verbose = true "Basic arithmetic operators" begin
    @testset verbose = true "identity" begin
        @test identityfun(1) == 1
        # @test identity("Herb.jl rocks") == "Herb.jl rocks"
        # @test identity((3, 6)) == (3, 6)
        # @test identity(1.0) == 1 
    end
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
end