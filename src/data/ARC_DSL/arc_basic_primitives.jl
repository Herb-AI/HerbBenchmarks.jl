using MLStyle

# Numerical 

"""
	Returns the sum of `a` and `b`, where each `a` and `b` can either be `Integer` or `Index`.
"""
add(a::Integer, b::Integer) = a + b
add(a::Index, b::Integer) = a .+ b
add(a::Integer, b::Index) = a .+ b
add(a::Index, b::Index) = a + b


"""
	Subtracts `b` from `a`, where each `a` and `b` can either be `Integer` or `Index`.
"""
subtract(a::Integer, b::Integer) = a - b
subtract(a::Index, b::Integer) = a .- b
subtract(a::Integer, b::Index) = a .- b
subtract(a::Index, b::Index) = a - b

"""
	Returns the product of  `a` and `b`, where each `a` and `b` can either be `Integer` or `Index`.
"""
multiply(a::Integer, b::Integer) = a * b
multiply(a::Index, b::Integer) = a * b
multiply(a::Integer, b::Index) = a * b
multiply(a::Index, b::Index) = a .* b

"""
   Returns the result of integer division of  `a` and `b`, where each `a` and `b` can either be `Integer` or `Index`.
"""
divide(a::Integer, b::Integer) = a ÷ b
divide(a::Index, b::Integer) = a .÷ b
divide(a::Integer, b::Index) = a .÷ b
divide(a::Index, b::Index) = a .÷ b

"""
	Inverts the sign of `a`. 
"""
invert(a::Integer) = -1 * a
invert(a::Index) = -1 * a


"""
	Scales `a` by two. 
"""

double(a::Integer) = a * 2
double(a::Index) = a * 2

"""
	Floor division of `a` by two.
"""
halve(a::Integer) = a ÷ 2
halve(a::Index) = a .÷ 2

"""
	Increment by one.
"""
increment(a::Integer) = a + 1
increment(a::Index) = a .+ 1

"""
	Decrement by one.
"""
decrement(a::Integer) = a - 1
decrement(a::Index) = a .- 1

"""
	Increments positive values, decrements negative. Zero unchanged.
"""
crement(a::Integer) = a + (a > 0) - (a < 0)
crement(a::Index) = Index(crement(a[1]), crement(a[2])) # TODO: does behaviour for zero make sense?

"""
	Returns sign of (each element of) `a`, preserving the type of `a`.
"""
get_sign(a::Integer) = sign(a)
get_sign(a::Index) = Index(sign(a[1]), sign(a[2]))

## Integer

"""
	Returns whether an `a` is even.
"""
even(a::Integer) = a % 2 == 0

"""
	Returns wheter `a` is greater than `b`.
"""
greater(a::Integer, b::Integer) = a > b

"""
	Returns whether `a` is greater than zero.
"""
positive(a::Integer) = a > 0

"""
	Returns vertically pointing vector.
"""
toivec(i::Integer) = Index(Int8(i), Int8(0))

"""
	Returns horizontally pointing vector.
"""
tojvec(j::Integer) = Index(Int8(0), Int8(j))

"""
	Constructs `Index` from `a` and `b`.
"""
astuple(a::Integer, b::Integer) = Index(a, b)

## Boolean

"""
	Flip bool to opposite value.
"""
flip(a::Bool) = !a


"""
	Boolean `AND` (short-circuiting). 
"""
both(a::Bool, b::Bool) = a && b

"""
	Boolean `OR` (short-circuiting). 
"""
either(a::Bool, b::Bool) = a || b

# # IntegerSet
# """
# 	Returns intersection of the `AbstractImmutableSet`s `a` and `b`
# """
# intersection(a::AbstractImmutableSet, b::AbstractImmutableSet) = intersect(a, b)

# """
# 	Returns the set difference.
# """
# difference(a::AbstractImmutableSet, b::AbstractImmutableSet) = setdiff(a, b)


"""
	Returns the bigest element.
"""
Base.maximum(a::IntegerSet) = maximum(a.set) # TODO: ok to do like this>

"""
	Returns the smallest element.
"""
Base.minimum(a::IntegerSet) = minimum(a.set) # TODO: ok to do like this>


