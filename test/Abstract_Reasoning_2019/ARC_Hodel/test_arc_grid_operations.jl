import HerbBenchmarks.Abstract_Reasoning_2019.ARC_Hodel as ARC_Hodel

@testset verbose = true "Grid operations" begin
    A = [1 0; 0 1; 1 0]
    B = [2 1; 0 1; 2 1]
    C = [3 4; 5 5]
    D = [1 2 3; 4 5 6; 7 8 0]
    E = [1 2; 4 5]
    F = [5 6; 8 0]
    G = [1 0 0 0 3;
        0 1 1 0 0;
        0 1 1 2 0;
        0 0 2 2 0;
        0 2 0 0 0]
    H = [0 0 0 0 0;
        0 2 0 2 0;
        2 0 0 2 0;
        0 0 0 0 0;
        0 0 2 0 0]
    I = [
        0 0 2 0 0;
        0 2 0 2 0;
        2 0 0 2 0;
        0 2 0 2 0;
        0 0 2 0 0
    ]
    J = [
        0 0 2 0 0;
        0 2 0 2 0;
        0 0 2 2 0;
        0 2 0 2 0;
        0 0 2 0 0
    ]
    K = [0 0 1 0 0 1 0 0;
        0 0 1 0 0 1 0 0;
        1 1 1 1 1 1 1 1;
        0 0 1 0 0 1 0 0;
        0 0 1 0 0 1 0 0;
        1 1 1 1 1 1 1 1;
        0 0 1 0 0 1 0 0;
        0 0 1 0 0 1 0 0]

    @testset "isequal and hash" begin # TODO: do we still need these?
        A_dup = [1 0; 0 1; 1 0]
        @test ARC_Hodel.isequal(A, A_dup) == true
        @test ARC_Hodel.isequal(A, B) == false
        @test ARC_Hodel.hash(A) == ARC_Hodel.hash(A_dup)
        @test ARC_Hodel.hash(A) != ARC_Hodel.hash(B)
    end

    @testset "as indices" begin
        expected_indices = [
            CartesianIndex(1, 1) CartesianIndex(1, 2);
            CartesianIndex(2, 1) CartesianIndex(2, 2);
            CartesianIndex(3, 1) CartesianIndex(3, 2)
        ]
        @test collect(ARC_Hodel.asindices(A)) == expected_indices

        expected_indices = [
            CartesianIndex(1, 1) CartesianIndex(1, 2);
            CartesianIndex(2, 1) CartesianIndex(2, 2)
        ]
        @test collect(ARC_Hodel.asindices(C)) == expected_indices
    end
    @testset "ofcolor" begin
        @test Set(ARC_Hodel.ofcolor(A, 0)) == Set([CartesianIndex(1, 2), CartesianIndex(2, 1), CartesianIndex(3, 2)])
        @test Set(ARC_Hodel.ofcolor(B, 2)) == Set([CartesianIndex(1, 1), CartesianIndex(3, 1)])
        @test ARC_Hodel.ofcolor(C, 1) == []
    end
    @testset "grid rotations" begin
        # 90 deg clockwise
        @test ARC_Hodel.rot90deg(B) == [2 0 2; 1 1 1]
        @test ARC_Hodel.rot90deg(C) == [5 3; 5 4]


        # 180 deg
        #  C = Grid([3 4; 5 5])
        @test ARC_Hodel.rot180deg(B) == [1 2; 1 0; 1 2]
        @test ARC_Hodel.rot180deg(B) == ARC_Hodel.rot90deg(ARC_Hodel.rot90deg(B))
        @test ARC_Hodel.rot180deg(C) == [5 5; 4 3]

        # 270 deg
        @test ARC_Hodel.rot270deg(B) == [1 1 1; 2 0 2]
        @test ARC_Hodel.rot270deg(C) == [4 5; 3 5]
    end
    @testset "up- and downscale" begin
        @test ARC_Hodel.downscale(B, 1) == B
        @test ARC_Hodel.downscale(C, 1) == C
        B2 = [2 2 1 1; # TODO: rename grid
            2 2 1 1;
            0 0 1 1;
            0 0 1 1;
            2 2 1 1;
            2 2 1 1]
        @test ARC_Hodel.downscale(B2, 2) == B
        C2 = [3 3 4 4;
            3 3 4 4;
            5 5 5 5;
            5 5 5 5]
        @test ARC_Hodel.downscale(C2, 2) == C
        # TODO: should Grid() work on Vector as well (e.g. for only one element)
        # @test downscale(A, 4) == Grid(SMatrix([1; 0; 1]))
        @test ARC_Hodel.downscale(B2, 3) == [2 1; 0 1]

        # upscale horizontally
        @test ARC_Hodel.hupscale(B, 1) == B
        @test ARC_Hodel.hupscale(C, 1) == C
        @test ARC_Hodel.hupscale(B, 2) == [2 2 1 1; 0 0 1 1; 2 2 1 1]
        @test ARC_Hodel.hupscale(C, 2) == [3 3 4 4; 5 5 5 5]
        @test ARC_Hodel.hupscale(A, 3) == [1 1 1 0 0 0; 0 0 0 1 1 1; 1 1 1 0 0 0]

        # upscale verticallydef test_vupscale():
        @test ARC_Hodel.vupscale(B, 1) == B
        @test ARC_Hodel.vupscale(C, 1) == C
        @test ARC_Hodel.vupscale(B, 2) == [2 1; 2 1; 0 1; 0 1; 2 1; 2 1]
        @test ARC_Hodel.vupscale(C, 2) == [3 4; 3 4; 5 5; 5 5]
        @test ARC_Hodel.vupscale(A, 3) == [1 0; 1 0; 1 0; 0 1; 0 1; 0 1; 1 0; 1 0; 1 0]
    end
    @testset "concatenate grids" begin
        # hcat
        @test ARC_Hodel.hconcat(A, B) == [1 0 2 1; 0 1 0 1; 1 0 2 1]
        @test ARC_Hodel.hconcat(B, A) == [2 1 1 0; 0 1 0 1; 2 1 1 0]

        # vcat
        @test ARC_Hodel.vconcat(A, B) == [1 0; 0 1; 1 0; 2 1; 0 1; 2 1]
        @test ARC_Hodel.vconcat(B, A) == [2 1; 0 1; 2 1; 1 0; 0 1; 1 0]
        @test ARC_Hodel.vconcat(B, C) == [2 1; 0 1; 2 1; 3 4; 5 5]
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
        @test ARC_Hodel.cellwise(A, B, 0) == [0 0; 0 1; 0 0]
        @test ARC_Hodel.cellwise(C, E, 0) == [0 0; 0 5]

        #replace   
        @test ARC_Hodel.replace(A, 1, 1) == A
        @test ARC_Hodel.replace(B, 2, 3) == [3 1; 0 1; 3 1]
        @test ARC_Hodel.replace(C, 5, 0) == [3 4; 0 0]

        # switch
        @test ARC_Hodel.switch(A, 1, 1) == A
        @test ARC_Hodel.switch(A, 1, 0) == [0 1; 1 0; 0 1]
        @test ARC_Hodel.switch(C, 3, 4) == [4 3; 5 5]
    end
    @testset "trim, tophalf, bottomhalf, lefthalf, righthalf" begin
        # trim
        @test ARC_Hodel.trim(D) == [5;;]
        @test ARC_Hodel.trim(G) == [1 1 0; 1 1 2; 0 2 2]

        # tophalf and bottomhalf
        @test ARC_Hodel.tophalf(C) == [3 4;]
        @test ARC_Hodel.tophalf(D) == [1 2 3;]

        @test ARC_Hodel.bottomhalf(C) == [5 5]
        @test ARC_Hodel.bottomhalf(D) == [7 8 0]
        @test ARC_Hodel.bottomhalf(G) == [0 0 2 2 0;
            0 2 0 0 0]

        # lefthalf and righthalf
        v = reshape([3, 5], :, 1)  # 2×1 column vector
        @test ARC_Hodel.lefthalf(C) == v
        @test ARC_Hodel.lefthalf(D) == [1; 4; 7;;]
        @test ARC_Hodel.lefthalf(G) == [1 0; 0 1; 0 1; 0 0; 0 2]

        @test ARC_Hodel.righthalf(C) == [4; 5;;]
        @test ARC_Hodel.righthalf(D) == [3; 6; 0;;]
        @test ARC_Hodel.righthalf(G) == [0 3; 0 0; 2 0; 2 0; 0 0]
    end
    @testset "compress" begin
        # compress
        expected_K = [0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 0]

        expected_H = [0 2 0 2;
            2 0 0 2;
            0 0 2 0]

        @test ARC_Hodel.compress(K) == expected_K
        @test ARC_Hodel.compress(H) == expected_H
    end
    @testset "canvas" begin
        @test ARC_Hodel.canvas(3, CartesianIndex(1, 2)) == [3 3]
        @test ARC_Hodel.canvas(2, CartesianIndex(3, 1)) == fill(2, 3, 1)
        @test ARC_Hodel.canvas(7, CartesianIndex(3, 3)) == [7 7 7; 7 7 7; 7 7 7]
    end
    @testset "index" begin
        @test ARC_Hodel.index(C, CartesianIndex(1, 1)) == 3
        @test ARC_Hodel.index(D, CartesianIndex(2, 3)) == 6
    end

    @testset "crop" begin
        @test ARC_Hodel.crop(A, CartesianIndex(1, 1), CartesianIndex(2, 2)) == [1 0; 0 1]
        @test ARC_Hodel.crop(C, CartesianIndex(1, 2), CartesianIndex(1, 1)) == [4;;]
        @test ARC_Hodel.crop(D, CartesianIndex(2, 3), CartesianIndex(2, 1)) == [6; 0;;]
    end
    @testset "ulcorner, urcorner, llcorner, rrcorner" begin
        # ulcorner
        indices_1 = [CartesianIndex(2, 3), CartesianIndex(1, 4), CartesianIndex(5, 1)]
        indices_2 = [CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(5, 4)]
        indices_3 = [CartesianIndex(2, 6), CartesianIndex(1, 1), CartesianIndex(3, 4)]
        cells = [(4, CartesianIndex(2, 6)), (16, CartesianIndex(9, 2)), (4, CartesianIndex(5, 5))]

        @test ARC_Hodel.ulcorner(indices_1) == CartesianIndex(1, 1)
        @test ARC_Hodel.ulcorner(indices_2) == CartesianIndex(1, 1)
        @test ARC_Hodel.ulcorner(cells) == CartesianIndex(2, 2)

        # urcorner
        @test ARC_Hodel.urcorner(indices_1) == CartesianIndex(1, 4)
        @test ARC_Hodel.urcorner(indices_2) == CartesianIndex(1, 4)
        @test ARC_Hodel.urcorner(cells) == CartesianIndex(2, 6)

        # llcorner
        @test ARC_Hodel.llcorner(indices_1) == CartesianIndex(5, 1)
        @test ARC_Hodel.llcorner(indices_2) == CartesianIndex(5, 1)
        @test ARC_Hodel.llcorner(indices_3) == CartesianIndex(3, 1)
        @test ARC_Hodel.llcorner(cells) == CartesianIndex(9, 2)

        # lrcorner
        @test ARC_Hodel.lrcorner(indices_1) == CartesianIndex(5, 4)
        @test ARC_Hodel.lrcorner(indices_2) == CartesianIndex(5, 4)
        @test ARC_Hodel.lrcorner(cells) == CartesianIndex(9, 6)
    end
    @testset "vmirror, hmirror, dmirror, cmirror" begin
        indices_1 = [CartesianIndex(1, 1), CartesianIndex(2, 2)]
        indices_2 = [CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(2, 2)]
        indices_3 = [CartesianIndex(1, 2), CartesianIndex(2, 3)]
        object = [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(3, 3))]
        # vmirror
        @test ARC_Hodel.vmirror(B) == [1 2; 1 0; 1 2] # grid
        @test ARC_Hodel.vmirror(C) == [4 3; 5 5] # grid
        @test Set(ARC_Hodel.vmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)]) # indices
        @test Set(ARC_Hodel.vmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]) # indices
        @test Set(ARC_Hodel.vmirror(indices_3)) == Set([CartesianIndex(1, 3), CartesianIndex(2, 2)]) # indices
        @test Set(ARC_Hodel.vmirror(object)) == Set([(2, CartesianIndex(1, 3)), (2, CartesianIndex(2, 2)), (2, CartesianIndex(3, 2))])

        # hmirror
        @test ARC_Hodel.hmirror(B) == [2 1; 0 1; 2 1]
        @test ARC_Hodel.hmirror(C) == [5 5; 3 4]
        @test Set(ARC_Hodel.hmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)])
        @test Set(ARC_Hodel.hmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 1), CartesianIndex(1, 2)])
        @test Set(ARC_Hodel.hmirror(indices_3)) == Set([CartesianIndex(2, 2), CartesianIndex(1, 3)])
        @test Set(ARC_Hodel.hmirror(object)) == Set([(2, CartesianIndex(3, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(1, 3))])

        # dmirror
        @test ARC_Hodel.dmirror(B) == [2 0 2; 1 1 1]
        @test ARC_Hodel.dmirror(C) == [3 5; 4 5]
        @test ARC_Hodel.dmirror(indices_1) == [CartesianIndex(1, 1), CartesianIndex(2, 2)]
        @test ARC_Hodel.dmirror(indices_2) == [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]
        @test ARC_Hodel.dmirror(indices_3) == indices_3
        @test ARC_Hodel.dmirror(object) == [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(2, 4))]

        # cmirror
        @test ARC_Hodel.cmirror(B) == [1 1 1; 2 0 2]
        @test ARC_Hodel.cmirror(C) == [5 4; 5 3]
        @test ARC_Hodel.cmirror(indices_1) == [CartesianIndex(2, 2), CartesianIndex(1, 1)]
        @test ARC_Hodel.cmirror(indices_2) == [CartesianIndex(2, 2), CartesianIndex(2, 1), CartesianIndex(1, 1)]
        @test ARC_Hodel.cmirror(indices_3) == [CartesianIndex(2, 3), CartesianIndex(1, 2)]
    end
end