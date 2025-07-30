@testset verbose = true "index operations" begin
    @testset "vfrontier, hfrontier" begin
        # vfrontier
        res = vfrontier(CartesianIndex(3, 4))
        @test length(res.set) == 30
        @test all(i -> i[2] == 4, res.set)
        @test all(i -> 1 <= i[1] <= 30, res.set)

        # hfrontier
        res = hfrontier(CartesianIndex(3, 4))
        @test length(res.set) == 30
        @test all(i -> i[1] == 3, res.set)
        @test all(i -> 1 <= i[2] <= 30, res.set)
    end
end