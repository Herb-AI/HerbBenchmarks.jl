


using HerbBenchmarks.ARC_AGI_1

@testset "ARC-AGI-1: Hodel" verbose = true begin
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

    @testset verbose = true "Basic primitives" begin
        @testset "Numerical" begin
            @testset "add" begin
                @test add(1, 2) == 3
                @test add(4, 6) == 10
                @test add(CartesianIndex(1, 2), CartesianIndex(3, 4)) == CartesianIndex(4, 6)
                @test add(9, CartesianIndex(1, 1)) == CartesianIndex(10, 10)
                @test add(CartesianIndex(1, 1), 9) == CartesianIndex(10, 10)
            end
            @testset "subtract" begin
                @test subtract(1, 2) == -1
                @test subtract(4, 6) == -2
                @test subtract(10, 1) == 9

                @test subtract(CartesianIndex(8, 9), CartesianIndex(3, 4)) == CartesianIndex(5, 5)

                @test subtract(5, CartesianIndex(10, 6)) == CartesianIndex(-5, -1)
                @test subtract(5, CartesianIndex(1, 2)) == CartesianIndex(4, 3)

                @test subtract(CartesianIndex(5, 5), 4) == CartesianIndex(1, 1)
            end
            @testset "multiply" begin
                @test multiply(2, 3) == 6
                @test multiply(4, 3) == 12
                @test multiply(2, CartesianIndex(3, 4)) == CartesianIndex(6, 8)
                @test multiply(CartesianIndex(3, 4), 2) == CartesianIndex(6, 8)
                @test multiply(CartesianIndex(2, 3), CartesianIndex(4, 3)) == CartesianIndex(8, 9)
            end
            @testset "divide" begin
                @test divide(4, 2) == 2
                @test divide(3, 2) == 1
                @test divide(CartesianIndex(10, 6), CartesianIndex(5, 2)) == CartesianIndex(2, 3)
                @test divide(CartesianIndex(10, 10), 3) == CartesianIndex(3, 3)
                @test divide(10, CartesianIndex(2, 4)) == CartesianIndex(5, 2)
                @test divide(3, CartesianIndex(10, 10)) == CartesianIndex(0, 0)
                @test_throws DivideError divide(4, CartesianIndex(0, 9))
                @test_throws DivideError divide(CartesianIndex(3, 4), 0)
                @test_throws DivideError divide(CartesianIndex(3, 4), CartesianIndex(0, 0))
                @test_throws DivideError divide(0, 0)
            end
            @testset "invert" begin
                @test invert(1) == -1
                @test invert(-4) == 4
                @test invert(CartesianIndex(5, 6)) == CartesianIndex(-5, -6)
                @test invert(CartesianIndex(-1, 9)) == CartesianIndex(1, -9)
            end
            @testset "double and halve" begin
                @test double(1) == 2
                @test double(CartesianIndex(2, 3)) == CartesianIndex(4, 6)

                @test halve(2) == 1
                @test halve(5) == 2
                @test halve(CartesianIndex(10, 9)) == CartesianIndex(5, 4)
            end
            @testset "Increment, decrement, crement, sign" begin
                @test increment(1) == 2
                @test increment(CartesianIndex(7, 9)) == CartesianIndex(8, 10)

                @test decrement(1) == 0
                @test decrement(CartesianIndex(7, 9)) == CartesianIndex(6, 8)

                @test crement(1) == 2
                @test crement(-2) == -3
                @test crement(CartesianIndex(-2, 1)) == CartesianIndex(-3, 2)
                @test crement(CartesianIndex(0, -1)) == CartesianIndex(0, -2)

                @test signof(2) == 1
                @test signof(0) == 0
                @test signof(-1) == -1
                @test signof(CartesianIndex(0, -3)) == CartesianIndex(0, -1)
            end
        end

        @testset "Integer" begin
            @testset "even, greater, positive" begin
                @test even(1) == false
                @test even(2) == true

                @test greater(2, 1) == true
                @test greater(4, 10) == false

                @test positive(1) == true
                @test positive(0) == false
                @test positive(-2) == false
            end
            @testset verbose = true "toivec, tojvec, astuple" begin
                @test toivec(2) == CartesianIndex(2, 0)
                @test tojvec(3) == CartesianIndex(0, 3)
                @test astuple(3, 4) == CartesianIndex(3, 4)
            end

        end

        @testset "Boolean" begin
            @testset verbose = true "flip" begin
                @test flip(false) == true
                @test flip(true) == false
            end
            @testset "Boolean operations" begin
                @test both(true, false) == false
                @test both(false, true) == false
                @test both(false, false) == false
                @test both(true, true) == true

                @test either(true, false) == true
                @test either(true, true) == true
                @test either(false, false) == false
            end
        end

        @testset "equality" begin
            @test equality(A, A) == true
            @test equality(A, B) == false
            # on object (order shouldn't matter)
            obj1 = [(4, CartesianIndex(3, 3)), (2, CartesianIndex(3, 4))]
            obj2 = [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 3))]
            @test equality(obj1, obj2) == true
        end

        @testset "contained, combine, intersection, difference" begin
            @test contained(0, A) == true
            @test contained(666, A) == false
            @test contained(CartesianIndex(1, 1), [CartesianIndex(1, 1), CartesianIndex(3, 4)]) == true
            @test contained((4, CartesianIndex(3, 3)), [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 3))]) == true

            @test combine([CartesianIndex(1, 2)], [CartesianIndex(3, 4)]) == [CartesianIndex(1, 2), CartesianIndex(3, 4)]
            @test combine([(5, CartesianIndex(1, 2))], [(3, CartesianIndex(3, 4)), (5, CartesianIndex(3, 3))]) == [(5, CartesianIndex(1, 2)), (3, CartesianIndex(3, 4)), (5, CartesianIndex(3, 3))]

            obj1 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
            obj2 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2))]
            objects = [obj1, obj2]
            ind1 = [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            ind2 = [CartesianIndex(1, 1), CartesianIndex(4, 4)]
            @test intersection(obj1, obj2) == [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2))]
            @test intersection(ind1, ind2) == [CartesianIndex(1, 1)]
            @test intersection(objects, [obj1]) == [obj1]

            @test difference(obj1, obj2) == [(1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
            @test difference([1, 2, 3], [1, 2]) == [3]
        end
        @testset "dedupe, order, repeat" begin
            @test dedupe(B) == [2 1; 0 1]
            @test dedupe([1, 2, 3, 3, 2, 4, 1]) == [1, 2, 3, 4]

            @test order([3, 2, 4, 1]) == [1, 2, 3, 4]
            @test order_by([[1], [1, 2, 3], [1, 2]], length) == [[1], [1, 2], [1, 2, 3]]
            @test order_by([1, 4, -3], abs) == [1, -3, 4]

            @test repeat_item(C, 3) == [3 4 3 4 3 4; 5 5 5 5 5 5]
        end
        @testset "greater" begin
            @test greater(2, 1) == true
            @test greater(4, 10) == false
        end

        @testset "size_of" begin
            @test size_of([1, 2, 3]) == 3
            @test size_of([(4, CartesianIndex(4, 3)), (3, CartesianIndex(3, 3))]) == 2
        end

        @testset "maximum_of, minimum_of, valmax, valmin, mostcommon, leastcommon" begin
            @test maximum_of([1, 2, 5, 3]) == 5
            @test maximum_of([4, 2, 6]) == 6
            @test minimum_of([1, 2, 5, 3]) == 1
            @test minimum_of([4, 2, 6]) == 2

            @test valmax([[1], [1, 2]], size_of) == 2
            @test valmin([[1], [1, 2]], size_of) == 1

            @test argmax_by([[1], [1, 2]], size_of) == [1, 2]
            @test argmin_by([[1], [1, 2]], size_of) == [1]

            @test mostcommon([1, 2, 2, 3, 3, 3]) == 3
            @test leastcommon([1, 2, 3, 4, 2, 3, 4]) == 1
        end

    end

    @testset verbose = true "core primitives" begin
        indices = [CartesianIndex(1, 5)]
        object_1 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
        object_2 = [(1, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (2, CartesianIndex(1, 2))]


        @testset "init, toindices" begin
            @test init(2) == [2;;]

            @test toindices([(1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 1))]) == [CartesianIndex(2, 2), CartesianIndex(2, 1)]
            @test toindices([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == [CartesianIndex(2, 2), CartesianIndex(2, 1)]

        end
        @testset "vfrontier, hfrontier" begin
            @test vfrontier(CartesianIndex(3, 4)) == [CartesianIndex(i, 4) for i in 1:30]
            @test hfrontier(CartesianIndex(3, 4)) == [CartesianIndex(3, j) for j in 1:30]
        end

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

            @test shape(A) == CartesianIndex(3, 2)
            @test shape(C) == CartesianIndex(2, 2)
            @test shape(indices) == CartesianIndex(1, 1)
            @test shape(object_1) == CartesianIndex(3, 3)

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

        @testset "center, rel_position, corner" begin
            @test center([(1, CartesianIndex(1, 1))]) == CartesianIndex(1, 1)
            @test center([(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 3))]) == CartesianIndex(1, 2)
            @test center([(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 3)), (1, CartesianIndex(3, 1)), (1, CartesianIndex(3, 3))]) == CartesianIndex(2, 2)

            @test rel_position([(0, CartesianIndex(2, 2))], [(0, CartesianIndex(3, 3))]) == CartesianIndex(1, 1)
            @test rel_position([(0, CartesianIndex(3, 3))], [(0, CartesianIndex(2, 3))]) == CartesianIndex(-1, 0)
            @test rel_position([(0, CartesianIndex(4, 4))], [(0, CartesianIndex(4, 5))]) == CartesianIndex(0, 1)

            @test corners([CartesianIndex(2, 3), CartesianIndex(1, 4), CartesianIndex(5, 1)]) == [CartesianIndex(1, 1), CartesianIndex(1, 4), CartesianIndex(5, 1), CartesianIndex(5, 4)]
            @test corners([CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(5, 4)]) == [CartesianIndex(1, 1), CartesianIndex(1, 4), CartesianIndex(5, 1), CartesianIndex(5, 4)]
        end

        @testset "toobject, asobject" begin
            indices_1 = [CartesianIndex(1, 1), CartesianIndex(1, 3)]
            indices_2 = [CartesianIndex(1, 5)]
            object = [(4, CartesianIndex(1, 1)), (9, CartesianIndex(1, 3))]
            @test toobject(indices_1, G) == [(1, CartesianIndex(1, 1)), (0, CartesianIndex(1, 3))]
            @test toobject(indices_2, G) == [(3, CartesianIndex(1, 5))]
            @test toobject(object, G) == [(1, CartesianIndex(1, 1)), (0, CartesianIndex(1, 3))]

            @test Set(asobject(A)) == Set([
                (1, CartesianIndex(1, 1)),
                (0, CartesianIndex(1, 2)),
                (0, CartesianIndex(2, 1)),
                (1, CartesianIndex(2, 2)),
                (1, CartesianIndex(3, 1)),
                (0, CartesianIndex(3, 2)),
            ])

            @test fill_loc(B, 3, [CartesianIndex(1, 1), CartesianIndex(2, 2)]) == [3 1; 0 3; 2 1]
            @test fill_loc(C, 1, [CartesianIndex(2, 1)]) == [3 4; 1 5]

        end

        @testset "paint, underfill, underpaint" begin
            obj1 = [(1, CartesianIndex(1, 1)), (4, CartesianIndex(2, 2))]
            obj2 = [(6, CartesianIndex(2, 1))]
            obj3 = [(6, CartesianIndex(3, 1))]
            @test paint(B, obj1) == [1 1; 0 4; 2 1]
            @test paint(C, obj2) == [3 4; 6 5]
            @test paint(C, obj3) == C # out-of-bounds index is ignored

            @test underfill(C, 1, [CartesianIndex(1, 1), CartesianIndex(2, 1)]) == [3 4; 1 5]
            @test underfill(C, 1, [CartesianIndex(1, 1), CartesianIndex(4, 1)]) == C

            obj4 = [(3, CartesianIndex(1, 1)), (3, CartesianIndex(2, 2)), (3, CartesianIndex(4, 3))]
            @test underpaint(B, obj4) == [2 1; 0 3; 2 1]
        end
        @testset "backdrop, delta" begin
            @test backdrop([CartesianIndex(2, 3), CartesianIndex(3, 2), CartesianIndex(3, 3), CartesianIndex(4, 1)]) == [
                CartesianIndex(2, 1),
                CartesianIndex(2, 2),
                CartesianIndex(2, 3),
                CartesianIndex(3, 1),
                CartesianIndex(3, 2),
                CartesianIndex(3, 3),
                CartesianIndex(4, 1),
                CartesianIndex(4, 2),
                CartesianIndex(4, 3),
            ]
            @test isempty(backdrop([])) == true

            @test delta([CartesianIndex(2, 3), CartesianIndex(3, 2), CartesianIndex(3, 3), CartesianIndex(4, 1)]) == [
                CartesianIndex(2, 1),
                CartesianIndex(2, 2),
                CartesianIndex(3, 1),
                CartesianIndex(4, 2),
                CartesianIndex(4, 3),
            ]
        end
        @testset "gravitate, inbox, outbox" begin
            @test gravitate([CartesianIndex(1, 1)], [CartesianIndex(1, 2)]) == CartesianIndex(0, 0)
            @test gravitate([CartesianIndex(1, 1)], [CartesianIndex(1, 5)]) == CartesianIndex(0, 3)

            @test inbox([CartesianIndex(1, 1), CartesianIndex(3, 3)]) == [CartesianIndex(2, 2)]

            @test Set(outbox([CartesianIndex(2, 2)])) == Set([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(2, 1),
                CartesianIndex(2, 3),
                CartesianIndex(3, 1),
                CartesianIndex(3, 2),
                CartesianIndex(3, 3),
            ])

            @test Set(box([CartesianIndex(1, 1), CartesianIndex(2, 2)])) == Set([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(2, 1),
                CartesianIndex(2, 2)
            ])
        end

        @testset "sfilter, mfilter" begin
            @test sfilter([1, 2, 3], x -> x > 1) == [2, 3]
            @test sfilter([2, 3, 4], x -> x % 2 == 0) == [2, 4]

            @test mfilter(
                [
                    [(2, CartesianIndex(4, 4))],
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ],
                x -> length(x) == 1
            ) == [(2, CartesianIndex(4, 4)), (1, CartesianIndex(1, 1))]
        end

        @testset "merge_containers,connect, shoot" begin
            @test merge_containers([[(1, CartesianIndex(1, 1))], [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]]) == [
                (1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))
            ]
            @test merge_containers([[1, 2], [3, 4, 5]]) == [1, 2, 3, 4, 5]
            @test merge_containers([[4, 5], [7]]) == [4, 5, 7]
            # test it also works on not-nested containers
            @test merge_containers([1,2,3]) == [1, 2, 3]

            @test connect(CartesianIndex(1, 1), CartesianIndex(2, 2)) == [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            @test connect(CartesianIndex(1, 1), CartesianIndex(1, 4)) == [
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(1, 4)
            ]

            @test shoot(CartesianIndex(1, 1), CartesianIndex(1, 1)) == [CartesianIndex(i, i) for i in range(1, 43)]
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

        @testset "upscale" begin
            ## grid
            @test upscale(B, 1) == B
            @test upscale(C, 1) == C
            @test upscale(B, 2) == [2 2 1 1; 2 2 1 1; 0 0 1 1; 0 0 1 1; 2 2 1 1; 2 2 1 1]
            @test upscale(C, 2) == [3 3 4 4; 3 3 4 4; 5 5 5 5; 5 5 5 5]

            ## object
            obj1 = [(3, CartesianIndex(1, 2)), (4, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))]
            expected = [(3, CartesianIndex(1, 3)), (3, CartesianIndex(1, 4)),
                (3, CartesianIndex(2, 3)), (3, CartesianIndex(2, 4)),
                (4, CartesianIndex(3, 1)), (4, CartesianIndex(4, 1)),
                (4, CartesianIndex(3, 2)), (4, CartesianIndex(4, 2)),
                (5, CartesianIndex(3, 3)), (5, CartesianIndex(4, 3)),
                (5, CartesianIndex(3, 4)), (5, CartesianIndex(4, 4))]
            @test Set(upscale(obj1, 2)) == Set(expected)

            obj2 = [(3, CartesianIndex(1, 1))]
            expected = [(3, CartesianIndex(1, 1)), (3, CartesianIndex(2, 1)),
                (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 2))]
            @test Set(upscale(obj2, 2)) == Set(expected)
        end

        @testset "frontiers, hperiod" begin
            @test frontiers(C) == [[(5, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))]]

            obj1 = [
                (8, CartesianIndex(3, 2)),
                (8, CartesianIndex(2, 4)),
                (2, CartesianIndex(3, 5)),
                (8, CartesianIndex(3, 4)),
                (2, CartesianIndex(3, 3)),
                (2, CartesianIndex(2, 3)),
                (8, CartesianIndex(2, 2)),
                (8, CartesianIndex(2, 6)),
                (2, CartesianIndex(2, 5)),
                (8, CartesianIndex(3, 6)),
                (2, CartesianIndex(3, 1)),
                (2, CartesianIndex(2, 1)),
            ]
            obj2 = [
                (2, CartesianIndex(3, 7)),
                (2, CartesianIndex(3, 1)),
                (3, CartesianIndex(3, 5)),
                (3, CartesianIndex(3, 3)),
                (3, CartesianIndex(3, 6)),
                (2, CartesianIndex(3, 4)),
                (3, CartesianIndex(3, 2)),
            ]
            obj3 = [
                (1, CartesianIndex(3, 7)),
                (2, CartesianIndex(4, 6)),
                (2, CartesianIndex(4, 1)),
                (2, CartesianIndex(3, 3)),
                (2, CartesianIndex(3, 8)),
                (1, CartesianIndex(4, 5)),
                (2, CartesianIndex(3, 2)),
                (1, CartesianIndex(3, 4)),
                (2, CartesianIndex(3, 6)),
                (2, CartesianIndex(3, 5)),
                (1, CartesianIndex(4, 8)),
                (1, CartesianIndex(3, 1)),
                (2, CartesianIndex(4, 7)),
                (2, CartesianIndex(4, 3)),
                (2, CartesianIndex(4, 4)),
                (1, CartesianIndex(4, 2)),
            ]
            @test hperiod(obj1) == 2
            @test hperiod(obj2) == 3
            @test vperiod(obj2) == 1
            @test vperiod(obj3) == 2

        end
    end

    @testset verbose = true "Grid primitives" begin
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
            @test rot90deg(B) == [2 0 2; 1 1 1]
            @test rot90deg(C) == [5 3; 5 4]


            # 180 deg
            @test rot180deg(B) == [1 2; 1 0; 1 2]
            @test rot180deg(B) == rot90deg(rot90deg(B))
            @test rot180deg(C) == [5 5; 4 3]

            # 270 deg
            @test rot270deg(B) == [1 1 1; 2 0 2]
            @test rot270deg(C) == [4 5; 3 5]
        end
        @testset "up- and downscale" begin
            @test downscale(B, 1) == B
            @test downscale(C, 1) == C
            B2 = [2 2 1 1;
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

        @testset "subgrid, split grid" begin
            @test subgrid([(3, CartesianIndex(1, 1))], C) == [3;;]
            @test subgrid([(5, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))], C) == [5 5;]
            @test subgrid([(2, CartesianIndex(1, 2)), (4, CartesianIndex(2, 1))], D) == [1 2; 4 5]
            @test subgrid([(1, CartesianIndex(1, 1)), (0, CartesianIndex(3, 3))], D) == D

            @test hsplit(B, 1) == [B]
            @test hsplit(B, 2) == [[2; 0; 2;;], [1; 1; 1;;]]
            @test hsplit(C, 1) == [C]
            @test hsplit(C, 2) == [[3; 5;;], [4; 5;;]]

            @test vsplit(B, 1) == [B]
            @test vsplit(B, 3) == [[2 1;], [0 1;], [2 1;]]
            @test vsplit(C, 1) == [C]
            @test vsplit(C, 2) == [[3 4;], [5 5;]]
        end
        @testset "cellwise, replace, switch" begin
            # cellwise
            @test cellwise(A, B, 0) == [0 0; 0 1; 0 0]
            @test cellwise(C, E, 0) == [0 0; 0 5]

            #replace   
            @test replace_color(A, 1, 1) == A
            @test replace_color(B, 2, 3) == [3 1; 0 1; 3 1]
            @test replace_color(C, 5, 0) == [3 4; 0 0]

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

        @testset "cover, move" begin
            @test cover(C, [CartesianIndex(1, 1)]) == [5 4; 5 5]

            @test move(C, [(3, CartesianIndex(1, 1))], CartesianIndex(1, 1)) == [5 4; 5 3]
        end


        @testset "occurences" begin
            @test occurrences(G, [(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2))]) == [CartesianIndex(2, 2), CartesianIndex(3, 2)]
        end
    end

    @testset "Utils primitives" begin
        @testset "extract, insert, remove" begin
            @test extract([1, 2, 3], x -> x > 2) == 3
            @test extract([2, 3, 4], x -> x % 4 == 0) == 4

            @test insert(1, [2]) == [2, 1]
            @test insert(1, Set([2])) == Set([1, 2])
            @test remove(1, [1, 2]) == [2]
        end
        @testset "first, last, other" begin
            object = [(1, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (2, CartesianIndex(1, 2))]
            @test firstof([2, 3]) == 2
            @test firstof(object) == (1, CartesianIndex(1, 1))
            @test lastof([2, 3]) == 3
            @test lastof(object) == (2, CartesianIndex(1, 2))
            @test other(1, [1, 2]) == 2
        end
        @testset "interval, product, pair" begin
            @test interval(1, 4, 1) == [1, 2, 3, 4]
            @test interval(5, 2, -1) == [5, 4, 3, 2]

            @test Set(cartesian_product([1, 2], [2, 3])) == Set([
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(2, 2),
                CartesianIndex(2, 3)
            ])

            @test pair(CartesianIndex(1, 2), CartesianIndex(4, 3)) == [CartesianIndex(1, 4), CartesianIndex(2, 3)]
        end
        @testset "branch, compose, chain, matcher, negate, conjunct" begin
            @test branch(true, 1, 3) == 1
            @test branch(false, 4, 2) == 2
            @test branch(5 > 9, 1, 2) == 2

            myfun = compose(x -> x^2, x -> x + 1)
            @test myfun(2) == 9
            myotherfun = compose(x -> x + 1, x -> x^2)
            @test myotherfun(2) == 5

            mychainfun = chain(x -> x + 3, x -> x^2, x -> x + 1)
            @test mychainfun(2) == 12

            is_even = even
            not_even = negate(is_even)
            @test not_even(2) == false
            @test not_even(3) == true

            greater_than_zero = x -> x > 0 
            even_and_positive = conjunct(is_even, positive)
            @test even_and_positive(2) == true
            @test even_and_positive(3) == false
            @test even_and_positive(-2) == false
        end
        @testset "apply,rapply, mapply, papply, mpapply, prapply" begin
            @test apply(x -> x^2, [1, 2, 3]) == [1, 4, 9]
            @test apply(x -> x % 2, [1, 2]) == [1, 0]

            @test rapply([x -> x + 1, x -> x - 1], 1) == [2, 0]

            @test mapply(
                x -> [(v + 1, ind) for (v, ind) in x],
                [
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ]
            ) == [
                (2, CartesianIndex(1, 1)),
                (2, CartesianIndex(2, 2)), (2, CartesianIndex(1, 2))
            ]

            @test papply((x, y) -> x + y, [1, 2], [3, 4]) == [4, 6]

            @test mpapply(
                (x, y) -> [(x, ind) for (_, ind) in y],
                [3, 4],
                [
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ]
            ) == [(3, CartesianIndex(1, 1)), (4, CartesianIndex(2, 2)), (4, CartesianIndex(1, 2))]

            @test prapply((x, y) -> x + y, [1, 2], [2, 3]) == [3, 4, 4, 5]
        end
    end

end


@testset "ARC-AGI-1: Basic" begin
    @testset "Initialize and resize grid" begin
        # Test Grid struct
        mat = [1 2 3; 4 5 6; 7 8 9]
        grid = Grid(mat)
        @test (grid.width, grid.height) == (3, 3)
        @test grid.data == mat

        # Test initialise grid state
        vec = collect(1:9)
        grid = initState(vec)
        @test (grid.width, grid.height) == (3, 3)
        @test grid.data == mat

        # Test array_to_matrix
        vec = collect(1:10)
        mat = array_to_matrix(vec)
        @test size(mat) == (3, 4)

        # Test initialise grid with zeros
        grid = init_grid(3, 3)
        @test (grid.width, grid.height) == (3, 3)
        @test all(grid.data .== 0)

        # Test resize grid
        mat = [0 1 0; 1 0 1; 1 1 1]
        grid = Grid(mat)
        # Make grid larger
        new_grid = resize_grid(grid, 5, 5)
        @test (new_grid.width, new_grid.height) == (5, 5)
        @test new_grid.data[1:3, 1:3] == mat
        @test all(new_grid.data[end-1:end, end-1:end] .== 0)
        # Shrink grid
        new_grid = resize_grid(grid, 2, 2)
        @test (new_grid.width, new_grid.height) == (2, 2)
        @test new_grid.data == mat[1:2, 1:2]
        # Keep grid the same size
        new_grid = resize_grid(grid, 3, 3)
        @test (new_grid.width, new_grid.height) == (3, 3)
        @test new_grid.data == mat
    end

    @testset "Clone, copy and reset grid" begin
        mat = [1 2 3; 4 5 6; 7 8 9]
        grid = Grid(mat)
        # Test clone grid
        new_grid = clone_grid(grid)
        @test (new_grid.width, new_grid.height) == (3, 3)
        @test new_grid.data == mat

        # Test copy from input
        # TODO: Why clone and copy_from_input?
        new_grid = copy_from_input(grid)
        @test (new_grid.width, new_grid.height) == (3, 3)
        @test new_grid.data == mat

        # Test reset grid to zeros
        new_grid = reset_grid(grid)
        @test (new_grid.width, new_grid.height) == (3, 3)
        @test all(new_grid.data .== 0)
    end

    @testset "Manipulate cells" begin
        @testset "Select cells" begin
            mat = [1 2 3; 4 5 6; 7 8 9]
            grid = Grid(mat)
            another_grid = init_grid(5, 5)

            # Test set cell value 
            new_grid = set_cell(grid, 3, 3, 0)
            @test new_grid.data[end, end] == 0
            @test_throws BoundsError set_cell(grid, 4, 3, 0)

            # Test select  
            start_row, start_col, end_row, end_col = 1, 1, 2, 2
            selected_cells = select(grid, start_row, start_col, end_row, end_col)
            @test selected_cells == [(1, 1), (1, 2), (2, 1), (2, 2)]
            # ... with invalid start and end values
            start_row, start_col, end_row, end_col = 2, 2, 1, 1
            selected_cells = select(grid, start_row, start_col, end_row, end_col)
            @test selected_cells == []
            # ... with out of bounds end values
            start_row, start_col, end_row, end_col = 1, 1, 4, 4
            selected_cells = select(grid, start_row, start_col, end_row, end_col)
            @test selected_cells == [(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
        end
        @testset "Select and paste cells" begin
            # Test case: same input and target grid
            mat = [1 2 3; 4 5 6; 7 8 9]
            grid_1 = Grid(mat)
            start_row, start_col, end_row, end_col = 3, 1, 3, 3
            paste_row, paste_col = 1, 1
            new_grid = select_and_paste(grid_1, start_row, start_col, end_row, end_col, paste_row, paste_col)
            @test new_grid.data == [7 8 9; 4 5 6; 7 8 9]
            # ... on a bigger grid
            mat = Matrix{Int}(transpose(reshape(Int.(1:100), 10, 10)))
            grid_2 = Grid(mat)
            expected_data = copy(mat)
            expected_data[10, 8:10] = (12:14)
            start_row, start_col, end_row, end_col = 2, 2, 2, 4
            paste_row, paste_col = 10, 8
            new_grid = select_and_paste(grid_2, start_row, start_col, end_row, end_col, paste_row, paste_col)
            @test new_grid.data == expected_data
            # ... errors when paste indices out of bounds 
            start_row, start_col, end_row, end_col = 2, 2, 2, 4
            paste_row, paste_col = 10, 9
            @test_throws BoundsError select_and_paste(grid_2, start_row, start_col, end_row, end_col, paste_row, paste_col)

            # Test case: different input and target grid
            grid_3 = Grid(zeros(Int, 3, 3))
            expected_data = copy(mat)
            expected_data[4:6, 3:5] .= 0
            start_row, start_col, end_row, end_col = 1, 1, 3, 3
            paste_row, paste_col = 4, 3
            new_grid = select_and_paste(grid_3, start_row, start_col, end_row, end_col, grid_2, paste_row, paste_col)
            @test new_grid.data == expected_data
            # ... errors when paste indices out of bounds
            start_row, start_col, end_row, end_col = 1, 1, 3, 3
            paste_row, paste_col = 10, 8
            @test_throws BoundsError select_and_paste(grid_3, start_row, start_col, end_row, end_col, grid_2, paste_row, paste_col)
        end
        @testset "flood fill cells" begin
            mat = [0 2 9 0; 2 2 1 3; 2 0 7 2; 2 2 2 5]
            [0 2 9 0]
            [2 2 1 3]
            [2 0 7 2]
            [2 2 2 5]

            grid = Grid(mat)
            row, col = 2, 2
            color = 4
            expected_data = [0 4 9 0; 4 4 1 3; 4 0 7 2; 4 4 4 5]
            new_grid = floodfill(grid, row, col, color)
            @test new_grid.data == expected_data
            # no connected cells
            row, col = 1, 1
            color = 4
            expected_data = [4 2 9 0; 2 2 1 3; 2 0 7 2; 2 2 2 5]
            new_grid = floodfill(grid, row, col, color)
            @test new_grid.data == expected_data
        end
    end
end
