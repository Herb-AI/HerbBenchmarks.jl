"""
	Returns all indices of a `Grid`.
"""
function asindices(grid::Grid)
	items = SVector{length(grid)}(
		CartesianIndex(i, j) for i in axes(grid.mat, 2), j in axes(grid.mat, 1)
	)
	return Indices(items)
end

# """
# 	Returns indices of all grid cells of given `value` (color)
# """
# function ofcolor(grid:Grid, value:Integer)

# end

# def ofcolor(
#     grid: Grid,
#     value: Integer
# ) -> Indices:
#     """ indices of all grid cells with value """
#     return frozenset((i, j) for i, r in enumerate(grid) for j, v in enumerate(r) if v == value)