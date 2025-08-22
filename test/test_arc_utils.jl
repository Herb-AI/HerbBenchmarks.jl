@testset verbose = true "ARC example 3af2c5a8" begin
    # load and parse problem
    filename = "3af2c5a8.json"
    dir = joinpath(dirname(@__DIR__), "src", "data", "ARC_DSL", "examples")
    train, test = parse_ARC_data_file(filename, dir)
    # test first example
    first_ioex = train.spec[1]
    @test first_ioex.in[:_arg_1] == [0 0 8 0; 0 8 0 8; 0 0 8 0]
end