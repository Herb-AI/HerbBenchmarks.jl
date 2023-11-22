"""
Grammar containing all simple integer arithmetic operations. Not useful for operating on lists on its own.
"""
grammar_list_arithmetic_base = @eval @cfgrammar $(Expr(:block, list_base_primitives...))

"""
These are primitives provided by 1959 lisp as introduced by McCarthy
"""
grammar_list_McCarthy = @eval @cfgrammar $(Expr(:block, list_McCarthy_primitives...))


grammar_list_full = @eval @cfgrammar $(Expr(:block, vcat(list_base_primitives, list_McCarthy_primitives, list_function_primitives)...))

grammar_list_full_no_map = @eval @cfgrammar $(Expr(:block, [x for x in vcat(list_base_primitives, list_McCarthy_primitives, list_function_primitives) if x != primitive_map]...))
grammar_list_full_no_length = @eval @cfgrammar $(Expr(:block, [x for x in vcat(list_base_primitives, list_McCarthy_primitives, list_function_primitives) if x != primitive_length]...))
grammar_list_full_no_length_no_map = @eval @cfgrammar $(Expr(:block, [x for x in vcat(list_base_primitives, list_McCarthy_primitives, list_function_primitives) if x != primitive_map && x != primitive_length]...))