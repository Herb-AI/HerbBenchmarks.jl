using MLStyle

"""
	Returns the sum of `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
add(a, b) = a + b
add(a::CartesianIndex{N}, b::Integer) where N = a + CartesianIndex(ntuple(_ -> b, N))
add(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) + b


"""
	Subtracts `b` from `a`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
subtract(a, b) = a - b
subtract(a::CartesianIndex{N}, b::Integer) where N = a - CartesianIndex(ntuple(_ -> b, N))
subtract(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) - b

"""
	Returns the product of  `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
multiply(a, b) = a * b
multiply(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] * b[i], N))

"""
   Returns the result of integer division of  `a` and `b`, where each `a` and `b` can either be `Integer` or `CartesianIndex`.
"""
divide(a, b) = a ÷ b
divide(a::CartesianIndex{N}, b) where N = CartesianIndex(ntuple(i -> a[i] ÷ b, N))
divide(a, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> a ÷ b[i], N))
divide(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] ÷ b[i], N))

"""
	Inverts the sign of `a`. 
"""
invert(a) = -1 * a


"""
	Scales `a` by two. 
"""

double(a) = a * 2

"""
	Floor division of `a` by two.
"""
halve(a::Integer) = a ÷ 2
halve(a::CartesianIndex) = divide(a, 2)

# """
# 	Increment by one.
# """
# increment(a) = a + 1
increment(a) = add(a, 1)

"""
	Decrement by one.
"""
decrement(a) = subtract(a, 1)

"""
	Increments positive values, decrements negative. Zero unchanged.
"""
crement(a) = a + (a > 0) - (a < 0)
crement(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> crement(a[i]), N))

"""
	Returns sign of (each element of) `a`, preserving the type of `a`.
"""
get_sign(a) = sign(a)
get_sign(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> sign(a[i]), N))

# Integer

"""
	Returns whether an `a` is even.
"""
even(a) = a % 2 == 0

"""
	Returns wheter `a` is greater than `b`.
"""
greater(a, b) = a > b

"""
	Returns whether `a` is greater than zero.
"""
positive(a) = a > 0

"""
	Returns vertically pointing vector.
"""
toivec(i) = CartesianIndex(i, 0)

"""
	Returns horizontally pointing vector.
"""
tojvec(j) = CartesianIndex(0, j)

"""
	Constructs `CartesianIndex` from `a` and `b`.
"""
astuple(a, b) = CartesianIndex(a, b)

## Boolean

"""
	Flip bool to opposite value.
"""
flip(a) = !a


"""
	Boolean `AND` (short-circuiting). 
"""
both(a, b) = a && b

"""
	Boolean `OR` (short-circuiting). 
"""
either(a, b) = a || b

"""Wrapper around `==`"""
equality(a, b) = a == b

"""Whether value is an element of container. """
contained(value, container) = value in container

"""Combine two vectors"""
combine(a, b) = vcat(a, b)

"""Intersection of two containers (vectors) a and b"""
intersection(a, b) = intersect(a, b)
# intersection (object, indices, indices sets, set of objects)

"""difference between elements in two containers (vectors) a and b"""
difference(a, b) = setdiff(a, b)

"""Removes duplicate rows/elements from matrix/vector"""
dedupe(grid::Matrix) = stack(unique(eachrow(grid)))'
dedupe(a) = unique(a)

# - [ ]  difference
# - [ ]  dedupe