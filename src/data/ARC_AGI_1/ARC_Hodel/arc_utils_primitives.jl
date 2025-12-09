"""Return first element of container that fulfills given condition"""
function extract(container, condition)
    idx = findfirst(condition, container)
    return idx === nothing ? nothing : container[idx]
end

"""Return first element of a container"""
firstof(container) = first(container)

"""Return last element of a container"""
lastof(container) = last(container)

"""Insert element to container"""
insert(value, container) = push!(copy(container), value)

"""Remove value from container"""
remove(value, container) = filter(!=(value), container)

"""Returns other value in container, i.e., first element after removing given value"""
other(value, container) = firstof(remove(value, container))

"""Returns range between start and stop with given step size"""
interval(start, stop, step) = range(start, stop, step=step)

"""Cartesian product of two containers a and b"""
cartesian_product(a, b) = vec(collect(CartesianIndex.(Iterators.product(a, b))))

"""Zip up two CartesianIndex"""
pair(a, b) = collect(CartesianIndex.(zip(a.I, b.I)))

"""if-else condition"""
branch(condition, a, b) = condition ? a : b

# note: compose and chain not really necessary. can be handled in grammar
"""Compose a function from inner and outer"""
compose(outer, inner) = x -> outer(inner(x))

"""Compose from three functions by chaining: h(g(f(x)))"""
chain(h, g, f) = x -> h(g(f(x)))

"""Construction of equality function"""
matcher(func, target) = x -> func(x) == target

"""Fix the rightmost argument of a function"""
rbind(func, fixed) = (args...) -> func(args..., fixed)

"""Fix the leftmost argument of a function"""
lbind(func, fixed) = (args...) -> func(fixed, args...)

# def rbind(function: Callable, fixed: Any) -> Callable:
#     """fix the rightmost argument"""
#     n = function.__code__.co_argcount
#     if n == 2:
#         return lambda x: function(x, fixed)
#     elif n == 3:
#         return lambda x, y: function(x, y, fixed)
#     else:
#         return lambda x, y, z: function(x, y, z, fixed)


# def lbind(function: Callable, fixed: Any) -> Callable:
#     """fix the leftmost argument"""
#     n = function.__code__.co_argcount
#     if n == 2:
#         return lambda y: function(fixed, y)
#     elif n == 3:
#         return lambda y, z: function(fixed, y, z)
#     else:
#         return lambda y, z, a: function(fixed, y, z, a)
