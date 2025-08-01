using StaticArrays

# export Grid, IntegerSet, Indices

# TODO: Grid not necessary
# struct Grid{M,N}
#     mat::SMatrix{M,N,UInt8} # each element represents a cell and value the cell's colour 

#     function Grid(mat::AbstractArray{<:Integer})
#         M, N = size(mat)
#         Grid(SMatrix{M,N,UInt8}(mat))
#     end

#     function Grid(mat::SMatrix{M,N,UInt8}) where {M,N}
#         new{M,N}(mat)
#     end
# end
# Base.length(grid::Grid{M,N}) where {M,N} = length(grid.mat)

abstract type AbstractImmutableSet{T} end # FrozenSet
# hashable => implement `hash()` and `isequal()`
function Base.hash(x::AbstractImmutableSet, h::UInt)
    return hash(x.set, h)
end

function Base.isequal(x::AbstractImmutableSet, y::AbstractImmutableSet)
    return isequal(x.set, y.set)
end

function Base.:(==)(x::AbstractImmutableSet, y::AbstractImmutableSet)
    return x.set == y.set
end

# struct IntegerSet <: AbstractImmutableSet{Int8}
#     set::Set{Int8}

#     function IntegerSet(items::AbstractVector{<:Integer})
#         new(Set{Int8}(items))
#     end
# end