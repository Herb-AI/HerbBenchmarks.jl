# basic arithmetic and set primitives

using MLStyle
using StatsBase

"""Returns the sum of a and b"""
add(a, b) = a + b
add(a::CartesianIndex{N}, b::Integer) where N = a + CartesianIndex(ntuple(_ -> b, N))
add(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) + b


"""Subtracts b from a"""
subtract(a, b) = a - b
subtract(a::CartesianIndex{N}, b::Integer) where N = a - CartesianIndex(ntuple(_ -> b, N))
subtract(a::Integer, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(_ -> a, N)) - b

"""Returns the product of  a and b"""
multiply(a, b) = a * b
multiply(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] * b[i], N))

""" Returns the result of integer division of  a and b"""
divide(a, b) = a ÷ b
divide(a::CartesianIndex{N}, b) where N = CartesianIndex(ntuple(i -> a[i] ÷ b, N))
divide(a, b::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> a ÷ b[i], N))
divide(a::CartesianIndex{N}, b::CartesianIndex{N}) where N =
    CartesianIndex(ntuple(i -> a[i] ÷ b[i], N))

"""Inverts the sign of a"""
invert(a) = -1 * a


"""Scales a by two"""

double(a) = a * 2

"""Floor division of a by two"""
halve(a::Integer) = a ÷ 2
halve(a::CartesianIndex) = divide(a, 2)

"""Increment by one"""
increment(a) = add(a, 1)

"""Decrement by one"""
decrement(a) = subtract(a, 1)

"""Increments positive values, decrements negative. Zero unchanged"""
crement(a) = a + (a > 0) - (a < 0)
crement(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> crement(a[i]), N))

"""Returns sign of (each element of) a, preserving the type of a"""
signof(a) = sign(a)
signof(a::CartesianIndex{N}) where N = CartesianIndex(ntuple(i -> sign(a[i]), N))

"""Returns whether an a is even"""
even(a) = a % 2 == 0

"""Returns wheter a is greater than b"""
greater(a, b) = a > b

"""Returns whether a is greater than zero"""
positive(a) = a > 0

"""Returns vertically pointing vector"""
toivec(i) = CartesianIndex(i, 0)

"""Returns horizontally pointing vector"""
tojvec(j) = CartesianIndex(0, j)

"""Constructs CartesianIndex from a and b"""
astuple(a, b) = CartesianIndex(a, b)

"""Flip bool to opposite value"""
flip(a) = !a

"""Boolean AND (short-circuiting)"""
both(a, b) = a && b

"""Boolean OR (short-circuiting)"""
either(a, b) = a || b

"""Wrapper around `==`"""
equality(a, b) = a == b

"""Whether value is an element of container"""
contained(value, container) = value in container

"""Combine two vectors"""
combine(a, b) = vcat(a, b)

"""Intersection of two containers (vectors) a and b"""
intersection(a, b) = intersect(a, b)

"""difference between elements in two containers (vectors) a and b"""
difference(a, b) = setdiff(a, b)

"""Removes duplicate rows/elements from matrix/vector"""
dedupe(grid::Matrix) = stack(unique(eachrow(grid)))'
dedupe(a) = unique(a)

"""Order container by custom key `compfunc`"""
order(container, compfunc) = sort(collect(container), by=compfunc)

"""Repeat item to have item a total of num times"""
repeat_item(item, num) = hcat([item for i in 1:num]...)

"""Greater-than operator: a > b"""
greater(a, b) = a > b

"""Size of container"""
size_of(container) = length(container)

"""maximum"""
maximum_of(container) = maximum(container)

"""maximum"""
minimum_of(container) = minimum(container)

"""maximum by custom function"""
function valmax(container, compfunc; default=0)
    isempty(container) && return compfunc(default)
    return maximum(compfunc(x) for x in container)
end

"""minimum by custom function"""
function valmin(container, compfunc; default=0)
    isempty(container) && return compfunc(default)
    return minimum(compfunc(x) for x in container)
end

"""returns the container that maximizes the custom function"""
argmax_by(containers, compfunc) = containers[argmax(compfunc.(containers))]

"""returns the container that maximizes the custom function"""
argmin_by(containers, compfunc) = containers[argmin(compfunc.(containers))]

"""most common item in container"""
mostcommon(container) = mode(container)

"""least common item in container"""
leastcommon(container) = argmin(countmap(container))

"""identity function"""
identityfn(x) = identity(x)