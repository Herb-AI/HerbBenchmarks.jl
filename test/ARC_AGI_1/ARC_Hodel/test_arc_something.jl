using HerbBenchmarks.ARC_AGI_1.ARC_Hodel

A = [1 0; 0 1; 1 0]
B = [2 1; 0 1; 2 1]
C = [3 4; 5 5]
D = [1 2 3; 4 5 6; 7 8 0]
G = [1 0 0 0 3;
    0 1 1 0 0;
    0 1 1 2 0;
    0 0 2 2 0;
    0 2 0 0 0]
@testset verbose = true "arc something" begin
    indices = [CartesianIndex(1, 5)]
    object_1 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
    object_2 = [(1, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (2, CartesianIndex(1, 2))]

    @testset "upper-, lower-, left- and rightmost" begin
        @test uppermost(indices) == 1
        @test uppermost(object_1) == 1

        @test lowermost(indices) == 1
        @test lowermost(object_1) == 3

        @test leftmost(indices) == 5
        @test leftmost(object_1) == 1

        @test rightmost(indices) == 5
        @test rightmost(object_1) == 3
    end


    @testset "height, width, shape, portrait" begin
        @test height(A) == 3
        @test height(indices) == 1
        @test height(object_1) == 3

        @test width(A) == 2
        @test width(C) == 2
        @test width(indices) == 1
        @test width(object_1) == 3

        @test shape(A) == (3, 2)
        @test shape(C) == (2, 2)
        @test shape(indices) == (1, 1)
        @test shape(object_1) == (3, 3)

        @test portrait(A) == true
        @test portrait(C) == false
    end

    @testset "square, vline, hline" begin
        @test square(A) == false
        @test square(B) == false
        @test square(C) == true
        @test square(D) == true
        @test square([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == false
        @test square([CartesianIndex(2, 2), CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(1, 2)]) == true
        @test square([CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(1, 2)]) == false
        @test square([(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]) == true

        @test vline([(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]) == true
        @test vline([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == false

        @test hline([(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]) == false
        @test hline([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == true
    end

    @testset "mostcolor, leastcolor, colorcount, colorfilter, sizefilter" begin
        @test mostcolor(B) == 1
        @test mostcolor(C) == 5
        @test mostcolor(object_1) == 1

        @test leastcolor(B) == 0
        @test leastcolor(object_1) == 1

        @test colorcount(A, 1) == 3
        @test colorcount(C, 5) == 2
        @test colorcount(object_1, 1) == 4
        @test colorcount(object_1, 4) == 0
        @test colorcount(object_2, 2) == 2

        objects = [
            [(3, CartesianIndex(1, 5))],
            [(1, CartesianIndex(1, 1))],
            [(2, CartesianIndex(5, 1))],
            [(1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 2)), (1, CartesianIndex(3, 3))],
            [(2, CartesianIndex(4, 3)), (2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 4))]
        ]
        @test colorfilter(objects, 2) == [[(2, CartesianIndex(5, 1))], [(2, CartesianIndex(4, 3)), (2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 4))]]

        @test sizefilter(objects, 1) == [
            [(3, CartesianIndex(1, 5))],
            [(1, CartesianIndex(1, 1))],
            [(2, CartesianIndex(5, 1))]]
        @test isempty(sizefilter(objects, 7)) == true
    end

    @testset "crop, recolor, shift, normalize" begin
        @test crop(A, CartesianIndex(1, 1), (2, 2)) == [1 0; 0 1]
        @test crop(C, CartesianIndex(1, 2), (1, 1)) == [4;;]
        @test crop(D, CartesianIndex(2, 3), (2, 1)) == [6; 0;;]

        @test recolor(3, [(2, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2)), (5, CartesianIndex(2, 1))]) == [(3, CartesianIndex(1, 1)), (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 1))]
        @test recolor(2, [(2, CartesianIndex(3, 6)), (2, CartesianIndex(2, 2))]) == [(2, CartesianIndex(3, 6)), (2, CartesianIndex(2, 2))]
        @test recolor(3, [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(2, 1)]) == [(3, CartesianIndex(1, 1)), (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 1))]

        @test shift([(2, CartesianIndex(2, 2)), (4, CartesianIndex(2, 3)), (1, CartesianIndex(3, 4))], (1, 2)) == [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 5)), (1, CartesianIndex(4, 6))]
        @test shift([CartesianIndex(2, 4), CartesianIndex(1, 3), CartesianIndex(4, 5)], (0, -1)) == [CartesianIndex(2, 3), CartesianIndex(1, 2), CartesianIndex(4, 4)]

        @testset normalize([(2, CartesianIndex(2, 2)), (4, CartesianIndex(2, 3)), (1, CartesianIndex(3, 4))]) == [(2, CartesianIndex(1, 1)), (4, CartesianIndex(1, 2)), (1, CartesianIndex(2, 3))]
        @testset normalize([CartesianIndex(2, 1), CartesianIndex(1, 3), CartesianIndex(4, 5)]) == [CartesianIndex(2, 1), CartesianIndex(1, 3), CartesianIndex(4, 5)]
        @testset normalize([]) == []
    end

    @testset "dneighbors, ineighbors, neighbors" begin
        @test dneighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 1), CartesianIndex(2, 1), CartesianIndex(1, 0), CartesianIndex(1, 2)]
        @test dneighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 2), CartesianIndex(3, 2), CartesianIndex(2, 1), CartesianIndex(2, 3)]
        @test dneighbors(CartesianIndex(1, 2)) == [CartesianIndex(0, 2), CartesianIndex(2, 2), CartesianIndex(1, 1), CartesianIndex(1, 3)]
        @test dneighbors(CartesianIndex(2, 1)) == [CartesianIndex(1, 1), CartesianIndex(3, 1), CartesianIndex(2, 0), CartesianIndex(2, 2)]

        @test ineighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 0), CartesianIndex(0, 2), CartesianIndex(2, 0), CartesianIndex(2, 2)]
        @test ineighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 1), CartesianIndex(1, 3), CartesianIndex(3, 1), CartesianIndex(3, 3)]
        @test ineighbors(CartesianIndex(1, 2)) == [CartesianIndex(0, 1), CartesianIndex(0, 3), CartesianIndex(2, 1), CartesianIndex(2, 3)]
        @test ineighbors(CartesianIndex(2, 1)) == [CartesianIndex(1, 0), CartesianIndex(1, 2), CartesianIndex(3, 0), CartesianIndex(3, 2)]

        @test neighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 1), CartesianIndex(2, 1), CartesianIndex(1, 0), CartesianIndex(1, 2), CartesianIndex(0, 0), CartesianIndex(0, 2), CartesianIndex(2, 0), CartesianIndex(2, 2)]
        @test neighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 2), CartesianIndex(3, 2), CartesianIndex(2, 1), CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(1, 3), CartesianIndex(3, 1), CartesianIndex(3, 3)]
    end

    @testset "objects" begin
        # without diagonal neighbours
        obj1 = Set([(1, CartesianIndex(1, 1))])
        obj2 = Set([(3, CartesianIndex(1, 5))])
        obj3 = Set([(1, CartesianIndex(2, 2)), (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))])
        obj4 = Set([(2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4))])
        obj5 = Set([(2, CartesianIndex(5, 2))])
        expected = Set([obj1, obj2, obj3, obj4, obj5])
        actual = objects(G, true, false, true)
        @test actual == expected

        # with diagonal neighbours 
        obj1 = Set([(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))])
        obj2 = Set([(3, CartesianIndex(1, 5))])
        obj3 = Set([(2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4)), (2, CartesianIndex(5, 2))])
        expected = Set([obj1, obj2, obj3])
        actual = objects(G, true, true, true)
        @test actual == expected

        obj1 = Set([(3, CartesianIndex(1, 5))])
        obj2 = Set([
            (1, CartesianIndex(1, 1)),
            (1, CartesianIndex(2, 2)),
            (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)),
            (1, CartesianIndex(3, 3)),
            (2, CartesianIndex(3, 4)),
            (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4)),
            (2, CartesianIndex(5, 2))
        ])
        expected = Set([obj1, obj2])
        @test objects(G, false, true, true) == expected

        obj1 = Set([(1, CartesianIndex(1, 1))])
        obj2 = Set([(3, CartesianIndex(1, 5))])
        obj3 = Set([
            (1, CartesianIndex(2, 2)),
            (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)),
            (1, CartesianIndex(3, 3)),
            (2, CartesianIndex(3, 4)),
            (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4))
        ])
        obj4 = Set([(2, CartesianIndex(5, 2))])
        expected = Set([obj1, obj2, obj3, obj4])
        @test objects(G, false, false, true) == expected

        # TODO: @test objects(G, true, true, false) == expected
        obj1 = Set([
            (1, CartesianIndex(1, 1)),
            (1, CartesianIndex(2, 2)),
            (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)),
            (1, CartesianIndex(3, 3)),])
        obj2 = Set([(3, CartesianIndex(1, 5))])
        obj3 = Set([
            (2, CartesianIndex(3, 4)),
            (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4)),
            (2, CartesianIndex(5, 2))
        ])
        obj4 = Set([
            (0, CartesianIndex(1, 2)),
            (0, CartesianIndex(1, 3)),
            (0, CartesianIndex(1, 4)),
            (0, CartesianIndex(2, 1)),
            (0, CartesianIndex(2, 4)),
            (0, CartesianIndex(2, 5)),
            (0, CartesianIndex(3, 1)),
            (0, CartesianIndex(3, 5)),
            (0, CartesianIndex(4, 1)),
            (0, CartesianIndex(4, 2)),
            (0, CartesianIndex(4, 5)),
            (0, CartesianIndex(5, 1)),
            (0, CartesianIndex(5, 3)),
            (0, CartesianIndex(5, 4)),
            (0, CartesianIndex(5, 5)),
        ])
        expected = Set([obj1, obj2, obj3, obj4])
        @test objects(G, true, true, false) == expected

        obj1 = Set([
            (1, CartesianIndex(2, 2)),
            (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)),
            (1, CartesianIndex(3, 3)),])
        obj2 = Set([(3, CartesianIndex(1, 5))])
        obj3 = Set([
            (2, CartesianIndex(3, 4)),
            (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4))
        ])
        obj4 = Set([(2, CartesianIndex(5, 2))])
        obj5 = Set([(1, CartesianIndex(1, 1))])
        expected = Set([obj1, obj2, obj3, obj4, obj5])
        @test objects(G, true, false, true) == expected

        obj1 = Set([(1, CartesianIndex(1, 1)),
            (3, CartesianIndex(1, 5)),
            (1, CartesianIndex(2, 2)),
            (1, CartesianIndex(3, 2)),
            (1, CartesianIndex(2, 3)),
            (1, CartesianIndex(3, 3)),
            (2, CartesianIndex(3, 4)),
            (2, CartesianIndex(4, 3)),
            (2, CartesianIndex(4, 4)),
            (2, CartesianIndex(5, 2)),
            (0, CartesianIndex(1, 2)),
            (0, CartesianIndex(1, 3)),
            (0, CartesianIndex(1, 4)),
            (0, CartesianIndex(2, 1)),
            (0, CartesianIndex(2, 4)),
            (0, CartesianIndex(2, 5)),
            (0, CartesianIndex(3, 1)),
            (0, CartesianIndex(3, 5)),
            (0, CartesianIndex(4, 1)),
            (0, CartesianIndex(4, 2)),
            (0, CartesianIndex(4, 5)),
            (0, CartesianIndex(5, 1)),
            (0, CartesianIndex(5, 3)),
            (0, CartesianIndex(5, 4)),
            (0, CartesianIndex(5, 5)),
        ])
        expected = Set([obj1])
        @test objects(G, false, false, false) == expected
    end

    @testset "partition, fgpartition" begin
        actual = partition(B)
        expected = [
            [(0, CartesianIndex(2, 1))],
            [(1, CartesianIndex(1, 2)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(3, 2))],
            [(2, CartesianIndex(1, 1)), (2, CartesianIndex(3, 1))]
        ]
        @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # order doesn't matter, we only care about cells

        actual = partition(G)
        expected = [
            [
                (1, CartesianIndex(1, 1)),
                (1, CartesianIndex(2, 2)),
                (1, CartesianIndex(2, 3)),
                (1, CartesianIndex(3, 2)),
                (1, CartesianIndex(3, 3))
            ],
            [
                (2, CartesianIndex(3, 4)),
                (2, CartesianIndex(4, 3)),
                (2, CartesianIndex(4, 4)),
                (2, CartesianIndex(5, 2))
            ],
            [
                (3, CartesianIndex(1, 5))
            ],
            [
                (0, CartesianIndex(1, 2)),
                (0, CartesianIndex(1, 3)),
                (0, CartesianIndex(1, 4)),
                (0, CartesianIndex(2, 1)),
                (0, CartesianIndex(2, 4)),
                (0, CartesianIndex(2, 5)),
                (0, CartesianIndex(3, 1)),
                (0, CartesianIndex(3, 5)),
                (0, CartesianIndex(4, 1)),
                (0, CartesianIndex(4, 2)),
                (0, CartesianIndex(4, 5)),
                (0, CartesianIndex(5, 1)),
                (0, CartesianIndex(5, 3)),
                (0, CartesianIndex(5, 4)),
                (0, CartesianIndex(5, 5))
            ]
        ]
        @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # order doesn't matter, we only care about cells

        actual = fgpartition(B)
        expected = [
            [(0, CartesianIndex(2, 1))],
            [(2, CartesianIndex(1, 1)), (2, CartesianIndex(3, 1))]
        ]
        @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # order doesn't matter, we only care about cells

        actual = fgpartition(G)
        expected = [
            [
                (1, CartesianIndex(1, 1)),
                (1, CartesianIndex(2, 2)),
                (1, CartesianIndex(2, 3)),
                (1, CartesianIndex(3, 2)),
                (1, CartesianIndex(3, 3))
            ],
            [
                (2, CartesianIndex(3, 4)),
                (2, CartesianIndex(4, 3)),
                (2, CartesianIndex(4, 4)),
                (2, CartesianIndex(5, 2))
            ],
            [
                (3, CartesianIndex(1, 5))
            ],
        ]
    end
    @testset "palette, numcolors, color" begin
        pal = palette(G)
        @test length(pal) == 4
        @test Set(pal) == Set([0, 1, 2, 3])

        obj1 = [(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]
        obj2 = [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2))]
        obj3 = [(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]
        pal = palette(obj1)
        @test length(pal) == 3
        @test Set(pal) == Set([1, 2, 3])

        @test palette(obj2) == [1]

        @test numcolors(G) == 4
        @test numcolors(obj2) == 1
        @test numcolors(obj3) == 3

        @test color(obj2) == 1
        @test color((2, CartesianIndex(4, 2))) == 2
    end

    @testset "hmatching, vmatching" begin
        obj1 = [
            (1, CartesianIndex(2, 2)),
            (2, CartesianIndex(1, 1)),
            (2, CartesianIndex(2, 1)),
            (3, CartesianIndex(1, 2)),]
        obj2 = [(3, CartesianIndex(1, 5))]
        obj3 = [(1, CartesianIndex(3, 4)), (2, CartesianIndex(3, 5))]
        @test hmatching(obj1, obj2) == true
        @test hmatching(obj1, obj3) == false

        obj4 = [(1, CartesianIndex(4, 2)), (2, CartesianIndex(5, 2))]
        obj5 = [(1, CartesianIndex(4, 3)), (2, CartesianIndex(5, 3))]
        @test vmatching(obj1, obj4) == true
        @test vmatching(obj1, obj5) == false
    end

    @testset "manhattan, adjacent, bordering, centerofmass" begin
        @test manhattan([CartesianIndex(1, 1), CartesianIndex(2, 2)], [CartesianIndex(2, 3), CartesianIndex(3, 4)]) == 1
        @test manhattan([CartesianIndex(2, 2)], [CartesianIndex(3, 4)]) == 3
        @test manhattan([(5, CartesianIndex(2, 2))], [(3, CartesianIndex(3, 4))]) == 3

        @test adjacent([CartesianIndex(1, 1)], [CartesianIndex(1, 2), CartesianIndex(2, 1)]) == true
        @test adjacent([CartesianIndex(1, 1)], [CartesianIndex(2, 2)]) == false

        @test bordering([CartesianIndex(1, 1)], D) == true
        @test bordering([CartesianIndex(1, 3)], D) == true
        @test bordering([CartesianIndex(3, 1)], D) == true
        @test bordering([CartesianIndex(3, 3)], D) == true
        @test bordering([CartesianIndex(2, 2)], D) == false

        @test centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(2, 3)]) == CartesianIndex(1, 2)
        @test centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(3, 3)]) == CartesianIndex(2, 2)
        @test centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(1, 2)]) == CartesianIndex(1, 1)
    end

end


# def test_bordering():
#     assert bordering(frozenset({(0, 0)}), D)
#     assert bordering(frozenset({(0, 2)}), D)
#     assert bordering(frozenset({(2, 0)}), D)
#     assert bordering(frozenset({(2, 2)}), D)
#     assert not bordering(frozenset({(1, 1)}), D)
