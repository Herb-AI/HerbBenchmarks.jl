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

# note: some primitives below wouldn't be necessary in Herb

"""if-else condition"""
branch(condition, a, b) = condition ? a : b

"""Apply function to each element in container"""
apply(func, container) = map(func, container)

"""Apply each function in container to a value"""
rapply(container, value) = [f(value) for f in container]

"""Apply and merge"""
mapply(func, container) = merge_containers(apply(func, container))

"""Apply function on two vectors a and b"""
papply(func, a, b) = func.(a, b)

"""""Apply function on two vectors and merge"""
mpapply(func, a, b) = merge_containers(papply(func, a, b))

"""apply function on cartesian product"""
prapply(func, a, b) = [func(i, j) for j in b for i in a]

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

# primitives totuple, power, fork not implemented -> not necessary in Herb