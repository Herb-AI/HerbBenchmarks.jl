"""
	Returns all indices of a `Grid`.
"""
function asindices(grid::Grid)
	items = SVector{length(grid)}(Index(i, j) for i in axes(grid.mat, 2), j in axes(grid.mat, 1))
	return Indices(items)
end
