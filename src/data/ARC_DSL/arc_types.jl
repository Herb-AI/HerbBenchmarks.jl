using StaticArrays

export Grid, IntegerSet, Indices

struct Grid{M,N}
    mat::SMatrix{M,N,UInt8} # each element represents a cell and value the cell's colour 

    function Grid(mat::AbstractArray{<:Integer})
        M, N = size(mat)
        Grid(SMatrix{M,N,UInt8}(mat))
    end

    function Grid(mat::SMatrix{M,N,UInt8}) where {M,N}
        new{M,N}(mat)
    end

    # # constructor
    # function Grid(mat::SMatrix{M,N,UInt8}) where {M,N}
    #     new{M,N}(mat)
    # end

    # # TODO: constructor from vector

    # function Grid(mat::MMatrix{M,N,<:Integer}) where {M,N}
    #     Grid(SMatrix{M,N,UInt8}(mat))
    # end

    # function Grid(mat::Matrix{<:Integer})
    #     M, N = size(mat)
    #     Grid(SMatrix{M,N,UInt8}(mat))
    # end
end
Base.length(grid::Grid{M,N}) where {M,N} = length(grid.mat)

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

struct IntegerSet <: AbstractImmutableSet{Int8}
    set::Set{Int8}

    function IntegerSet(items::AbstractVector{<:Integer})
        new(Set{Int8}(items))
    end
end

struct Indices <: AbstractImmutableSet{CartesianIndex{2}}
    set::Set{CartesianIndex{2}}

    Indices(items::AbstractVector{<:CartesianIndex{2}}) = new(Set{CartesianIndex{2}}(items))
    Indices(items::Set{<:CartesianIndex{2}}) = new(Set{CartesianIndex{2}}(items))
    Indices() = new(Set{CartesianIndex{2}}())
end



# function Base.intersect(a::AbstractImmutableSet{T}, b::AbstractImmutableSet{T}) where T
# 	return typeof(a)(intersect(a.set, b.set))
# end

# function Base.setdiff(a::AbstractImmutableSet{T}, b::AbstractImmutableSet{T}) where T
# 	return typeof(a)(setdiff(a.set, b.set))
# end

# # # # Define additional methods
# # # Base.in(item, set::AbstractImmutableSet) = item in set.set
# # # Base.issubset(a::AbstractImmutableSet, b::AbstractImmutableSet) = issubset(a.set, b.set)
# # # Base.isempty(set::AbstractImmutableSet) = isempty(set.set)
# # # Base.length(set::AbstractImmutableSet) = length(set.set)
# Base.iterate(set::AbstractImmutableSet, state...) = iterate(set.set, state...)
# # Base.:(==)(a::AbstractImmutableSet, b::AbstractImmutableSet) = a.set == b.set
# # # Base.maximum(a::AbstractImmutableSet) = maximum(a.set)