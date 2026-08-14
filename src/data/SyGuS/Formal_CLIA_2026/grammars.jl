# NOTE: This file is generated from specifications/*.sl
# (see the generator description in README.md). Do not edit by hand.

grammar_abs = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_abs_diff = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_clamp01 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_min2 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_min3 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_relu = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_sign = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max3 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max4 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max5 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = _arg_5
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max6 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = _arg_5
	Expr = _arg_6
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max7 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = _arg_5
	Expr = _arg_6
	Expr = _arg_7
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max8 = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = _arg_5
	Expr = _arg_6
	Expr = _arg_7
	Expr = _arg_8
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_abs_value_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_abs_value_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = 5
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_abs_value_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = 2
	Expr = 5
	Expr = 7
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_clamp_value_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = 0
	Expr = 1
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_clamp_value_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_clamp_value_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = _arg_4
	Expr = _arg_5
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_conditional_sum_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_conditional_sum_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = 7
	Expr = 15
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_conditional_sum_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = 10
	Expr = 15
	Expr = 20
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_find_max_three_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_find_max_three_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_find_max_three_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = _arg_3
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max_two_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max_two_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_max_two_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = _arg_2
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = 2
	Expr = 3
	Expr = 5
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_sign_function_easy = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_sign_function_medium = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = 2
	Expr = 3
	Expr = 5
	Expr = 10
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end

grammar_sign_function_hard = @csgrammar begin
	Start = Expr
	Expr = _arg_1
	Expr = -1
	Expr = 0
	Expr = 1
	Expr = 5
	Expr = 10
	Expr = 100
	Expr = Expr + Expr
	Expr = Expr - Expr
	Expr = Expr * Expr
	Expr = ifelse(Bool, Expr, Expr)
	Bool = Expr < Expr
	Bool = Expr <= Expr
	Bool = Expr > Expr
	Bool = Expr >= Expr
	Bool = Expr == Expr
end
