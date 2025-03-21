# Custom types for the ARC DSL
using StaticArrays

const Index = SVector{2, Int8} # IntegerTuple TODO: why negative numbers? look at original implementation
# TODO: alternative
# struct Index
# 	x::Int8
# 	y::Int8
# end

abstract type AbstractImmutableSet{T} end # FrozenSet

struct IntegerSet <: AbstractImmutableSet{Int8}
	set::Set{Int8}

	IntegerSet(items::AbstractVector{<:Integer}) = new(Set{Int8}(items))
	IntegerSet(items::Set{<:Integer}) = new(Set{Int8}(items))
	# TODO: constructor for Integer
end

function Base.intersect(a::AbstractImmutableSet{T}, b::AbstractImmutableSet{T}) where T
	return typeof(a)(intersect(a.set, b.set))
end

function Base.setdiff(a::AbstractImmutableSet{T}, b::AbstractImmutableSet{T}) where T
	return typeof(a)(setdiff(a.set, b.set))
end

# # Define additional methods
# Base.in(item, set::AbstractImmutableSet) = item in set.set
# Base.issubset(a::AbstractImmutableSet, b::AbstractImmutableSet) = issubset(a.set, b.set)
# Base.isempty(set::AbstractImmutableSet) = isempty(set.set)
# Base.length(set::AbstractImmutableSet) = length(set.set)
Base.iterate(set::AbstractImmutableSet, state...) = iterate(set.set, state...)
Base.:(==)(a::AbstractImmutableSet, b::AbstractImmutableSet) = a.set == b.set
# Base.maximum(a::AbstractImmutableSet) = maximum(a.set)

