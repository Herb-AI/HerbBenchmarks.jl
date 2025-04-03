using StaticArrays

# D = ((1, 2, 3), (4, 5, 6), (7, 8, 0))

@testset verbose = true "Grid operations" begin
	A = Grid([[1, 0] [0, 1] [1, 0]])
	B = Grid([[2, 1] [0, 1] [2, 1]])
	C = Grid([[3, 4] [5, 5]])
	@testset "isequal and hash" begin
		A_dup = Grid([[1, 0] [0, 1] [1, 0]])
		@test isequal(A, A_dup) == true
		@test isequal(A, B) == false
		@test hash(A) == hash(A_dup)
		@test hash(A) != hash(B)
	end

	@testset "basics" begin
		expected_indices =
			Indices([
				CartesianIndex(1, 1),
				CartesianIndex(1, 2),
				CartesianIndex(2, 1),
				CartesianIndex(2, 2),
				CartesianIndex(3, 1),
				CartesianIndex(3, 2),
			])
		@test ARC_DSL.asindices(A) == expected_indices
		expected_indices =
			Indices([
				CartesianIndex(1, 1),
				CartesianIndex(1, 2),
				CartesianIndex(2, 1),
				CartesianIndex(2, 2),
			])
		@test ARC_DSL.asindices(C) == expected_indices
		# println("Indices: ", indices)
		# println("Expected indices: ", expected_indices)

	end
end
