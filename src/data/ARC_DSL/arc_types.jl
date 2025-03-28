using StaticArrays

export Grid, Index, IntegerSet, Indices

const Index = SVector{2, Int8} # IntegerTuple TODO: why negative numbers? look at original implementation
struct Grid{M, N}
	mat::SMatrix{M, N, UInt8}

	# constructor
	function Grid(mat::SMatrix{M, N, UInt8}) where {M, N}
		new{M, N}(mat)
	end

	# TODO: do we need this?
	function Grid(mat::Matrix{<:Integer})
		M, N = size(mat)
		Grid(SMatrix{M, N, UInt8}(mat))
	end
end
Base.length(grid::Grid{M, N}) where {M, N} = length(grid.mat)

abstract type AbstractImmutableSet{T} end # FrozenSet
# hashable => implement `hash()` and `isequal()`
function Base.hash(x::AbstractImmutableSet{T}, h::UInt) where T
	return hash(x.set, h)
end

function Base.isequal(x::AbstractImmutableSet{T}, y::AbstractImmutableSet{T}) where T
	return isequal(x.set, y.set)
end

function Base.:(==)(x::AbstractImmutableSet{T}, y::AbstractImmutableSet{T}) where T
	return x.set == y.set
end

struct IntegerSet <: AbstractImmutableSet{Int8}
	set::Set{Int8}

	function IntegerSet(items::AbstractVector{<:Integer})
		new(Set{Int8}(items))
	end
	# function IntegerSet(items::Set{<:Integer})
	# 	new(Set{Int8}(items))
	# end

end

struct Indices <: AbstractImmutableSet{Index}
	set::Set{Index}

	Indices(items::AbstractVector{<:Index}) = new(Set{Index}(items))
	Indices(items::Set{<:Index}) = new(Set{Index}(items))
	# function Indices(items::AbstractVector{<:Tuple{Integer, Integer}})
	# 	# Convert each tuple to an Index (SVector{2, Int8})
	# 	indices = Set{Index}(Index(Tuple(convert(NTuple{2, Int8}, item))) for item in items)
	# 	new(indices)
	# end
	# Indices(items::AbstractVector{<:Tuple{Integer, Integer}}) = new(Set{Index}(Index.(items)))
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