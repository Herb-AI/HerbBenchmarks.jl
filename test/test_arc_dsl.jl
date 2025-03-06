using HerbBenchmarks.ARC_DSL

# Define test constants
A = ((1, 0), (0, 1), (1, 0))
B = ((2, 1), (0, 1), (2, 1))



@testset verbose = true "Basic operators" begin
	# @testset verbose = true "identity" begin
	#     @test identity(1) == 1
	#     @test identity("Herb.jl rocks") == "Herb.jl rocks"
	#     @test identity((3, 6)) == (3, 6)
	#     @test identity(1.0) == 1 
	# end
	@testset verbose = true "add" begin
		@test add(Int8(1), Int8(2)) == 3
		@test add(Int8(4), Int8(6)) == 10

		@test add(Index(1, 2), Index(3, 4)) == Index(4, 6)

		@test add(Int8(9), Index(1, 1)) == Index(10, 10)
	end
	@testset verbose = true "subtract" begin
		@test subtract(Int8(1), Int8(2)) == Int8(-1)
		@test subtract(Int8(4), Int8(6)) == Int8(-2)
		@test subtract(Int8(10), Int8(1)) == 9

		@test subtract(Index(8, 9), Index(3, 4)) == Index(5, 5)

		@test subtract(Int8(5), Index(10, 6)) == Index(-5, -1)
		@test subtract(Int8(5), Index(1, 2)) == Index(4, 3)

		@test subtract(Index(5, 5), Int8(4)) == Index(1, 1)
	end
	@testset verbose = true "multiply" begin

		@test multiply(Int8(2), Int8(3)) == 6
		@test multiply(Int8(4), Int8(3)) == 12

		@test multiply(Index(2, 3), Index(4, 3)) == Index(8, 9)

		@test multiply(Int8(2), Index(3, 4)) == Index(6, 8)
		@test multiply(Index(3, 4), Int8(2)) == Index(6, 8)
	end
	@testset verbose = true "divide" begin
		@test divide(Int8(4), Int8(2)) == Int8(2)
		@test divide(Int8(3), Int8(2)) == Int8(1)

		@test divide(Index(10, 6), Index(5, 2)) == Index(2, 3)

		@test divide(Index(10, 10), Int8(3)) == Index(3, 3)
		@test divide(Int8(10), Index(2, 4)) == Index(5, 2)
		@test divide(Int8(3), Index(10, 10)) == Index(0, 0)

		@test_throws DivideError divide(Int8(4), Index(0, 9))
		@test_throws DivideError divide(Index(3, 4), Int8(0))
		@test_throws DivideError divide(Index(3, 4), Index(0, 0))
		@test_throws DivideError divide(Int8(0), Int8(0))
	end
	@testset verbose = true "invert" begin
		@test invert(Int8(1)) == Int8(-1)
		@test invert(Int8(-4)) == Int8(4)

		@test invert(Index(5, 6)) == Index(-5, -6)
		@test invert(Index(-1, 9)) == Index(1, -9)
	end
	@testset verbose = true "even" begin
		@test even(Int8(1)) == false
		@test even(Int8(2)) == true
	end
	@testset verbose = true "double and halve" begin
		# double
		@test double(Int8(1)) == Int8(2)
		@test double(Index(2, 3)) == Index(4, 6)

		# halve
		@test halve(Int8(2)) == Int8(1)
		@test halve(Int8(5)) == Int8(2)
		@test halve(Index(10, 9)) == Index(5, 4)
	end
	@testset verbose = true "flip, equality" begin
		@test flip(false) == true
		@test flip(true) == false
		@test equality(A, A) == true
		@test equality(A, B) == false
	end
end
