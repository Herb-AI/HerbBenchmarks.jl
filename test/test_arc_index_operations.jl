@testset verbose = true "index operations" begin
    @testset "vfrontier, hfrontier" begin
        # vfrontier
        @test vfrontier(CartesianIndex(3, 4)) == [CartesianIndex(i, 4) for i in 1:30]

        # hfrontier
        @test hfrontier(CartesianIndex(3, 4)) == [CartesianIndex(3, j) for j in 1:30]
    end
    # @testset "connect" begin
    #     # horizontal line
    #     @test connect(CartesianIndex(1, 1), CartesianIndex(1, 4)) == [CartesianIndex(1, 1), CartesianIndex(1, 2), CartesianIndex(1, 3), CartesianIndex(1, 4)]
    #     #     # vertical line
    #     #     @test connect(CartesianIndex(2, 4), CartesianIndex(4, 4)) == Indices([(2, 4), (3, 4), (4, 4)])
    #     #     # diagonal lines
    #     #     @test connect(CartesianIndex(1, 1), CartesianIndex(2, 2)) == Indices([(1, 1), (2, 2)]) # pos slope
    #     #     @test connect(CartesianIndex(4, 1), CartesianIndex(1, 4)) == Indices([(1, 4), (2, 3), (3, 2), (4, 1)]) # neg slope
    #     #     # other 
    #     #     @test connect(CartesianIndex(1, 1), CartesianIndex(4, 2)) == Indices()
    # end
end