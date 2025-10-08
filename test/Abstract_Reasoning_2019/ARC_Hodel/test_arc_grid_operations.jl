using .Abstract_Reasoning_2019.ARC_Hodel: rot180, replace

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

    # @testset "isequal and hash" begin # TODO: change
    #     A_dup = Grid([1 0; 0 1; 1 0])
    #     @test isequal(A, A_dup) == true
    #     @test isequal(A, B) == false
    #     @test hash(A) == hash(A_dup)
    #     @test hash(A) != hash(B)
    # end

    @testset "as indices" begin
        expected_indices = [
            CartesianIndex(1, 1) CartesianIndex(1, 2);
            CartesianIndex(2, 1) CartesianIndex(2, 2);
            CartesianIndex(3, 1) CartesianIndex(3, 2)
        ]
        @test collect(asindices(A)) == expected_indices

        expected_indices = [
            CartesianIndex(1, 1) CartesianIndex(1, 2);
            CartesianIndex(2, 1) CartesianIndex(2, 2)
        ]
        @test collect(asindices(C)) == expected_indices
    end
    @testset "ofcolor" begin
        @test Set(ofcolor(A, 0)) == Set([CartesianIndex(1, 2), CartesianIndex(2, 1), CartesianIndex(3, 2)])
        @test Set(ofcolor(B, 2)) == Set([CartesianIndex(1, 1), CartesianIndex(3, 1)])
        @test ofcolor(C, 1) == []
    end
    @testset "grid rotations" begin
        # 90 deg clockwise
        @test rot90(B) == [2 0 2; 1 1 1]
        @test rot90(C) == [5 3; 5 4]


        # 180 deg
        #  C = Grid([3 4; 5 5])
        @test rot180(B) == [1 2; 1 0; 1 2]
        @test rot180(B) == rot90(rot90(B))
        @test rot180(C) == [5 5; 4 3]

        # 270 deg
        @test rot270(B) == [1 1 1; 2 0 2]
        @test rot270(C) == [4 5; 3 5]
    end
    @testset "up- and downscale" begin
        @test downscale(B, 1) == B
        @test downscale(C, 1) == C
        B2 = [2 2 1 1; # TODO: rename grid
            2 2 1 1;
            0 0 1 1;
            0 0 1 1;
            2 2 1 1;
            2 2 1 1]
        @test downscale(B2, 2) == B
        C2 = [3 3 4 4;
            3 3 4 4;
            5 5 5 5;
            5 5 5 5]
        @test downscale(C2, 2) == C
        # TODO: should Grid() work on Vector as well (e.g. for only one element)
        # @test downscale(A, 4) == Grid(SMatrix([1; 0; 1]))
        @test downscale(B2, 3) == [2 1; 0 1]

        # upscale horizontally
        @test hupscale(B, 1) == B
        @test hupscale(C, 1) == C
        @test hupscale(B, 2) == [2 2 1 1; 0 0 1 1; 2 2 1 1]
        @test hupscale(C, 2) == [3 3 4 4; 5 5 5 5]
        @test hupscale(A, 3) == [1 1 1 0 0 0; 0 0 0 1 1 1; 1 1 1 0 0 0]

        # upscale verticallydef test_vupscale():
        @test vupscale(B, 1) == B
        @test vupscale(C, 1) == C
        @test vupscale(B, 2) == [2 1; 2 1; 0 1; 0 1; 2 1; 2 1]
        @test vupscale(C, 2) == [3 4; 3 4; 5 5; 5 5]
        @test vupscale(A, 3) == [1 0; 1 0; 1 0; 0 1; 0 1; 0 1; 1 0; 1 0; 1 0]
    end
    @testset "concatenate grids" begin
        # hcat
        @test hconcat(A, B) == [1 0 2 1; 0 1 0 1; 1 0 2 1]
        @test hconcat(B, A) == [2 1 1 0; 0 1 0 1; 2 1 1 0]

        # vcat
        @test vconcat(A, B) == [1 0; 0 1; 1 0; 2 1; 0 1; 2 1]
        @test vconcat(B, A) == [2 1; 0 1; 2 1; 1 0; 0 1; 1 0]
        @test vconcat(B, C) == [2 1; 0 1; 2 1; 3 4; 5 5]
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
        @test cellwise(A, B, 0) == [0 0; 0 1; 0 0]
        @test cellwise(C, E, 0) == [0 0; 0 5]

        #replace   
        @test replace(A, 1, 1) == A
        @test replace(B, 2, 3) == [3 1; 0 1; 3 1]
        @test replace(C, 5, 0) == [3 4; 0 0]

        # switch
        @test switch(A, 1, 1) == A
        @test switch(A, 1, 0) == [0 1; 1 0; 0 1]
        @test switch(C, 3, 4) == [4 3; 5 5]
    end
    @testset "trim, tophalf, bottomhalf, lefthalf, righthalf" begin
        # trim
        @test trim(D) == [5;;]
        @test trim(G) == [1 1 0; 1 1 2; 0 2 2]

        # tophalf and bottomhalf
        @test tophalf(C) == [3 4;]
        @test tophalf(D) == [1 2 3;]

        @test bottomhalf(C) == [5 5]
        @test bottomhalf(D) == [7 8 0]
        @test bottomhalf(G) == [0 0 2 2 0;
            0 2 0 0 0]

        # lefthalf and righthalf
        v = reshape([3, 5], :, 1)  # 2×1 column vector
        @test lefthalf(C) == v
        @test lefthalf(D) == [1; 4; 7;;]
        @test lefthalf(G) == [1 0; 0 1; 0 1; 0 0; 0 2]

        @test righthalf(C) == [4; 5;;]
        @test righthalf(D) == [3; 6; 0;;]
        @test righthalf(G) == [0 3; 0 0; 2 0; 2 0; 0 0]
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

        @test compress(K) == expected_K
        @test compress(H) == expected_H
    end
    @testset "canvas" begin
        @test canvas(3, CartesianIndex(1, 2)) == [3 3]
        @test canvas(2, CartesianIndex(3, 1)) == fill(2, 3, 1)
        @test canvas(7, CartesianIndex(3, 3)) == [7 7 7; 7 7 7; 7 7 7]
    end
    @testset "index" begin
        @test index(C, CartesianIndex(1, 1)) == 3
        @test index(D, CartesianIndex(2, 3)) == 6
    end

    @testset "crop" begin
        @test crop(A, CartesianIndex(1, 1), CartesianIndex(2, 2)) == [1 0; 0 1]
        @test crop(C, CartesianIndex(1, 2), CartesianIndex(1, 1)) == [4;;]
        @test crop(D, CartesianIndex(2, 3), CartesianIndex(2, 1)) == [6; 0;;]
    end
    @testset "ulcorner, urcorner, llcorner, rrcorner" begin
        # ulcorner
        indices_1 = [CartesianIndex(2, 3), CartesianIndex(1, 4), CartesianIndex(5, 1)]
        indices_2 = [CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(5, 4)]
        indices_3 = [CartesianIndex(2, 6), CartesianIndex(1, 1), CartesianIndex(3, 4)]
        cells = [(4, CartesianIndex(2, 6)), (16, CartesianIndex(9, 2)), (4, CartesianIndex(5, 5))]

        @test ulcorner(indices_1) == CartesianIndex(1, 1)

        @test ulcorner(indices_2) == CartesianIndex(1, 1)

        @test ulcorner(cells) == CartesianIndex(2, 2)

        # urcorner
        @test urcorner(indices_1) == CartesianIndex(1, 4)
        @test urcorner(indices_2) == CartesianIndex(1, 4)
        @test urcorner(cells) == CartesianIndex(2, 6)

        # llcorner
        @test llcorner(indices_1) == CartesianIndex(5, 1)
        @test llcorner(indices_2) == CartesianIndex(5, 1)
        @test llcorner(indices_3) == CartesianIndex(3, 1)
        @test llcorner(cells) == CartesianIndex(9, 2)

        # lrcorner
        @test lrcorner(indices_1) == CartesianIndex(5, 4)
        @test lrcorner(indices_2) == CartesianIndex(5, 4)
        @test lrcorner(cells) == CartesianIndex(9, 6)
    end
    @testset "vmirror, hmirror, dmirror, cmirror" begin
        indices_1 = [CartesianIndex(1, 1), CartesianIndex(2, 2)]
        indices_2 = [CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(2, 2)]
        indices_3 = [CartesianIndex(1, 2), CartesianIndex(2, 3)]
        object = [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(3, 3))]
        # vmirror
        @test vmirror(B) == [1 2; 1 0; 1 2] # grid
        @test vmirror(C) == [4 3; 5 5] # grid
        @test Set(vmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)]) # indices
        @test Set(vmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]) # indices
        @test Set(vmirror(indices_3)) == Set([CartesianIndex(1, 3), CartesianIndex(2, 2)]) # indices
        @test Set(vmirror(object)) == Set([(2, CartesianIndex(1, 3)), (2, CartesianIndex(2, 2)), (2, CartesianIndex(3, 2))])

        # hmirror
        @test hmirror(B) == [2 1; 0 1; 2 1]
        @test hmirror(C) == [5 5; 3 4]
        @test Set(hmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)])
        @test Set(hmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 1), CartesianIndex(1, 2)])
        @test Set(hmirror(indices_3)) == Set([CartesianIndex(2, 2), CartesianIndex(1, 3)])
        @test Set(hmirror(object)) == Set([(2, CartesianIndex(3, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(1, 3))])

        # dmirror
        @test dmirror(B) == [2 0 2; 1 1 1]
        @test dmirror(C) == [3 5; 4 5]
        @test dmirror(indices_1) == [CartesianIndex(1, 1), CartesianIndex(2, 2)]
        @test dmirror(indices_2) == [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]
        @test dmirror(indices_3) == indices_3
        @test dmirror(object) == [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(2, 4))]

        # cmirror
        @test cmirror(B) == [1 1 1; 2 0 2]
        @test cmirror(C) == [5 4; 5 3]
        @test cmirror(indices_1) == [CartesianIndex(2, 2), CartesianIndex(1, 1)]
        @test cmirror(indices_2) == [CartesianIndex(2, 2), CartesianIndex(2, 1), CartesianIndex(1, 1)]
        @test cmirror(indices_3) == [CartesianIndex(2, 3), CartesianIndex(1, 2)]
    end
end