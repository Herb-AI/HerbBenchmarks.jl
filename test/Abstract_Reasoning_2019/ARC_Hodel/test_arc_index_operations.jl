using .Abstract_Reasoning_2019.ARC_Hodel

@testset verbose = true "index operations" begin
    @testset "vfrontier, hfrontier" begin
        # vfrontier
        @test vfrontier(CartesianIndex(3, 4)) == [CartesianIndex(i, 4) for i in 1:30]

        # hfrontier
        @test hfrontier(CartesianIndex(3, 4)) == [CartesianIndex(3, j) for j in 1:30]
    end
end