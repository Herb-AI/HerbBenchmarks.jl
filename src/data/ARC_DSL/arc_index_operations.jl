"""
    Returns a vertical frontier, i.e. all vertical indices (rows 1 to 30) of the column given by `location`.
"""
function vfrontier(location::CartesianIndex)
    # 30 is maximum grid size
    return Indices([CartesianIndex(i, location[2]) for i in 1:30])
end

"""
    Returns a horizontal frontier, i.e. all horizontal indices (cols 1 to 30) of the row given by `location`.
"""
function hfrontier(location::CartesianIndex)
    # 30 is maximum grid size
    return Indices([CartesianIndex(location[1], i) for i in 1:30])
end

# """
#     Line between two points (cells).
# """
# function connect(a::CartesianIndex, b::CartesianIndex)

# end

# def connect(
#     a: IntegerTuple,
#     b: IntegerTuple
# ) -> Indices:
#     """ line between two points """
#     ai, aj = a
#     bi, bj = b
#     si = min(ai, bi)
#     ei = max(ai, bi) + 1
#     sj = min(aj, bj)
#     ej = max(aj, bj) + 1
#     if ai == bi:
#         return frozenset((ai, j) for j in range(sj, ej))
#     elif aj == bj:
#         return frozenset((i, aj) for i in range(si, ei))
#     elif bi - ai == bj - aj:
#         return frozenset((i, j) for i, j in zip(range(si, ei), range(sj, ej)))
#     elif bi - ai == aj - bj:
#         return frozenset((i, j) for i, j in zip(range(si, ei), range(ej - 1, sj - 1, -1)))
#     return frozenset()
