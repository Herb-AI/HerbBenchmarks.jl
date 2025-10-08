"""
    Returns a vertical frontier, i.e. all vertical indices (rows 1 to 30) of the column given by `location`.
"""
function vfrontier(location)
    # 30 is maximum grid size
    return [CartesianIndex(i, location[2]) for i in 1:30]
end

"""
    Returns a horizontal frontier, i.e. all horizontal indices (cols 1 to 30) of the row given by `location`.
"""
function hfrontier(location)
    # 30 is maximum grid size
    return [CartesianIndex(location[1], i) for i in 1:30]
end

"""
    Returns all points (cells) on a line between two points (cells) if the line is horizontal, vertical or diagonal. 
    Otherwise returns empty `Indices` set.
"""
# function connect(a, b)
#     if a[1] == b[1] # a, b are in same row => horizontal line
#         return @SVector [CartesianIndex(a[1], j) for j in min(a[2], b[2]):max(a[2], b[2])]
#     elseif a[2] == b[2] # a, b are in the same col => vertical line
#         return @SVector [CartesianIndex(i, a[2]) for i in min(a[1], b[1]):max(a[1], b[1])]
#     elseif b[1] - a[1] == b[2] - a[2] # diagonal line, positive slope
#         row_indices = min(a[1], b[1]):max(a[1], b[1])
#         col_indices = min(a[2], b[2]):max(a[2], b[2])
#         return @SVector [CartesianIndex(i, j) for (i, j) in zip(row_indices, col_indices)]
#     elseif b[1] - a[1] == -(b[2] - a[2])
#         row_indices = min(a[1], b[1]):max(a[1], b[1])
#         col_indices = max(a[2], b[2]):-1:min(a[2], b[2])
#         return @SVector [CartesianIndex(i, j) for (i, j) in zip(row_indices, col_indices)]
#     end
#     return SVector()
# end