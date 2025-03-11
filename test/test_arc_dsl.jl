using HerbBenchmarks.ARC_DSL

@testset verbose = true "Basic operators" begin
	@testset verbose = true "Numerical" begin
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
		@testset verbose = true "double and halve" begin
			# double
			@test double(Int8(1)) == Int8(2)
			@test double(Index(2, 3)) == Index(4, 6)

			# halve
			@test halve(Int8(2)) == Int8(1)
			@test halve(Int8(5)) == Int8(2)
			@test halve(Index(10, 9)) == Index(5, 4)
		end
		@testset verbose = true "Increment, decrement, crement, sign" begin
			@test increment(Int8(1)) == 2
			@test increment(Index(7, 9)) == Index(8, 10)

			@test decrement(Int8(1)) == 0
			@test decrement(Index(7, 9)) == Index(6, 8)

			@test crement(Int8(1)) == Int8(2)
			@test crement(Int8(-2)) == Int8(-3)
			@test crement(Index(Int8(-2), Int8(1))) == Index(Int8(-3), Int8(2))
			@test crement(Index(Int8(0), Int8(-1))) == Index(Int8(0), Int8(-2))

			@test get_sign(Int8(2)) == Int8(1)
			@test get_sign(Int8(0)) == Int8(0)
			@test get_sign(Int8(-1)) == Int8(-1)
			@test get_sign(Index(Int8(0), Int8(-3))) == Index(Int8(0), Int8(-1))
		end
	end

	@testset verbose = true "Integer" begin
		@testset verbose = true "even, greater, positive" begin
			# even
			@test even(Int8(1)) == false
			@test even(Int8(2)) == true
			# greater
			@test greater(Int8(2), Int8(1)) == true
			@test greater(Int8(4), Int8(10)) == false

			# positive
			@test positive(Int8(1)) == true
			@test positive(Int8(0)) == false
			@test positive(Int8(-2)) == false
		end
		@testset verbose = true "toivec, tojvec, astuple" begin
			@test toivec(Int8(2)) == Index(Int8(2), Int8(0))
			@test tojvec(Int8(3)) == Index(Int8(0), Int8(3))
			@test astuple(Int8(3), Int8(4)) == Index(Int8(3), Int8(4))
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
			a = IntegerSet([Int8(1), Int8(2), Int8(5), Int8(3)])
			b = IntegerSet([Int8(4), Int8(2), Int8(6)])
			@testset verbose = true "maximum" begin
				@test maximum(a) == Int8(5)
				@test maximum(b) == Int8(6)
			end
			@testset verbose = true "minimum" begin
				@test minimum(a) == Int8(1)
				@test minimum(b) == Int8(2)
			end

		end
		@testset verbose = true "set intersection and difference" begin
			a = IntegerSet([Int8(1), Int8(2)])
			b = IntegerSet([Int8(2), Int8(3)])
			c = IntegerSet([Int8(2)])
			@test intersect(a, b) == c
			# TODO: test for more set types

			@test difference(
				IntegerSet([Int8(1), Int8(2), Int8(3)]),
				IntegerSet([Int8(1), Int8(2)]),
			) ==
				  IntegerSet([Int8(3)])

		end
	end
end


