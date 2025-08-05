using StaticArrays

# export Grid, IntegerSet, Indices

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