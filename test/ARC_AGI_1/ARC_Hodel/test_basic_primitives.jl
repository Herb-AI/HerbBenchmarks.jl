using HerbBenchmarks.ARC_AGI_1.ARC_Hodel

A = [1 0; 0 1; 1 0]
B = [2 1; 0 1; 2 1]
C = [3 4; 5 5]

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

        @test order([[1], [1, 2, 3], [1, 2]], length) == [[1], [1, 2], [1, 2, 3]]
        @test order([1, 4, -3], abs) == [1, -3, 4]

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


    @testset "identity" begin
        @test identityfn(1) == 1
        @test identityfn(A) == A
    end

end


