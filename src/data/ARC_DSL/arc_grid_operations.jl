"""
	Returns all indices of a `Grid`.
"""
function asindices(grid::Grid)
	items = SVector{length(A)}(
		Index(Int8(i), Int8(j)) for i in 1:size(grid.mat, 1) for j in 1:size(grid.mat, 2)
	)
	return Indices(items)
end
