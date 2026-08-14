# NOTE: This file is generated — do not edit by hand.
# Generator: gen_sygus_comp_2019.jl (Claude session scratchpad, not part of the repo)
# Inputs: the SyGuS-Comp 2019 CLIA_Track .sl files, shipped verbatim in
# specifications/ (originally from sygus-comp/2019/CLIA_Track).

grammar_from_2018_arraysearch16 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = k
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = 16
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_arraysearch17 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = k
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = 16
	Term = 17
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_arraysearch18 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = k
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = 16
	Term = 17
	Term = 18
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_arraysearch19 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = x18
	Term = k
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = 16
	Term = 17
	Term = 18
	Term = 19
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_arraysearch20 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = x18
	Term = x19
	Term = k
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = 16
	Term = 17
	Term = 18
	Term = 19
	Term = 20
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_diff = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_VC22_a = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_VC22_b__f1 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_VC22_b__f2 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_VC22_b = grammar_from_2018_jmbl_fg_VC22_b__f1

grammar_from_2018_jmbl_fg_array_search_10 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_11 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = y11
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_12 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = y11
	Term = y12
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_13 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = y11
	Term = y12
	Term = y13
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_14 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = y11
	Term = y12
	Term = y13
	Term = y14
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = y11
	Term = y12
	Term = y13
	Term = y14
	Term = y15
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = 10
	Term = 11
	Term = 12
	Term = 13
	Term = 14
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_2 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_3 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_4 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_6 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_7 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_8 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_search_9 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = k1
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = 6
	Term = 7
	Term = 8
	Term = 9
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_10_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_10_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = y10
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_2_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_2_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_3_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_3_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_4_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_4_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_5_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_6_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_6_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_7_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_7_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_8_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_8_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_9_15 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = 0
	Term = 1
	Term = 15
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_array_sum_9_5 = @csgrammar begin
	Start = Term
	Term = y1
	Term = y2
	Term = y3
	Term = y4
	Term = y5
	Term = y6
	Term = y7
	Term = y8
	Term = y9
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__g2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs__g3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_eightfuncs = grammar_from_2018_jmbl_fg_eightfuncs__f1

grammar_from_2018_jmbl_fg_fivefuncs__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_fivefuncs__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_fivefuncs__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_fivefuncs__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_fivefuncs__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_fivefuncs = grammar_from_2018_jmbl_fg_fivefuncs__f1

grammar_from_2018_jmbl_fg_max10 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max11 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max12 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max13 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max14 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max15 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max3 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max4 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = w
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max5 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = w
	Term = u
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max6 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max7 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max8 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_max9 = @csgrammar begin
	Start = Term
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_example1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = 5
	Term = 17
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_example2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = 3
	Term = 4
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_example3 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = 4
	Term = 5
	Term = 9
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_example4 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = z1
	Term = 0
	Term = 1
	Term = 11
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_example5 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = 2
	Term = 3
	Term = 4
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_guard1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_guard2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_guard3 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_guard4 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_ite1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_ite2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_plane1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_plane2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = 3
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_mpg_plane3 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = z
	Term = 0
	Term = 1
	Term = 5
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__g2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__g3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs__g4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_ninefuncs = grammar_from_2018_jmbl_fg_ninefuncs__f1

grammar_from_2018_jmbl_fg_polynomial__add_expr_1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial__add_expr_2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial = grammar_from_2018_jmbl_fg_polynomial__add_expr_1

grammar_from_2018_jmbl_fg_polynomial1__add_expr_1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial1__add_expr_2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial1 = grammar_from_2018_jmbl_fg_polynomial1__add_expr_1

grammar_from_2018_jmbl_fg_polynomial2__add_expr_1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial2__add_expr_2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial2 = grammar_from_2018_jmbl_fg_polynomial2__add_expr_1

grammar_from_2018_jmbl_fg_polynomial3__add_expr_1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial3__add_expr_2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial3 = grammar_from_2018_jmbl_fg_polynomial3__add_expr_1

grammar_from_2018_jmbl_fg_polynomial4__add_expr_1 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial4__add_expr_2 = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_polynomial4 = grammar_from_2018_jmbl_fg_polynomial4__add_expr_1

grammar_from_2018_jmbl_fg_sevenfuncs__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs__g2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sevenfuncs = grammar_from_2018_jmbl_fg_sevenfuncs__f1

grammar_from_2018_jmbl_fg_sixfuncs__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_sixfuncs = grammar_from_2018_jmbl_fg_sixfuncs__f1

grammar_from_2018_jmbl_fg_tenfunc1__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__g2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__g3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__g4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1__g5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc1 = grammar_from_2018_jmbl_fg_tenfunc1__f1

grammar_from_2018_jmbl_fg_tenfunc2__f1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__f2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__f3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__f4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__f5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__g1 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__g2 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__g3 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__g4 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2__g5 = @csgrammar begin
	Start = Term
	Term = p1
	Term = P1
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_jmbl_fg_tenfunc2 = grammar_from_2018_jmbl_fg_tenfunc2__f1

grammar_from_2018_large = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_large_linear_func = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_max16 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_max17 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_max18 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_max19 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = x18
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_max20 = @csgrammar begin
	Start = Term
	Term = x0
	Term = x1
	Term = x2
	Term = x3
	Term = x4
	Term = x5
	Term = x6
	Term = x7
	Term = x8
	Term = x9
	Term = x10
	Term = x11
	Term = x12
	Term = x13
	Term = x14
	Term = x15
	Term = x16
	Term = x17
	Term = x18
	Term = x19
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_small = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

grammar_from_2018_small_linear_func = @csgrammar begin
	Start = Term
	Term = x
	Term = y
	Term = 0
	Term = 1
	Term = Term + Term
	Term = Term - Term
	Term = Term * Term
	Term = ite(Cond, Term, Term)
	Cond = Term < Term
	Cond = Term <= Term
	Cond = Term > Term
	Cond = Term >= Term
	Cond = eq(Term, Term)
end

