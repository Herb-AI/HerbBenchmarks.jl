grammar_arcdsl = @csgrammar begin
    Start = Sequence
    # Start = Grid # needs to be a grid
    # Grid = Sequence
    Sequence = Operation
    Sequence = (Operation; Sequence)
    Operation = Transformation # grid -> grid
    Transformation = vMirror() | hMirror() | hConcat() | vConcat() # concats have two arguments => indicate
end


# The DSL [4] can be put into three roughly equally sized categories of primitives:
# • transformations: functions that transform a grid or an object, e.g. resize, mirror, rotate, recolor, move, delete, etc.,
# • properties: functions that extract some features of an entity, e.g. leftmost oc- cupied cell, center of mass, shape, size, whether an object is a line, a square, etc. and
# • utils: functions that implement set operations (e.g. difference, union, intersection, insertion, removal), arithmetic operations (e.g. addition, subtraction, multiplica- tion, floor division) 
# or provide various helper functionality (e.g. filtering, function composition, parameter binding, branching, merging of containers).


# def solve_3af2c5a8(I):
# 	x1 = vmirror(I)
# 	x2 = hconcat(I, x1)
# 	x3 = hmirror(x2)
# 	O = vconcat(x2, x3)
# 	return O