using StaticArrays
using .ARC_DSL: rot180, replace

# D = ((1, 2, 3), (4, 5, 6), (7, 8, 0))
# D = ((1, 2, 3), (4, 5, 6), (7, 8, 0))
# E = ((1, 2), (4, 5))
# F = ((5, 6), (8, 0))
# G = (
#     (1, 0, 0, 0, 3),
#     (0, 1, 1, 0, 0),
#     (0, 1, 1, 2, 0),
#     (0, 0, 2, 2, 0),
#     (0, 2, 0, 0, 0),
# )
# H = (
#     (0, 0, 0, 0, 0),
#     (0, 2, 0, 2, 0),
#     (2, 0, 0, 2, 0),
#     (0, 0, 0, 0, 0),
#     (0, 0, 2, 0, 0),
# )
# I = (
#     (0, 0, 2, 0, 0),
#     (0, 2, 0, 2, 0),
#     (2, 0, 0, 2, 0),
#     (0, 2, 0, 2, 0),
#     (0, 0, 2, 0, 0),
# )
# J = (
#     (0, 0, 2, 0, 0),
#     (0, 2, 0, 2, 0),
#     (0, 0, 2, 2, 0),
#     (0, 2, 0, 2, 0),
#     (0, 0, 2, 0, 0),
# )
# K = (
#     (0, 0, 1, 0, 0, 1, 0, 0),
#     (0, 0, 1, 0, 0, 1, 0, 0),
#     (1, 1, 1, 1, 1, 1, 1, 1),
#     (0, 0, 1, 0, 0, 1, 0, 0),
#     (0, 0, 1, 0, 0, 1, 0, 0),
#     (1, 1, 1, 1, 1, 1, 1, 1),
#     (0, 0, 1, 0, 0, 1, 0, 0),
#     (0, 0, 1, 0, 0, 1, 0, 0),
# )

@testset verbose = true "Grid operations" begin
    A = Grid([1 0; 0 1; 1 0])
    B = Grid([2 1; 0 1; 2 1])
    C = Grid([3 4; 5 5])
    D = Grid([1 2 3; 4 5 6; 7 8 0])
    E = Grid([1 2; 4 5])
    F = Grid([5 6; 8 0])
    G = Grid(
        [1 0 0 0 3;
            0 1 1 0 0;
            0 1 1 2 0;
            0 0 2 2 0;
            0 2 0 0 0]
    )
    K = Grid(
        [0 0 1 0 0 1 0 0;
            0 0 1 0 0 1 0 0;
            1 1 1 1 1 1 1 1;
            0 0 1 0 0 1 0 0;
            0 0 1 0 0 1 0 0;
            1 1 1 1 1 1 1 1;
            0 0 1 0 0 1 0 0;
            0 0 1 0 0 1 0 0]
    )
    H = Grid(
        [0 0 0 0 0;
            0 2 0 2 0;
            2 0 0 2 0;
            0 0 0 0 0;
            0 0 2 0 0]
    )

    @testset "isequal and hash" begin
        A_dup = Grid([1 0; 0 1; 1 0])
        @test isequal(A, A_dup) == true
        @test isequal(A, B) == false
        @test hash(A) == hash(A_dup)
        @test hash(A) != hash(B)
    end

    @testset "as indices" begin
        expected_indices =
            Indices([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(2, 1),
                CartesianIndex(2, 2),
                CartesianIndex(3, 1),
                CartesianIndex(3, 2),
            ])
        @test asindices(A) == expected_indices
        expected_indices =
            Indices([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(2, 1),
                CartesianIndex(2, 2),
            ])
        @test ARC_DSL.asindices(C) == expected_indices
    end
    @testset "ofcolor" begin
        # TODO: reminder CartesianIndex(row, col)
        #  A = Grid([1 0; 0 1; 1 0])
        @test ofcolor(A, 0) == Indices([CartesianIndex(1, 2), CartesianIndex(2, 1), CartesianIndex(3, 2)])
        @test ofcolor(B, 2) == Indices([CartesianIndex(1, 1), CartesianIndex(3, 1)])
        @test ofcolor(C, 1) == Indices()
    end
    @testset "grid rotations" begin
        # 90 deg clockwise
        @test rot90(B) == Grid([2 0 2; 1 1 1])
        @test rot90(C) == Grid([5 3; 5 4])


        # 180 deg
        #  C = Grid([3 4; 5 5])
        @test rot180(B) == Grid([1 2; 1 0; 1 2])
        @test rot180(B) == rot90(rot90(B))
        @test rot180(C) == Grid([5 5; 4 3])

        # 270 deg
        @test rot270(B) == Grid([1 1 1; 2 0 2])
        @test rot270(C) == Grid([4 5; 3 5])
    end
    @testset "up- and downscale" begin
        @test downscale(B, 1) == B
        @test downscale(C, 1) == C
        B2 = Grid([2 2 1 1; # TODO: rename grid
            2 2 1 1;
            0 0 1 1;
            0 0 1 1;
            2 2 1 1;
            2 2 1 1])
        @test downscale(B2, 2) == B
        C2 = Grid([3 3 4 4;
            3 3 4 4;
            5 5 5 5;
            5 5 5 5])
        @test downscale(C2, 2) == C
        # TODO: should Grid() work on Vector as well (e.g. for only one element)
        # @test downscale(A, 4) == Grid(SMatrix([1; 0; 1]))
        @test downscale(B2, 3) == Grid([2 1; 0 1])

        # upscale horizontally
        @test hupscale(B, 1) == B
        @test hupscale(C, 1) == C
        @test hupscale(B, 2).mat == [2 2 1 1; 0 0 1 1; 2 2 1 1]
        @test hupscale(C, 2).mat == [3 3 4 4; 5 5 5 5]
        @test hupscale(A, 3).mat == [1 1 1 0 0 0; 0 0 0 1 1 1; 1 1 1 0 0 0]

        # upscale verticallydef test_vupscale():
        @test vupscale(B, 1) == B
        @test vupscale(C, 1) == C
        @test vupscale(B, 2).mat == [2 1; 2 1; 0 1; 0 1; 2 1; 2 1]
        @test vupscale(C, 2).mat == [3 4; 3 4; 5 5; 5 5]
        @test vupscale(A, 3).mat == [1 0; 1 0; 1 0; 0 1; 0 1; 0 1; 1 0; 1 0; 1 0]
    end
    @testset "concatenate grids" begin
        # hcat
        @test hconcat(A, B) == Grid([1 0 2 1; 0 1 0 1; 1 0 2 1])
        @test hconcat(B, A) == Grid([2 1 1 0; 0 1 0 1; 2 1 1 0])

        # vcat
        @test vconcat(A, B) == Grid([1 0; 0 1; 1 0; 2 1; 0 1; 2 1])
        @test vconcat(B, A) == Grid([2 1; 0 1; 2 1; 1 0; 0 1; 1 0])
        @test vconcat(B, C) == Grid([2 1; 0 1; 2 1; 3 4; 5 5])
    end

    @testset "split grid" begin
        # TODO: what's the purpose of hsplit returning tuples?
        # def test_hsplit():
        #     assert hsplit(B, 1) == (B,)
        #     assert hsplit(B, 2) == (((2,), (0,), (2,)), ((1,), (1,), (1,)))
        #     assert hsplit(C, 1) == (C,)
        #     assert hsplit(C, 2) == (((3,), (5,)), ((4,), (5,)))
    end
    @testset "cellwise, replace, switch" begin
        # cellwise
        @test cellwise(A, B, 0) == Grid([0 0; 0 1; 0 0])
        @test cellwise(C, E, 0) == Grid([0 0; 0 5])

        #replace   
        @test replace(A, 1, 1) == A
        @test replace(B, 2, 3) == Grid([3 1; 0 1; 3 1])
        @test replace(C, 5, 0) == Grid([3 4; 0 0])

        # switch
        @test switch(A, 1, 1) == A
        @test switch(A, 1, 0) == Grid([0 1; 1 0; 0 1])
        @test switch(C, 3, 4) == Grid([4 3; 5 5])
    end
    @testset "trim, tophalf, bottomhalf, lefthalf, righthalf" begin
        # trim
        mat = @SMatrix [UInt8(5)]
        @test trim(D) == Grid(mat)
        @test trim(G) == Grid([1 1 0; 1 1 2; 0 2 2])

        # tophalf and bottomhalf
        @test tophalf(C) == Grid([3 4;])
        @test tophalf(D) == Grid([1 2 3;])

        @test bottomhalf(C) == Grid([5 5])
        @test bottomhalf(D) == Grid([7 8 0])
        @test bottomhalf(G) == Grid([0 0 2 2 0;
            0 2 0 0 0])

        # lefthalf and righthalf
        v = reshape([3, 5], :, 1)  # 2×1 column vector
        @test lefthalf(C) == Grid(v)
        @test lefthalf(D) == Grid(reshape([1, 4, 7], :, 1))
        @test lefthalf(G) == Grid([1 0; 0 1; 0 1; 0 0; 0 2])

        @test righthalf(C) == Grid(reshape([4, 5], :, 1))
        @test righthalf(D) == Grid(reshape([3, 6, 0], :, 1))
        @test righthalf(G) == Grid([0 3; 0 0; 2 0; 2 0; 0 0])

        # A = Grid([1 0; 0 1; 1 0])
        # B = Grid([2 1; 0 1; 2 1])
        # C = Grid([3 4; 5 5])
        # D = Grid([1 2 3; 4 5 6; 7 8 0])
        # E = Grid([1 2; 4 5])
        # G = Grid(
        #     [1 0 0 0 3;
        #         0 1 1 0 0;
        #         0 1 1 2 0;
        #         0 0 2 2 0;
        #         0 2 0 0 0]
        # )
        #      K = Grid(
        #        [0 0 1 0 0 1 0 0;
        #         0 0 1 0 0 1 0 0;
        #         1 1 1 1 1 1 1 1;
        #         0 0 1 0 0 1 0 0;
        #         0 0 1 0 0 1 0 0;
        #         1 1 1 1 1 1 1 1;
        #         0 0 1 0 0 1 0 0;
        #         0 0 1 0 0 1 0 0]
        # )
    end
    @testset "compress" begin
        # compress
        expected_K = Grid(
            [0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0]
        )
        expected_H = Grid(
            [0 2 0 2;
                2 0 0 2;
                0 0 2 0]
        )
        @test compress(K) == expected_K
        @test compress(H) == expected_H
    end
end
