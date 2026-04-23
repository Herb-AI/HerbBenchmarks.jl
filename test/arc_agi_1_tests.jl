@testitem "ARC-AGI-1: Hodel operators" begin
    import HerbBenchmarks.ARC_AGI1 as ARC

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
            @testset "ARC.add" begin
                @test ARC.add(1, 2) == 3
                @test ARC.add(4, 6) == 10
                @test ARC.add(CartesianIndex(1, 2), CartesianIndex(3, 4)) == CartesianIndex(4, 6)
                @test ARC.add(9, CartesianIndex(1, 1)) == CartesianIndex(10, 10)
                @test ARC.add(CartesianIndex(1, 1), 9) == CartesianIndex(10, 10)
            end
            @testset "ARC.subtract" begin
                @test ARC.subtract(1, 2) == -1
                @test ARC.subtract(4, 6) == -2
                @test ARC.subtract(10, 1) == 9

                @test ARC.subtract(CartesianIndex(8, 9), CartesianIndex(3, 4)) == CartesianIndex(5, 5)

                @test ARC.subtract(5, CartesianIndex(10, 6)) == CartesianIndex(-5, -1)
                @test ARC.subtract(5, CartesianIndex(1, 2)) == CartesianIndex(4, 3)

                @test ARC.subtract(CartesianIndex(5, 5), 4) == CartesianIndex(1, 1)
            end
            @testset "ARC.multiply" begin
                @test ARC.multiply(2, 3) == 6
                @test ARC.multiply(4, 3) == 12
                @test ARC.multiply(2, CartesianIndex(3, 4)) == CartesianIndex(6, 8)
                @test ARC.multiply(CartesianIndex(3, 4), 2) == CartesianIndex(6, 8)
                @test ARC.multiply(CartesianIndex(2, 3), CartesianIndex(4, 3)) == CartesianIndex(8, 9)
            end
            @testset "ARC.divide" begin
                @test ARC.divide(4, 2) == 2
                @test ARC.divide(3, 2) == 1
                @test ARC.divide(CartesianIndex(10, 6), CartesianIndex(5, 2)) == CartesianIndex(2, 3)
                @test ARC.divide(CartesianIndex(10, 10), 3) == CartesianIndex(3, 3)
                @test ARC.divide(10, CartesianIndex(2, 4)) == CartesianIndex(5, 2)
                @test ARC.divide(3, CartesianIndex(10, 10)) == CartesianIndex(0, 0)
                @test_throws DivideError ARC.divide(4, CartesianIndex(0, 9))
                @test_throws DivideError ARC.divide(CartesianIndex(3, 4), 0)
                @test_throws DivideError ARC.divide(CartesianIndex(3, 4), CartesianIndex(0, 0))
                @test_throws DivideError ARC.divide(0, 0)
            end
            @testset "ARC.invert" begin
                @test ARC.invert(1) == -1
                @test ARC.invert(-4) == 4
                @test ARC.invert(CartesianIndex(5, 6)) == CartesianIndex(-5, -6)
                @test ARC.invert(CartesianIndex(-1, 9)) == CartesianIndex(1, -9)
            end
            @testset "ARC.double and ARC.halve" begin
                @test ARC.double(1) == 2
                @test ARC.double(CartesianIndex(2, 3)) == CartesianIndex(4, 6)

                @test ARC.halve(2) == 1
                @test ARC.halve(5) == 2
                @test ARC.halve(CartesianIndex(10, 9)) == CartesianIndex(5, 4)
            end
            @testset "Increment, ARC.decrement, ARC.crement, sign" begin
                @test ARC.increment(1) == 2
                @test ARC.increment(CartesianIndex(7, 9)) == CartesianIndex(8, 10)

                @test ARC.decrement(1) == 0
                @test ARC.decrement(CartesianIndex(7, 9)) == CartesianIndex(6, 8)

                @test ARC.crement(1) == 2
                @test ARC.crement(-2) == -3
                @test ARC.crement(CartesianIndex(-2, 1)) == CartesianIndex(-3, 2)
                @test ARC.crement(CartesianIndex(0, -1)) == CartesianIndex(0, -2)

                @test ARC.signof(2) == 1
                @test ARC.signof(0) == 0
                @test ARC.signof(-1) == -1
                @test ARC.signof(CartesianIndex(0, -3)) == CartesianIndex(0, -1)
            end
        end

        @testset "Integer" begin
            @testset "ARC.even, ARC.greater, ARC.positive" begin
                @test ARC.even(1) == false
                @test ARC.even(2) == true

                @test ARC.greater(2, 1) == true
                @test ARC.greater(4, 10) == false

                @test ARC.positive(1) == true
                @test ARC.positive(0) == false
                @test ARC.positive(-2) == false
            end
            @testset verbose = true "ARC.toivec, ARC.tojvec, ARC.astuple" begin
                @test ARC.toivec(2) == CartesianIndex(2, 0)
                @test ARC.tojvec(3) == CartesianIndex(0, 3)
                @test ARC.astuple(3, 4) == CartesianIndex(3, 4)
            end

        end

        @testset "Boolean" begin
            @testset verbose = true "ARC.flip" begin
                @test ARC.flip(false) == true
                @test ARC.flip(true) == false
            end
            @testset "Boolean operations" begin
                @test ARC.both(true, false) == false
                @test ARC.both(false, true) == false
                @test ARC.both(false, false) == false
                @test ARC.both(true, true) == true

                @test ARC.either(true, false) == true
                @test ARC.either(true, true) == true
                @test ARC.either(false, false) == false
            end
        end

        @testset "ARC.equality" begin
            @test ARC.equality(A, A) == true
            @test ARC.equality(A, B) == false
            # on object (ARC.order shouldn't matter)
            obj1 = [(4, CartesianIndex(3, 3)), (2, CartesianIndex(3, 4))]
            obj2 = [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 3))]
            @test ARC.equality(obj1, obj2) == true
        end

        @testset "ARC.contained, ARC.combine, ARC.intersection, ARC.difference" begin
            @test ARC.contained(0, A) == true
            @test ARC.contained(666, A) == false
            @test ARC.contained(CartesianIndex(1, 1), [CartesianIndex(1, 1), CartesianIndex(3, 4)]) == true
            @test ARC.contained((4, CartesianIndex(3, 3)), [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 3))]) == true

            @test ARC.combine([CartesianIndex(1, 2)], [CartesianIndex(3, 4)]) == [CartesianIndex(1, 2), CartesianIndex(3, 4)]
            @test ARC.combine([(5, CartesianIndex(1, 2))], [(3, CartesianIndex(3, 4)), (5, CartesianIndex(3, 3))]) == [(5, CartesianIndex(1, 2)), (3, CartesianIndex(3, 4)), (5, CartesianIndex(3, 3))]

            obj1 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
            obj2 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2))]
            objects = [obj1, obj2]
            ind1 = [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            ind2 = [CartesianIndex(1, 1), CartesianIndex(4, 4)]
            @test ARC.intersection(obj1, obj2) == [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2))]
            @test ARC.intersection(ind1, ind2) == [CartesianIndex(1, 1)]
            @test ARC.intersection(objects, [obj1]) == [obj1]

            @test ARC.difference(obj1, obj2) == [(1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
            @test ARC.difference([1, 2, 3], [1, 2]) == [3]
        end
        @testset "ARC.dedupe, ARC.order, repeat" begin
            @test ARC.dedupe(B) == [2 1; 0 1]
            @test ARC.dedupe([1, 2, 3, 3, 2, 4, 1]) == [1, 2, 3, 4]

            @test ARC.order([3, 2, 4, 1]) == [1, 2, 3, 4]
            @test ARC.order_by([[1], [1, 2, 3], [1, 2]], length) == [[1], [1, 2], [1, 2, 3]]
            @test ARC.order_by([1, 4, -3], abs) == [1, -3, 4]

            @test ARC.repeat_item(C, 3) == [3 4 3 4 3 4; 5 5 5 5 5 5]
        end
        @testset "ARC.greater" begin
            @test ARC.greater(2, 1) == true
            @test ARC.greater(4, 10) == false
        end

        @testset "ARC.size_of" begin
            @test ARC.size_of([1, 2, 3]) == 3
            @test ARC.size_of([(4, CartesianIndex(4, 3)), (3, CartesianIndex(3, 3))]) == 2
        end

        @testset "ARC.maximum_of, ARC.minimum_of, ARC.valmax, ARC.valmin, ARC.mostcommon, ARC.leastcommon" begin
            @test ARC.maximum_of([1, 2, 5, 3]) == 5
            @test ARC.maximum_of([4, 2, 6]) == 6
            @test ARC.minimum_of([1, 2, 5, 3]) == 1
            @test ARC.minimum_of([4, 2, 6]) == 2

            @test ARC.valmax([[1], [1, 2]], ARC.size_of) == 2
            @test ARC.valmin([[1], [1, 2]], ARC.size_of) == 1

            @test ARC.argmax_by([[1], [1, 2]], ARC.size_of) == [1, 2]
            @test ARC.argmin_by([[1], [1, 2]], ARC.size_of) == [1]

            @test ARC.mostcommon([1, 2, 2, 3, 3, 3]) == 3
            @test ARC.leastcommon([1, 2, 3, 4, 2, 3, 4]) == 1
        end

    end

    @testset verbose = true "core primitives" begin
        indices = [CartesianIndex(1, 5)]
        object_1 = [(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))]
        object_2 = [(1, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (2, CartesianIndex(1, 2))]


        @testset "ARC.init, ARC.toindices" begin
            @test ARC.init(2) == [2;;]

            @test ARC.toindices([(1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 1))]) == [CartesianIndex(2, 2), CartesianIndex(2, 1)]
            @test ARC.toindices([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == [CartesianIndex(2, 2), CartesianIndex(2, 1)]

        end
        @testset "ARC.vfrontier, ARC.hfrontier" begin
            @test ARC.vfrontier(CartesianIndex(3, 4)) == [CartesianIndex(i, 4) for i in 1:30]
            @test ARC.hfrontier(CartesianIndex(3, 4)) == [CartesianIndex(3, j) for j in 1:30]
        end

        @testset "upper-, lower-, left- and ARC.rightmost" begin
            @test ARC.uppermost(indices) == 1
            @test ARC.uppermost(object_1) == 1

            @test ARC.lowermost(indices) == 1
            @test ARC.lowermost(object_1) == 3

            @test ARC.leftmost(indices) == 5
            @test ARC.leftmost(object_1) == 1

            @test ARC.rightmost(indices) == 5
            @test ARC.rightmost(object_1) == 3
        end


        @testset "ARC.height, ARC.width, ARC.shape, ARC.portrait" begin
            @test ARC.height(A) == 3
            @test ARC.height(indices) == 1
            @test ARC.height(object_1) == 3

            @test ARC.width(A) == 2
            @test ARC.width(C) == 2
            @test ARC.width(indices) == 1
            @test ARC.width(object_1) == 3

            @test ARC.shape(A) == CartesianIndex(3, 2)
            @test ARC.shape(C) == CartesianIndex(2, 2)
            @test ARC.shape(indices) == CartesianIndex(1, 1)
            @test ARC.shape(object_1) == CartesianIndex(3, 3)

            @test ARC.portrait(A) == true
            @test ARC.portrait(C) == false
        end

        @testset "ARC.square, ARC.vline, ARC.hline" begin
            @test ARC.square(A) == false
            @test ARC.square(B) == false
            @test ARC.square(C) == true
            @test ARC.square(D) == true
            @test ARC.square([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == false
            @test ARC.square([CartesianIndex(2, 2), CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(1, 2)]) == true
            @test ARC.square([CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(1, 2)]) == false
            @test ARC.square([(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]) == true

            @test ARC.vline([(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]) == true
            @test ARC.vline([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == false

            @test ARC.hline([(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]) == false
            @test ARC.hline([CartesianIndex(2, 2), CartesianIndex(2, 1)]) == true
        end

        @testset "ARC.mostcolor, ARC.leastcolor, ARC.colorcount, ARC.colorfilter, ARC.sizefilter" begin
            @test ARC.mostcolor(B) == 1
            @test ARC.mostcolor(C) == 5
            @test ARC.mostcolor(object_1) == 1

            @test ARC.leastcolor(B) == 0
            @test ARC.leastcolor(object_1) == 1

            @test ARC.colorcount(A, 1) == 3
            @test ARC.colorcount(C, 5) == 2
            @test ARC.colorcount(object_1, 1) == 4
            @test ARC.colorcount(object_1, 4) == 0
            @test ARC.colorcount(object_2, 2) == 2

            objects = [
                [(3, CartesianIndex(1, 5))],
                [(1, CartesianIndex(1, 1))],
                [(2, CartesianIndex(5, 1))],
                [(1, CartesianIndex(2, 2)), (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 2)), (1, CartesianIndex(3, 3))],
                [(2, CartesianIndex(4, 3)), (2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 4))]
            ]
            @test ARC.colorfilter(objects, 2) == [[(2, CartesianIndex(5, 1))], [(2, CartesianIndex(4, 3)), (2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 4))]]

            @test ARC.sizefilter(objects, 1) == [
                [(3, CartesianIndex(1, 5))],
                [(1, CartesianIndex(1, 1))],
                [(2, CartesianIndex(5, 1))]]
            @test isempty(ARC.sizefilter(objects, 7)) == true
        end

        @testset "ARC.crop, ARC.recolor, ARC.shift, ARC.normalize" begin
            @test ARC.crop(A, CartesianIndex(1, 1), (2, 2)) == [1 0; 0 1]
            @test ARC.crop(C, CartesianIndex(1, 2), (1, 1)) == [4;;]
            @test ARC.crop(D, CartesianIndex(2, 3), (2, 1)) == [6; 0;;]

            @test ARC.recolor(3, [(2, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2)), (5, CartesianIndex(2, 1))]) == [(3, CartesianIndex(1, 1)), (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 1))]
            @test ARC.recolor(2, [(2, CartesianIndex(3, 6)), (2, CartesianIndex(2, 2))]) == [(2, CartesianIndex(3, 6)), (2, CartesianIndex(2, 2))]
            @test ARC.recolor(3, [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(2, 1)]) == [(3, CartesianIndex(1, 1)), (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 1))]

            @test ARC.shift([(2, CartesianIndex(2, 2)), (4, CartesianIndex(2, 3)), (1, CartesianIndex(3, 4))], (1, 2)) == [(2, CartesianIndex(3, 4)), (4, CartesianIndex(3, 5)), (1, CartesianIndex(4, 6))]
            @test ARC.shift([CartesianIndex(2, 4), CartesianIndex(1, 3), CartesianIndex(4, 5)], (0, -1)) == [CartesianIndex(2, 3), CartesianIndex(1, 2), CartesianIndex(4, 4)]

            @testset ARC.normalize([(2, CartesianIndex(2, 2)), (4, CartesianIndex(2, 3)), (1, CartesianIndex(3, 4))]) == [(2, CartesianIndex(1, 1)), (4, CartesianIndex(1, 2)), (1, CartesianIndex(2, 3))]
            @testset ARC.normalize([CartesianIndex(2, 1), CartesianIndex(1, 3), CartesianIndex(4, 5)]) == [CartesianIndex(2, 1), CartesianIndex(1, 3), CartesianIndex(4, 5)]
            @testset ARC.normalize([]) == []
        end

        @testset "ARC.dneighbors, ARC.ineighbors, ARC.neighbors" begin
            @test ARC.dneighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 1), CartesianIndex(2, 1), CartesianIndex(1, 0), CartesianIndex(1, 2)]
            @test ARC.dneighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 2), CartesianIndex(3, 2), CartesianIndex(2, 1), CartesianIndex(2, 3)]
            @test ARC.dneighbors(CartesianIndex(1, 2)) == [CartesianIndex(0, 2), CartesianIndex(2, 2), CartesianIndex(1, 1), CartesianIndex(1, 3)]
            @test ARC.dneighbors(CartesianIndex(2, 1)) == [CartesianIndex(1, 1), CartesianIndex(3, 1), CartesianIndex(2, 0), CartesianIndex(2, 2)]

            @test ARC.ineighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 0), CartesianIndex(0, 2), CartesianIndex(2, 0), CartesianIndex(2, 2)]
            @test ARC.ineighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 1), CartesianIndex(1, 3), CartesianIndex(3, 1), CartesianIndex(3, 3)]
            @test ARC.ineighbors(CartesianIndex(1, 2)) == [CartesianIndex(0, 1), CartesianIndex(0, 3), CartesianIndex(2, 1), CartesianIndex(2, 3)]
            @test ARC.ineighbors(CartesianIndex(2, 1)) == [CartesianIndex(1, 0), CartesianIndex(1, 2), CartesianIndex(3, 0), CartesianIndex(3, 2)]

            @test ARC.neighbors(CartesianIndex(1, 1)) == [CartesianIndex(0, 1), CartesianIndex(2, 1), CartesianIndex(1, 0), CartesianIndex(1, 2), CartesianIndex(0, 0), CartesianIndex(0, 2), CartesianIndex(2, 0), CartesianIndex(2, 2)]
            @test ARC.neighbors(CartesianIndex(2, 2)) == [CartesianIndex(1, 2), CartesianIndex(3, 2), CartesianIndex(2, 1), CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(1, 3), CartesianIndex(3, 1), CartesianIndex(3, 3)]
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
            actual = ARC.objects(G, true, false, true)
            @test actual == expected

            # with diagonal neighbours 
            obj1 = Set([(1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(3, 2)),
                (1, CartesianIndex(2, 3)), (1, CartesianIndex(3, 3))])
            obj2 = Set([(3, CartesianIndex(1, 5))])
            obj3 = Set([(2, CartesianIndex(3, 4)), (2, CartesianIndex(4, 3)),
                (2, CartesianIndex(4, 4)), (2, CartesianIndex(5, 2))])
            expected = Set([obj1, obj2, obj3])
            actual = ARC.objects(G, true, true, true)
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
            @test ARC.objects(G, false, true, true) == expected

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
            @test ARC.objects(G, false, false, true) == expected

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
            @test ARC.objects(G, true, true, false) == expected

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
            @test ARC.objects(G, true, false, true) == expected

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
            @test ARC.objects(G, false, false, false) == expected
        end

        @testset "ARC.partition, ARC.fgpartition" begin
            actual = ARC.partition(B)
            expected = [
                [(0, CartesianIndex(2, 1))],
                [(1, CartesianIndex(1, 2)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(3, 2))],
                [(2, CartesianIndex(1, 1)), (2, CartesianIndex(3, 1))]
            ]
            @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # ARC.order doesn't matter, we only care about cells

            actual = ARC.partition(G)
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
            @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # ARC.order doesn't matter, we only care about cells

            actual = ARC.fgpartition(B)
            expected = [
                [(0, CartesianIndex(2, 1))],
                [(2, CartesianIndex(1, 1)), (2, CartesianIndex(3, 1))]
            ]
            @test Set(sort(obj) for obj in actual) == Set(sort(obj) for obj in expected) # ARC.order doesn't matter, we only care about cells

            actual = ARC.fgpartition(G)
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
        @testset "ARC.palette, ARC.numcolors, ARC.color" begin
            pal = ARC.palette(G)
            @test length(pal) == 4
            @test Set(pal) == Set([0, 1, 2, 3])

            obj1 = [(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]
            obj2 = [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2))]
            obj3 = [(1, CartesianIndex(2, 2)), (2, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (3, CartesianIndex(1, 2))]
            pal = ARC.palette(obj1)
            @test length(pal) == 3
            @test Set(pal) == Set([1, 2, 3])

            @test ARC.palette(obj2) == [1]

            @test ARC.numcolors(G) == 4
            @test ARC.numcolors(obj2) == 1
            @test ARC.numcolors(obj3) == 3

            @test ARC.color(obj2) == 1
            @test ARC.color((2, CartesianIndex(4, 2))) == 2
        end

        @testset "ARC.hmatching, ARC.vmatching" begin
            obj1 = [
                (1, CartesianIndex(2, 2)),
                (2, CartesianIndex(1, 1)),
                (2, CartesianIndex(2, 1)),
                (3, CartesianIndex(1, 2)),]
            obj2 = [(3, CartesianIndex(1, 5))]
            obj3 = [(1, CartesianIndex(3, 4)), (2, CartesianIndex(3, 5))]
            @test ARC.hmatching(obj1, obj2) == true
            @test ARC.hmatching(obj1, obj3) == false

            obj4 = [(1, CartesianIndex(4, 2)), (2, CartesianIndex(5, 2))]
            obj5 = [(1, CartesianIndex(4, 3)), (2, CartesianIndex(5, 3))]
            @test ARC.vmatching(obj1, obj4) == true
            @test ARC.vmatching(obj1, obj5) == false
        end

        @testset "ARC.manhattan, ARC.adjacent, ARC.bordering, ARC.centerofmass" begin
            @test ARC.manhattan([CartesianIndex(1, 1), CartesianIndex(2, 2)], [CartesianIndex(2, 3), CartesianIndex(3, 4)]) == 1
            @test ARC.manhattan([CartesianIndex(2, 2)], [CartesianIndex(3, 4)]) == 3
            @test ARC.manhattan([(5, CartesianIndex(2, 2))], [(3, CartesianIndex(3, 4))]) == 3

            @test ARC.adjacent([CartesianIndex(1, 1)], [CartesianIndex(1, 2), CartesianIndex(2, 1)]) == true
            @test ARC.adjacent([CartesianIndex(1, 1)], [CartesianIndex(2, 2)]) == false

            @test ARC.bordering([CartesianIndex(1, 1)], D) == true
            @test ARC.bordering([CartesianIndex(1, 3)], D) == true
            @test ARC.bordering([CartesianIndex(3, 1)], D) == true
            @test ARC.bordering([CartesianIndex(3, 3)], D) == true
            @test ARC.bordering([CartesianIndex(2, 2)], D) == false

            @test ARC.centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(2, 3)]) == CartesianIndex(1, 2)
            @test ARC.centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(3, 3)]) == CartesianIndex(2, 2)
            @test ARC.centerofmass([CartesianIndex(1, 1), CartesianIndex(2, 2), CartesianIndex(1, 2)]) == CartesianIndex(1, 1)
        end

        @testset "ARC.center, ARC.rel_position, corner" begin
            @test ARC.center([(1, CartesianIndex(1, 1))]) == CartesianIndex(1, 1)
            @test ARC.center([(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 3))]) == CartesianIndex(1, 2)
            @test ARC.center([(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 3)), (1, CartesianIndex(3, 1)), (1, CartesianIndex(3, 3))]) == CartesianIndex(2, 2)

            @test ARC.rel_position([(0, CartesianIndex(2, 2))], [(0, CartesianIndex(3, 3))]) == CartesianIndex(1, 1)
            @test ARC.rel_position([(0, CartesianIndex(3, 3))], [(0, CartesianIndex(2, 3))]) == CartesianIndex(-1, 0)
            @test ARC.rel_position([(0, CartesianIndex(4, 4))], [(0, CartesianIndex(4, 5))]) == CartesianIndex(0, 1)

            @test ARC.corners([CartesianIndex(2, 3), CartesianIndex(1, 4), CartesianIndex(5, 1)]) == [CartesianIndex(1, 1), CartesianIndex(1, 4), CartesianIndex(5, 1), CartesianIndex(5, 4)]
            @test ARC.corners([CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(5, 4)]) == [CartesianIndex(1, 1), CartesianIndex(1, 4), CartesianIndex(5, 1), CartesianIndex(5, 4)]
        end

        @testset "ARC.toobject, ARC.asobject" begin
            indices_1 = [CartesianIndex(1, 1), CartesianIndex(1, 3)]
            indices_2 = [CartesianIndex(1, 5)]
            object = [(4, CartesianIndex(1, 1)), (9, CartesianIndex(1, 3))]
            @test ARC.toobject(indices_1, G) == [(1, CartesianIndex(1, 1)), (0, CartesianIndex(1, 3))]
            @test ARC.toobject(indices_2, G) == [(3, CartesianIndex(1, 5))]
            @test ARC.toobject(object, G) == [(1, CartesianIndex(1, 1)), (0, CartesianIndex(1, 3))]

            @test Set(ARC.asobject(A)) == Set([
                (1, CartesianIndex(1, 1)),
                (0, CartesianIndex(1, 2)),
                (0, CartesianIndex(2, 1)),
                (1, CartesianIndex(2, 2)),
                (1, CartesianIndex(3, 1)),
                (0, CartesianIndex(3, 2)),
            ])

            @test ARC.fill_loc(B, 3, [CartesianIndex(1, 1), CartesianIndex(2, 2)]) == [3 1; 0 3; 2 1]
            @test ARC.fill_loc(C, 1, [CartesianIndex(2, 1)]) == [3 4; 1 5]

        end

        @testset "ARC.paint, ARC.underfill, ARC.underpaint" begin
            obj1 = [(1, CartesianIndex(1, 1)), (4, CartesianIndex(2, 2))]
            obj2 = [(6, CartesianIndex(2, 1))]
            obj3 = [(6, CartesianIndex(3, 1))]
            @test ARC.paint(B, obj1) == [1 1; 0 4; 2 1]
            @test ARC.paint(C, obj2) == [3 4; 6 5]
            @test ARC.paint(C, obj3) == C # out-of-bounds ARC.index is ignored

            @test ARC.underfill(C, 1, [CartesianIndex(1, 1), CartesianIndex(2, 1)]) == [3 4; 1 5]
            @test ARC.underfill(C, 1, [CartesianIndex(1, 1), CartesianIndex(4, 1)]) == C

            obj4 = [(3, CartesianIndex(1, 1)), (3, CartesianIndex(2, 2)), (3, CartesianIndex(4, 3))]
            @test ARC.underpaint(B, obj4) == [2 1; 0 3; 2 1]
        end
        @testset "ARC.backdrop, ARC.delta" begin
            @test ARC.backdrop([CartesianIndex(2, 3), CartesianIndex(3, 2), CartesianIndex(3, 3), CartesianIndex(4, 1)]) == [
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
            @test isempty(ARC.backdrop([])) == true

            @test ARC.delta([CartesianIndex(2, 3), CartesianIndex(3, 2), CartesianIndex(3, 3), CartesianIndex(4, 1)]) == [
                CartesianIndex(2, 1),
                CartesianIndex(2, 2),
                CartesianIndex(3, 1),
                CartesianIndex(4, 2),
                CartesianIndex(4, 3),
            ]
        end
        @testset "ARC.gravitate, ARC.inbox, ARC.outbox" begin
            @test ARC.gravitate([CartesianIndex(1, 1)], [CartesianIndex(1, 2)]) == CartesianIndex(0, 0)
            @test ARC.gravitate([CartesianIndex(1, 1)], [CartesianIndex(1, 5)]) == CartesianIndex(0, 3)

            @test ARC.inbox([CartesianIndex(1, 1), CartesianIndex(3, 3)]) == [CartesianIndex(2, 2)]

            @test Set(ARC.outbox([CartesianIndex(2, 2)])) == Set([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(2, 1),
                CartesianIndex(2, 3),
                CartesianIndex(3, 1),
                CartesianIndex(3, 2),
                CartesianIndex(3, 3),
            ])

            @test Set(ARC.box([CartesianIndex(1, 1), CartesianIndex(2, 2)])) == Set([
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(2, 1),
                CartesianIndex(2, 2)
            ])
        end

        @testset "ARC.sfilter, ARC.mfilter" begin
            @test ARC.sfilter([1, 2, 3], x -> x > 1) == [2, 3]
            @test ARC.sfilter([2, 3, 4], x -> x % 2 == 0) == [2, 4]

            @test ARC.mfilter(
                [
                    [(2, CartesianIndex(4, 4))],
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ],
                x -> length(x) == 1
            ) == [(2, CartesianIndex(4, 4)), (1, CartesianIndex(1, 1))]
        end

        @testset "ARC.merge_containers,ARC.connect, ARC.shoot" begin
            @test ARC.merge_containers([[(1, CartesianIndex(1, 1))], [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]]) == [
                (1, CartesianIndex(1, 1)), (1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))
            ]
            @test ARC.merge_containers([[1, 2], [3, 4, 5]]) == [1, 2, 3, 4, 5]
            @test ARC.merge_containers([[4, 5], [7]]) == [4, 5, 7]
            # test it also works on not-nested containers
            @test ARC.merge_containers([1,2,3]) == [1, 2, 3]

            @test ARC.connect(CartesianIndex(1, 1), CartesianIndex(2, 2)) == [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            @test ARC.connect(CartesianIndex(1, 1), CartesianIndex(1, 4)) == [
                CartesianIndex(1, 1),
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(1, 4)
            ]

            @test ARC.shoot(CartesianIndex(1, 1), CartesianIndex(1, 1)) == [CartesianIndex(i, i) for i in range(1, 43)]
        end

        @testset "ARC.ulcorner, ARC.urcorner, ARC.llcorner, rrcorner" begin
            # ARC.ulcorner
            indices_1 = [CartesianIndex(2, 3), CartesianIndex(1, 4), CartesianIndex(5, 1)]
            indices_2 = [CartesianIndex(2, 3), CartesianIndex(1, 1), CartesianIndex(5, 4)]
            indices_3 = [CartesianIndex(2, 6), CartesianIndex(1, 1), CartesianIndex(3, 4)]
            cells = [(4, CartesianIndex(2, 6)), (16, CartesianIndex(9, 2)), (4, CartesianIndex(5, 5))]

            @test ARC.ulcorner(indices_1) == CartesianIndex(1, 1)
            @test ARC.ulcorner(indices_2) == CartesianIndex(1, 1)
            @test ARC.ulcorner(cells) == CartesianIndex(2, 2)

            # ARC.urcorner
            @test ARC.urcorner(indices_1) == CartesianIndex(1, 4)
            @test ARC.urcorner(indices_2) == CartesianIndex(1, 4)
            @test ARC.urcorner(cells) == CartesianIndex(2, 6)

            # ARC.llcorner
            @test ARC.llcorner(indices_1) == CartesianIndex(5, 1)
            @test ARC.llcorner(indices_2) == CartesianIndex(5, 1)
            @test ARC.llcorner(indices_3) == CartesianIndex(3, 1)
            @test ARC.llcorner(cells) == CartesianIndex(9, 2)

            # ARC.lrcorner
            @test ARC.lrcorner(indices_1) == CartesianIndex(5, 4)
            @test ARC.lrcorner(indices_2) == CartesianIndex(5, 4)
            @test ARC.lrcorner(cells) == CartesianIndex(9, 6)
        end

        @testset "ARC.vmirror, ARC.hmirror, ARC.dmirror, ARC.cmirror" begin
            indices_1 = [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            indices_2 = [CartesianIndex(1, 1), CartesianIndex(2, 1), CartesianIndex(2, 2)]
            indices_3 = [CartesianIndex(1, 2), CartesianIndex(2, 3)]
            object = [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(3, 3))]
            # ARC.vmirror
            @test ARC.vmirror(B) == [1 2; 1 0; 1 2] # grid
            @test ARC.vmirror(C) == [4 3; 5 5] # grid
            @test Set(ARC.vmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)]) # indices
            @test Set(ARC.vmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]) # indices
            @test Set(ARC.vmirror(indices_3)) == Set([CartesianIndex(1, 3), CartesianIndex(2, 2)]) # indices
            @test Set(ARC.vmirror(object)) == Set([(2, CartesianIndex(1, 3)), (2, CartesianIndex(2, 2)), (2, CartesianIndex(3, 2))])

            # ARC.hmirror
            @test ARC.hmirror(B) == [2 1; 0 1; 2 1]
            @test ARC.hmirror(C) == [5 5; 3 4]
            @test Set(ARC.hmirror(indices_1)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 2)])
            @test Set(ARC.hmirror(indices_2)) == Set([CartesianIndex(2, 1), CartesianIndex(1, 1), CartesianIndex(1, 2)])
            @test Set(ARC.hmirror(indices_3)) == Set([CartesianIndex(2, 2), CartesianIndex(1, 3)])
            @test Set(ARC.hmirror(object)) == Set([(2, CartesianIndex(3, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(1, 3))])

            # ARC.dmirror
            @test ARC.dmirror(B) == [2 0 2; 1 1 1]
            @test ARC.dmirror(C) == [3 5; 4 5]
            @test ARC.dmirror(indices_1) == [CartesianIndex(1, 1), CartesianIndex(2, 2)]
            @test ARC.dmirror(indices_2) == [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(2, 2)]
            @test ARC.dmirror(indices_3) == indices_3
            @test ARC.dmirror(object) == [(2, CartesianIndex(1, 2)), (2, CartesianIndex(2, 3)), (2, CartesianIndex(2, 4))]

            # ARC.cmirror
            @test ARC.cmirror(B) == [1 1 1; 2 0 2]
            @test ARC.cmirror(C) == [5 4; 5 3]
            @test ARC.cmirror(indices_1) == [CartesianIndex(2, 2), CartesianIndex(1, 1)]
            @test ARC.cmirror(indices_2) == [CartesianIndex(2, 2), CartesianIndex(2, 1), CartesianIndex(1, 1)]
            @test ARC.cmirror(indices_3) == [CartesianIndex(2, 3), CartesianIndex(1, 2)]
        end

        @testset "ARC.upscale" begin
            ## grid
            @test ARC.upscale(B, 1) == B
            @test ARC.upscale(C, 1) == C
            @test ARC.upscale(B, 2) == [2 2 1 1; 2 2 1 1; 0 0 1 1; 0 0 1 1; 2 2 1 1; 2 2 1 1]
            @test ARC.upscale(C, 2) == [3 3 4 4; 3 3 4 4; 5 5 5 5; 5 5 5 5]

            ## object
            obj1 = [(3, CartesianIndex(1, 2)), (4, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))]
            expected = [(3, CartesianIndex(1, 3)), (3, CartesianIndex(1, 4)),
                (3, CartesianIndex(2, 3)), (3, CartesianIndex(2, 4)),
                (4, CartesianIndex(3, 1)), (4, CartesianIndex(4, 1)),
                (4, CartesianIndex(3, 2)), (4, CartesianIndex(4, 2)),
                (5, CartesianIndex(3, 3)), (5, CartesianIndex(4, 3)),
                (5, CartesianIndex(3, 4)), (5, CartesianIndex(4, 4))]
            @test Set(ARC.upscale(obj1, 2)) == Set(expected)

            obj2 = [(3, CartesianIndex(1, 1))]
            expected = [(3, CartesianIndex(1, 1)), (3, CartesianIndex(2, 1)),
                (3, CartesianIndex(1, 2)), (3, CartesianIndex(2, 2))]
            @test Set(ARC.upscale(obj2, 2)) == Set(expected)
        end

        @testset "ARC.frontiers, ARC.hperiod" begin
            @test ARC.frontiers(C) == [[(5, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))]]

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
            @test ARC.hperiod(obj1) == 2
            @test ARC.hperiod(obj2) == 3
            @test ARC.vperiod(obj2) == 1
            @test ARC.vperiod(obj3) == 2

        end
    end

    @testset verbose = true "Grid primitives" begin
        @testset "as indices" begin
            expected_indices = [
                CartesianIndex(1, 1) CartesianIndex(1, 2);
                CartesianIndex(2, 1) CartesianIndex(2, 2);
                CartesianIndex(3, 1) CartesianIndex(3, 2)
            ]
            @test collect(ARC.asindices(A)) == expected_indices

            expected_indices = [
                CartesianIndex(1, 1) CartesianIndex(1, 2);
                CartesianIndex(2, 1) CartesianIndex(2, 2)
            ]
            @test collect(ARC.asindices(C)) == expected_indices
        end
        @testset "ARC.ofcolor" begin
            @test Set(ARC.ofcolor(A, 0)) == Set([CartesianIndex(1, 2), CartesianIndex(2, 1), CartesianIndex(3, 2)])
            @test Set(ARC.ofcolor(B, 2)) == Set([CartesianIndex(1, 1), CartesianIndex(3, 1)])
            @test ARC.ofcolor(C, 1) == []
        end
        @testset "grid rotations" begin
            # 90 deg clockwise
            @test ARC.rot90deg(B) == [2 0 2; 1 1 1]
            @test ARC.rot90deg(C) == [5 3; 5 4]


            # 180 deg
            @test ARC.rot180deg(B) == [1 2; 1 0; 1 2]
            @test ARC.rot180deg(B) == ARC.rot90deg(ARC.rot90deg(B))
            @test ARC.rot180deg(C) == [5 5; 4 3]

            # 270 deg
            @test ARC.rot270deg(B) == [1 1 1; 2 0 2]
            @test ARC.rot270deg(C) == [4 5; 3 5]
        end
        @testset "up- and ARC.downscale" begin
            @test ARC.downscale(B, 1) == B
            @test ARC.downscale(C, 1) == C
            B2 = [2 2 1 1;
                2 2 1 1;
                0 0 1 1;
                0 0 1 1;
                2 2 1 1;
                2 2 1 1]
            @test ARC.downscale(B2, 2) == B
            C2 = [3 3 4 4;
                3 3 4 4;
                5 5 5 5;
                5 5 5 5]
            @test ARC.downscale(C2, 2) == C
            @test ARC.downscale(B2, 3) == [2 1; 0 1]

            # ARC.upscale horizontally
            @test ARC.hupscale(B, 1) == B
            @test ARC.hupscale(C, 1) == C
            @test ARC.hupscale(B, 2) == [2 2 1 1; 0 0 1 1; 2 2 1 1]
            @test ARC.hupscale(C, 2) == [3 3 4 4; 5 5 5 5]
            @test ARC.hupscale(A, 3) == [1 1 1 0 0 0; 0 0 0 1 1 1; 1 1 1 0 0 0]

            # ARC.upscale verticallydef test_vupscale():
            @test ARC.vupscale(B, 1) == B
            @test ARC.vupscale(C, 1) == C
            @test ARC.vupscale(B, 2) == [2 1; 2 1; 0 1; 0 1; 2 1; 2 1]
            @test ARC.vupscale(C, 2) == [3 4; 3 4; 5 5; 5 5]
            @test ARC.vupscale(A, 3) == [1 0; 1 0; 1 0; 0 1; 0 1; 0 1; 1 0; 1 0; 1 0]
        end
        @testset "concatenate grids" begin
            # hcat
            @test ARC.hconcat(A, B) == [1 0 2 1; 0 1 0 1; 1 0 2 1]
            @test ARC.hconcat(B, A) == [2 1 1 0; 0 1 0 1; 2 1 1 0]

            # vcat
            @test ARC.vconcat(A, B) == [1 0; 0 1; 1 0; 2 1; 0 1; 2 1]
            @test ARC.vconcat(B, A) == [2 1; 0 1; 2 1; 1 0; 0 1; 1 0]
            @test ARC.vconcat(B, C) == [2 1; 0 1; 2 1; 3 4; 5 5]
        end

        @testset "ARC.subgrid, split grid" begin
            @test ARC.subgrid([(3, CartesianIndex(1, 1))], C) == [3;;]
            @test ARC.subgrid([(5, CartesianIndex(2, 1)), (5, CartesianIndex(2, 2))], C) == [5 5;]
            @test ARC.subgrid([(2, CartesianIndex(1, 2)), (4, CartesianIndex(2, 1))], D) == [1 2; 4 5]
            @test ARC.subgrid([(1, CartesianIndex(1, 1)), (0, CartesianIndex(3, 3))], D) == D

            @test ARC.hsplit(B, 1) == [B]
            @test ARC.hsplit(B, 2) == [[2; 0; 2;;], [1; 1; 1;;]]
            @test ARC.hsplit(C, 1) == [C]
            @test ARC.hsplit(C, 2) == [[3; 5;;], [4; 5;;]]

            @test ARC.vsplit(B, 1) == [B]
            @test ARC.vsplit(B, 3) == [[2 1;], [0 1;], [2 1;]]
            @test ARC.vsplit(C, 1) == [C]
            @test ARC.vsplit(C, 2) == [[3 4;], [5 5;]]
        end
        @testset "ARC.cellwise, replace, ARC.switch" begin
            # ARC.cellwise
            @test ARC.cellwise(A, B, 0) == [0 0; 0 1; 0 0]
            @test ARC.cellwise(C, E, 0) == [0 0; 0 5]

            #replace   
            @test ARC.replace_color(A, 1, 1) == A
            @test ARC.replace_color(B, 2, 3) == [3 1; 0 1; 3 1]
            @test ARC.replace_color(C, 5, 0) == [3 4; 0 0]

            # ARC.switch
            @test ARC.switch(A, 1, 1) == A
            @test ARC.switch(A, 1, 0) == [0 1; 1 0; 0 1]
            @test ARC.switch(C, 3, 4) == [4 3; 5 5]
        end
        @testset "ARC.trim, ARC.tophalf, ARC.bottomhalf, ARC.lefthalf, ARC.righthalf" begin
            # ARC.trim
            @test ARC.trim(D) == [5;;]
            @test ARC.trim(G) == [1 1 0; 1 1 2; 0 2 2]

            # ARC.tophalf and ARC.bottomhalf
            @test ARC.tophalf(C) == [3 4;]
            @test ARC.tophalf(D) == [1 2 3;]

            @test ARC.bottomhalf(C) == [5 5]
            @test ARC.bottomhalf(D) == [7 8 0]
            @test ARC.bottomhalf(G) == [0 0 2 2 0;
                0 2 0 0 0]

            # ARC.lefthalf and ARC.righthalf
            v = reshape([3, 5], :, 1)  # 2×1 column vector
            @test ARC.lefthalf(C) == v
            @test ARC.lefthalf(D) == [1; 4; 7;;]
            @test ARC.lefthalf(G) == [1 0; 0 1; 0 1; 0 0; 0 2]

            @test ARC.righthalf(C) == [4; 5;;]
            @test ARC.righthalf(D) == [3; 6; 0;;]
            @test ARC.righthalf(G) == [0 3; 0 0; 2 0; 2 0; 0 0]
        end
        @testset "ARC.compress" begin
            # ARC.compress
            expected_K = [0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0]

            expected_H = [0 2 0 2;
                2 0 0 2;
                0 0 2 0]

            @test ARC.compress(K) == expected_K
            @test ARC.compress(H) == expected_H
        end
        @testset "ARC.canvas" begin
            @test ARC.canvas(3, CartesianIndex(1, 2)) == [3 3]
            @test ARC.canvas(2, CartesianIndex(3, 1)) == fill(2, 3, 1)
            @test ARC.canvas(7, CartesianIndex(3, 3)) == [7 7 7; 7 7 7; 7 7 7]
        end
        @testset "ARC.index" begin
            @test ARC.index(C, CartesianIndex(1, 1)) == 3
            @test ARC.index(D, CartesianIndex(2, 3)) == 6

        end

        @testset "ARC.cover, ARC.move" begin
            @test ARC.cover(C, [CartesianIndex(1, 1)]) == [5 4; 5 5]

            @test ARC.move(C, [(3, CartesianIndex(1, 1))], CartesianIndex(1, 1)) == [5 4; 5 3]
        end


        @testset "occurences" begin
            @test ARC.occurrences(G, [(1, CartesianIndex(1, 1)), (1, CartesianIndex(1, 2))]) == [CartesianIndex(2, 2), CartesianIndex(3, 2)]
        end
    end

    @testset "Utils primitives" begin
        @testset "ARC.extract, ARC.insert, ARC.remove" begin
            @test ARC.extract([1, 2, 3], x -> x > 2) == 3
            @test ARC.extract([2, 3, 4], x -> x % 4 == 0) == 4

            @test ARC.insert(1, [2]) == [2, 1]
            @test ARC.insert(1, Set([2])) == Set([1, 2])
            @test ARC.remove(1, [1, 2]) == [2]
        end
        @testset "first, last, ARC.other" begin
            object = [(1, CartesianIndex(1, 1)), (2, CartesianIndex(2, 1)), (2, CartesianIndex(1, 2))]
            @test ARC.firstof([2, 3]) == 2
            @test ARC.firstof(object) == (1, CartesianIndex(1, 1))
            @test ARC.lastof([2, 3]) == 3
            @test ARC.lastof(object) == (2, CartesianIndex(1, 2))
            @test ARC.other(1, [1, 2]) == 2
        end
        @testset "ARC.interval, product, ARC.pair" begin
            @test ARC.interval(1, 4, 1) == [1, 2, 3, 4]
            @test ARC.interval(5, 2, -1) == [5, 4, 3, 2]

            @test Set(ARC.cartesian_product([1, 2], [2, 3])) == Set([
                CartesianIndex(1, 2),
                CartesianIndex(1, 3),
                CartesianIndex(2, 2),
                CartesianIndex(2, 3)
            ])

            @test ARC.pair(CartesianIndex(1, 2), CartesianIndex(4, 3)) == [CartesianIndex(1, 4), CartesianIndex(2, 3)]
        end
        @testset "ARC.branch, ARC.compose, ARC.chain, matcher, ARC.negate, ARC.conjunct" begin
            @test ARC.branch(true, 1, 3) == 1
            @test ARC.branch(false, 4, 2) == 2
            @test ARC.branch(5 > 9, 1, 2) == 2

            myfun = ARC.compose(x -> x^2, x -> x + 1)
            @test myfun(2) == 9
            myotherfun = ARC.compose(x -> x + 1, x -> x^2)
            @test myotherfun(2) == 5

            mychainfun = ARC.chain(x -> x + 3, x -> x^2, x -> x + 1)
            @test mychainfun(2) == 12

            is_even = ARC.even
            not_even = ARC.negate(is_even)
            @test not_even(2) == false
            @test not_even(3) == true

            greater_than_zero = x -> x > 0 
            even_and_positive = ARC.conjunct(is_even, ARC.positive)
            @test even_and_positive(2) == true
            @test even_and_positive(3) == false
            @test even_and_positive(-2) == false
        end
        @testset "ARC.apply,ARC.rapply, ARC.mapply, ARC.papply, ARC.mpapply, ARC.prapply" begin
            @test ARC.apply(x -> x^2, [1, 2, 3]) == [1, 4, 9]
            @test ARC.apply(x -> x % 2, [1, 2]) == [1, 0]

            @test ARC.rapply([x -> x + 1, x -> x - 1], 1) == [2, 0]

            @test ARC.mapply(
                x -> [(v + 1, ind) for (v, ind) in x],
                [
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ]
            ) == [
                (2, CartesianIndex(1, 1)),
                (2, CartesianIndex(2, 2)), (2, CartesianIndex(1, 2))
            ]

            @test ARC.papply((x, y) -> x + y, [1, 2], [3, 4]) == [4, 6]

            @test ARC.mpapply(
                (x, y) -> [(x, ind) for (_, ind) in y],
                [3, 4],
                [
                    [(1, CartesianIndex(1, 1))],
                    [(1, CartesianIndex(2, 2)), (1, CartesianIndex(1, 2))]
                ]
            ) == [(3, CartesianIndex(1, 1)), (4, CartesianIndex(2, 2)), (4, CartesianIndex(1, 2))]

            @test ARC.prapply((x, y) -> x + y, [1, 2], [2, 3]) == [3, 4, 4, 5]
        end
    end

end

@testitem "ARC-AGI-1: Hodel interpreter tests" begin
    import HerbBenchmarks.ARC_AGI1 as ARC
    import HerbGrammar: expr2rulenode

    g = ARC.grammar_hodel
    spec = ARC.problem_007bbfb7.spec
    args1 = [ex.in[:_arg_1] for ex in spec]

    rn(ex) = expr2rulenode(ex, g)

    # -------------------------------------------------------------------------
    # Basic Grid / identity
    # -------------------------------------------------------------------------

    arg_rn = rn(:(_arg_1))
    @test ARC.interpret(arg_rn, spec) == args1

    # -------------------------------------------------------------------------
    # Basic grid transformations
    # -------------------------------------------------------------------------

    rot90_rn = rn(:(rot90deg(_arg_1)))
    rot180_rn = rn(:(rot180deg(_arg_1)))
    rot270_rn = rn(:(rot270deg(_arg_1)))

    @test ARC.interpret(rot90_rn, spec) == [ARC.rot90deg(g) for g in args1]
    @test ARC.interpret(rot180_rn, spec) == [ARC.rot180deg(g) for g in args1]
    @test ARC.interpret(rot270_rn, spec) == [ARC.rot270deg(g) for g in args1]

    # -------------------------------------------------------------------------
    # Grid composition
    # -------------------------------------------------------------------------

    hconcat_rn = rn(:(hconcat(_arg_1, _arg_1)))
    vconcat_rn = rn(:(vconcat(_arg_1, _arg_1)))
    repeat_rn = rn(:(repeat_item(_arg_1, 2)))

    @test ARC.interpret(hconcat_rn, spec) == [ARC.hconcat(g, g) for g in args1]
    @test ARC.interpret(vconcat_rn, spec) == [ARC.vconcat(g, g) for g in args1]
    @test ARC.interpret(repeat_rn, spec) == [ARC.repeat_item(g, 2) for g in args1]

    # -------------------------------------------------------------------------
    # Grid editing
    # -------------------------------------------------------------------------

    replace_rn = rn(:(replace_color(_arg_1, 7, 1)))
    switch_rn = rn(:(switch(_arg_1, 0, 7)))
    cellwise_rn = rn(:(cellwise(_arg_1, _arg_1, 1)))

    @test ARC.interpret(replace_rn, spec) == [ARC.replace_color(g, 7, 1) for g in args1]
    @test ARC.interpret(switch_rn, spec) == [ARC.switch(g, 0, 7) for g in args1]
    @test ARC.interpret(cellwise_rn, spec) == [ARC.cellwise(g, g, 1) for g in args1]

    # -------------------------------------------------------------------------
    # IntegerTuple construction and ARC.shape-sensitive grid construction
    # -------------------------------------------------------------------------

    canvas_rn = rn(:(canvas(1, shape(_arg_1))))
    crop_rn = rn(:(crop(_arg_1, astuple(1, 1), shape(_arg_1))))

    @test ARC.interpret(canvas_rn, spec) == [
        ARC.canvas(1, ARC.shape(g)) for g in args1
    ]

    @test ARC.interpret(crop_rn, spec) == [
        ARC.crop(g, ARC.astuple(1, 1), ARC.shape(g)) for g in args1
    ]

    # -------------------------------------------------------------------------
    # Grid containers
    # -------------------------------------------------------------------------

    first_hsplit_rn = rn(:(firstof(hsplit(_arg_1, 3))))
    last_vsplit_rn = rn(:(lastof(vsplit(_arg_1, 3))))
    tallest_hsplit_rn = rn(:(argmax_by(hsplit(_arg_1, 3), height)))

    @test ARC.interpret(first_hsplit_rn, spec) == [
        ARC.firstof(ARC.hsplit(g, 3)) for g in args1
    ]

    @test ARC.interpret(last_vsplit_rn, spec) == [
        ARC.lastof(ARC.vsplit(g, 3)) for g in args1
    ]

    @test ARC.interpret(tallest_hsplit_rn, spec) == [
        ARC.argmax_by(ARC.hsplit(g, 3), ARC.height) for g in args1
    ]

    # -------------------------------------------------------------------------
    # Indices, ARC.objects, ARC.paint/fill/ARC.cover
    # -------------------------------------------------------------------------

    paint_recolor_rn = rn(:(paint(_arg_1, recolor(1, ofcolor(_arg_1, 7)))))
    fill_rn = rn(:(fill_loc(_arg_1, 1, ofcolor(_arg_1, 7))))
    cover_rn = rn(:(cover(_arg_1, ofcolor(_arg_1, 7))))

    @test ARC.interpret(paint_recolor_rn, spec) == [
        ARC.paint(g, ARC.recolor(1, ARC.ofcolor(g, 7))) for g in args1
    ]

    @test ARC.interpret(fill_rn, spec) == [
        ARC.fill_loc(g, 1, ARC.ofcolor(g, 7)) for g in args1
    ]

    @test ARC.interpret(cover_rn, spec) == [
        ARC.cover(g, ARC.ofcolor(g, 7)) for g in args1
    ]

    # -------------------------------------------------------------------------
    # Objects and higher-ARC.order object rules
    #
    # ARC.equality(1, 1) == true
    # ARC.equality(1, 2) == false
    #
    # ARC.objects(grid, true, false, true)
    # means:
    #   univalued = true
    #   diagonal = false
    #   without_bg = true
    # -------------------------------------------------------------------------

    largest_object_painted_rn = rn(:(
        paint(
            _arg_1,
            argmax_by(
                objects(_arg_1, equality(1, 1), equality(1, 2), equality(1, 1)),
                size_of
            )
        )
    ))

    first_ordered_object_painted_rn = rn(:(
        paint(
            _arg_1,
            firstof(
                order_by(
                    objects(_arg_1, equality(1, 1), equality(1, 2), equality(1, 1)),
                    size_of
                )
            )
        )
    ))

    @test ARC.interpret(largest_object_painted_rn, spec) == [
        ARC.paint(
            g,
            ARC.argmax_by(
                ARC.objects(g, true, false, true),
                ARC.size_of,
            ),
        )
        for g in args1
    ]

    @test ARC.interpret(first_ordered_object_painted_rn, spec) == [
        ARC.paint(
            g,
            ARC.firstof(
                ARC.order_by(
                    ARC.objects(g, true, false, true),
                    ARC.size_of,
                ),
            ),
        )
        for g in args1
    ]

    # -------------------------------------------------------------------------
    # Predicates and ARC.branch
    # -------------------------------------------------------------------------

    branch_true_rn = rn(:(branch(equality(1, 1), rot90deg(_arg_1), rot180deg(_arg_1))))
    branch_false_rn = rn(:(branch(equality(1, 2), rot90deg(_arg_1), rot180deg(_arg_1))))

    @test ARC.interpret(branch_true_rn, spec) == [ARC.rot90deg(g) for g in args1]
    @test ARC.interpret(branch_false_rn, spec) == [ARC.rot180deg(g) for g in args1]

    # -------------------------------------------------------------------------
    # Integer-valued accessors used inside Grid expressions
    # -------------------------------------------------------------------------

    canvas_index_rn = rn(:(canvas(index(_arg_1, astuple(1, 1)), shape(_arg_1))))
    canvas_mostcolor_rn = rn(:(canvas(mostcolor(_arg_1), shape(_arg_1))))
    canvas_numcolors_rn = rn(:(canvas(numcolors(_arg_1), shape(_arg_1))))

    @test ARC.interpret(canvas_index_rn, spec) == [
        ARC.canvas(
            ARC.index(g, ARC.astuple(1, 1)),
            ARC.shape(g),
        )
        for g in args1
    ]

    @test ARC.interpret(canvas_mostcolor_rn, spec) == [
        ARC.canvas(ARC.mostcolor(g), ARC.shape(g)) for g in args1
    ]

    @test ARC.interpret(canvas_numcolors_rn, spec) == [
        ARC.canvas(ARC.numcolors(g), ARC.shape(g)) for g in args1
    ]
end