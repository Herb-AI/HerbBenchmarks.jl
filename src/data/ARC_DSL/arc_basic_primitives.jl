using MLStyle

# Numerical 

"""
	Returns the sum of `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
add(a::Integer, b::Integer) = a + b
add(a::CartesianIndex{N}, b::Integer) where N = a + CartesianIndex(ntuple(_ -> b, N))
add(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) + b
add(a::CartesianIndex{N}, b::CartesianIndex{N}) where N = a + b


"""
	Subtracts `b` from `a`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
subtract(a::Integer, b::Integer) = a - b
subtract(a::CartesianIndex{N}, b::Integer) where N = a - CartesianIndex(ntuple(_ -> b, N))
subtract(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) - b
subtract(a::CartesianIndex{N}, b::CartesianIndex{N}) where N = a - b

"""
	Returns the product of  `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
multiply(a::Integer, b::Integer) = a * b
multiply(a::CartesianIndex, b::Integer) = a * b
multiply(a::Integer, b::CartesianIndex) = a * b
multiply(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
	CartesianIndex(ntuple(i -> a[i] * b[i], N))

"""
   Returns the result of integer division of  `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
divide(a::Integer, b::Integer) = a ÷ b
divide(a::CartesianIndex{N}, b::Integer) where N = CartesianIndex(ntuple(i -> a[i] ÷ b, N))
divide(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> a ÷ b[i], N))
divide(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
	CartesianIndex(ntuple(i -> a[i] ÷ b[i], N))

"""
	Inverts the sign of `a`. 
"""
invert(a::Integer) = -1 * a
invert(a::CartesianIndex) = -1 * a


"""
	Scales `a` by two. 
"""

double(a::Integer) = a * 2
double(a::CartesianIndex) = a * 2

"""
	Floor division of `a` by two.
"""
halve(a::Integer) = a ÷ 2
halve(a::CartesianIndex) = divide(a, 2)

"""
	Increment by one.
"""
increment(a::Integer) = a + 1
increment(a::CartesianIndex) = add(a, 1)

"""
	Decrement by one.
"""
decrement(a::Integer) = a - 1
decrement(a::CartesianIndex) = subtract(a, 1)

"""
	Increments positive values, decrements negative. Zero unchanged.
"""
crement(a::Integer) = a + (a > 0) - (a < 0)
crement(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> crement(a[i]), N))

"""
	Returns sign of (each element of) `a`, preserving the type of `a`.
"""
get_sign(a::Integer) = sign(a)
get_sign(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> sign(a[i]), N))

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
toivec(i::Integer) = CartesianIndex(i, 0)

"""
	Returns horizontally pointing vector.
"""
tojvec(j::Integer) = CartesianIndex(0, j)

"""
	Constructs `CartesianIndex` from `a` and `b`.
"""
astuple(a::Integer, b::Integer) = CartesianIndex(a, b)

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


