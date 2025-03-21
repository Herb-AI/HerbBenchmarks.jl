using HerbBenchmarks.ARC_DSL

@testset verbose = true "Basic operators" begin
	@testset verbose = true "Numerical" begin
		@testset verbose = true "add" begin
			@test add(1, 2) == 3
			@test add(4, 6) == 10

			@test add(Index(1, 2), Index(3, 4)) == Index(4, 6)

			@test add(9, Index(1, 1)) == Index(10, 10)
		end
		@testset verbose = true "subtract" begin
			@test subtract(1, 2) == -1
			@test subtract(4, 6) == -2
			@test subtract(10, 1) == 9

			@test subtract(Index(8, 9), Index(3, 4)) == Index(5, 5)

			@test subtract(5, Index(10, 6)) == Index(-5, -1)
			@test subtract(5, Index(1, 2)) == Index(4, 3)

			@test subtract(Index(5, 5), 4) == Index(1, 1)
		end
		@testset verbose = true "multiply" begin

			@test multiply(2, 3) == 6
			@test multiply(4, 3) == 12

			@test multiply(Index(2, 3), Index(4, 3)) == Index(8, 9)

			@test multiply(2, Index(3, 4)) == Index(6, 8)
			@test multiply(Index(3, 4), 2) == Index(6, 8)
		end
		@testset verbose = true "divide" begin
			@test divide(4, 2) == 2
			@test divide(3, 2) == 1

			@test divide(Index(10, 6), Index(5, 2)) == Index(2, 3)

			@test divide(Index(10, 10), 3) == Index(3, 3)
			@test divide(10, Index(2, 4)) == Index(5, 2)
			@test divide(3, Index(10, 10)) == Index(0, 0)

			@test_throws DivideError divide(4, Index(0, 9))
			@test_throws DivideError divide(Index(3, 4), 0)
			@test_throws DivideError divide(Index(3, 4), Index(0, 0))
			@test_throws DivideError divide(0, 0)
		end
		@testset verbose = true "invert" begin
			@test invert(1) == -1
			@test invert(-4) == 4

			@test invert(Index(5, 6)) == Index(-5, -6)
			@test invert(Index(-1, 9)) == Index(1, -9)
		end
		@testset verbose = true "double and halve" begin
			# double
			@test double(1) == 2
			@test double(Index(2, 3)) == Index(4, 6)

			# halve
			@test halve(2) == 1
			@test halve(5) == 2
			@test halve(Index(10, 9)) == Index(5, 4)
		end
		@testset verbose = true "Increment, decrement, crement, sign" begin
			@test increment(1) == 2
			@test increment(Index(7, 9)) == Index(8, 10)

			@test decrement(1) == 0
			@test decrement(Index(7, 9)) == Index(6, 8)

			@test crement(1) == 2
			@test crement(-2) == -3
			@test crement(Index(-2, 1)) == Index(-3, 2)
			@test crement(Index(0, -1)) == Index(0, -2)

			@test get_sign(2) == 1
			@test get_sign(0) == 0
			@test get_sign(-1) == -1
			@test get_sign(Index(0, -3)) == Index(0, -1)
		end
	end

	@testset verbose = true "Integer" begin
		@testset verbose = true "even, greater, positive" begin
			# even
			@test even(1) == false
			@test even(2) == true
			# greater
			@test greater(2, 1) == true
			@test greater(4, 10) == false

			# positive
			@test positive(1) == true
			@test positive(0) == false
			@test positive(-2) == false
		end
		@testset verbose = true "toivec, tojvec, astuple" begin
			@test toivec(2) == Index(2, 0)
			@test tojvec(3) == Index(0, 3)
			@test astuple(3, 4) == Index(3, 4)
		end

	end

	@testset verbose = true "Boolean" begin
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

	@testset verbose = true "IntegerSet" begin # TODO
		@testset verbose = true "IntegerSet operations" begin
			a = IntegerSet([1, 2, 5, 3])
			b = IntegerSet([4, 2, 6])
			@testset verbose = true "maximum" begin
				@test maximum(a) == 5
				@test maximum(b) == 6
			end
			@testset verbose = true "minimum" begin
				@test minimum(a) == 1
				@test minimum(b) == 2
			end

		end
		@testset verbose = true "set intersection and difference" begin
			a = IntegerSet([1, 2])
			b = IntegerSet([2, 3])
			c = IntegerSet([2])
			@test intersect(a, b) == c
			# TODO: test for more set types

			@test difference(
				IntegerSet([1, 2, 3]),
				IntegerSet([1, 2]),
			) ==
				  IntegerSet([3])

		end
	end
end


