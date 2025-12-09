using HerbBenchmarks.ARC_AGI_1.ARC_Hodel

@testset "utils primitives" begin
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
    @testset "branch, compose, chain, matcher" begin
        @test branch(true, 1, 3) == 1
        @test branch(false, 4, 2) == 2
        @test branch(5 > 9, 1, 2) == 2

        myfun = compose(x -> x^2, x -> x + 1)
        @test myfun(2) == 9
        myotherfun = compose(x -> x + 1, x -> x^2)
        @test myotherfun(2) == 5

        mychainfun = chain(x -> x + 3, x -> x^2, x -> x + 1)
        @test mychainfun(2) == 12

        @test matcher(x -> x + 1, 3)(2) == true
        @test matcher(x -> x - 1, 3)(2) == false
    end
    @testset "rbind, lbind" begin
        @test rbind((x, y) -> x + y, 2)(3) == 5
        @test rbind((x, y) -> x == y, 2)(2) == true
        @test rbind((x, y) -> x / y, 2)(10) == 5
        @test rbind((x, y, z) -> x - y - z, 5)(10, 2) == 3

        @test lbind((x, y) -> x + y, 2)(3) == 5
        @test lbind((x, y) -> x == y, 2)(2) == true
        @test lbind((x, y) -> x / y, 2)(10) == 0.2
        @test lbind((x, y, z) -> x - y - z, 10)(2, 5) == 3
    end
end
