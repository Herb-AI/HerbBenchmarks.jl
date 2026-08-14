# NOTE: This file is generated — do not edit by hand.
# Generator: gen_sygus_comp_2019.jl (Claude session scratchpad, not part of the repo)
# Inputs: the SyGuS-Comp 2019 CLIA_Track .sl files, shipped verbatim in
# specifications/ (originally from sygus-comp/2019/CLIA_Track).

problem_from_2018_arraysearch16 = Problem("problem_from_2018_arraysearch16", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("k")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< k x0)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 0))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x0)) (< k x1)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 1))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x1)) (< k x2)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 2))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x2)) (< k x3)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 3))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x3)) (< k x4)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 4))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x4)) (< k x5)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 5))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x5)) (< k x6)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 6))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x6)) (< k x7)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 7))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x7)) (< k x8)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 8))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x8)) (< k x9)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 9))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x9)) (< k x10)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 10))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x10)) (< k x11)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 11))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x11)) (< k x12)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 12))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x12)) (< k x13)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 13))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x13)) (< k x14)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 14))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x14)) (< k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 15))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (> k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 16))",
	],
	n_constraints = 17,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_arraysearch16.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_arraysearch17 = Problem("problem_from_2018_arraysearch17", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("k")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< k x0)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 0))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x0)) (< k x1)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 1))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x1)) (< k x2)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 2))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x2)) (< k x3)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 3))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x3)) (< k x4)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 4))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x4)) (< k x5)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 5))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x5)) (< k x6)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 6))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x6)) (< k x7)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 7))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x7)) (< k x8)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 8))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x8)) (< k x9)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 9))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x9)) (< k x10)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 10))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x10)) (< k x11)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 11))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x11)) (< k x12)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 12))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x12)) (< k x13)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 13))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x13)) (< k x14)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 14))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x14)) (< k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 15))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x15)) (< k x16)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 16))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (> k x16)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 k) 17))",
	],
	n_constraints = 18,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_arraysearch17.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_arraysearch18 = Problem("problem_from_2018_arraysearch18", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17"), Symbol("k")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< k x0)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 0))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x0)) (< k x1)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 1))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x1)) (< k x2)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 2))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x2)) (< k x3)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 3))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x3)) (< k x4)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 4))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x4)) (< k x5)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 5))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x5)) (< k x6)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 6))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x6)) (< k x7)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 7))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x7)) (< k x8)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 8))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x8)) (< k x9)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 9))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x9)) (< k x10)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 10))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x10)) (< k x11)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 11))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x11)) (< k x12)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 12))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x12)) (< k x13)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 13))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x13)) (< k x14)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 14))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x14)) (< k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 15))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x15)) (< k x16)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 16))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x16)) (< k x17)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 17))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (> k x17)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 k) 18))",
	],
	n_constraints = 19,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_arraysearch18.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_arraysearch19 = Problem("problem_from_2018_arraysearch19", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17"), Symbol("x18"), Symbol("k")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
		(name = Symbol("x18"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< k x0)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 0))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x0)) (< k x1)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 1))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x1)) (< k x2)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 2))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x2)) (< k x3)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 3))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x3)) (< k x4)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 4))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x4)) (< k x5)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 5))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x5)) (< k x6)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 6))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x6)) (< k x7)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 7))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x7)) (< k x8)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 8))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x8)) (< k x9)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 9))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x9)) (< k x10)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 10))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x10)) (< k x11)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 11))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x11)) (< k x12)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 12))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x12)) (< k x13)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 13))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x13)) (< k x14)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 14))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x14)) (< k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 15))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x15)) (< k x16)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 16))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x16)) (< k x17)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 17))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x17)) (< k x18)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 18))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (> k x18)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 k) 19))",
	],
	n_constraints = 20,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_arraysearch19.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_arraysearch20 = Problem("problem_from_2018_arraysearch20", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17"), Symbol("x18"), Symbol("x19"), Symbol("k")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
		(name = Symbol("x18"), sort = "Int"),
		(name = Symbol("x19"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (< k x0)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 0))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x0)) (< k x1)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 1))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x1)) (< k x2)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 2))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x2)) (< k x3)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 3))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x3)) (< k x4)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 4))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x4)) (< k x5)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 5))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x5)) (< k x6)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 6))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x6)) (< k x7)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 7))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x7)) (< k x8)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 8))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x8)) (< k x9)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 9))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x9)) (< k x10)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 10))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x10)) (< k x11)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 11))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x11)) (< k x12)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 12))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x12)) (< k x13)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 13))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x13)) (< k x14)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 14))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x14)) (< k x15)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 15))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x15)) (< k x16)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 16))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x16)) (< k x17)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 17))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x17)) (< k x18)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 18))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x18)) (< k x19)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 19))",
		"(=> (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (< x0 x1) (< x1 x2)) (< x2 x3)) (< x3 x4)) (< x4 x5)) (< x5 x6)) (< x6 x7)) (< x7 x8)) (< x8 x9)) (< x9 x10)) (< x10 x11)) (< x11 x12)) (< x12 x13)) (< x13 x14)) (< x14 x15)) (< x15 x16)) (< x16 x17)) (< x17 x18)) (< x18 x19)) (> k x19)) (= (findIdx x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 k) 20))",
	],
	n_constraints = 21,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_arraysearch20.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_diff = Problem("problem_from_2018_diff", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (f x y) (f y x))",
		"(or (= (- x y) (f x y)) (= (- y x) (f x y)))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_diff.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_VC22_a = Problem("problem_from_2018_jmbl_fg_VC22_a", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x1"), Symbol("x2")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("v1"), sort = "Int"),
		(name = Symbol("v2"), sort = "Int"),
	],
	constraints = [
		"(InVorZero (f x1 x2))",
		"(or (or (not (InV2 v1 v2)) (Zero (f x1 x2))) (and (not (Unsafe x1 x2 (f x1 x2) (f x1 x2))) (not (Zero (f (+ x1 (f x1 x2)) (+ x2 (f x1 x2)))))))",
		"(or (or (not (InV2 v1 v2)) (or (Unsafe x1 x2 v1 v2) (Zero (f (+ x1 v1) (+ x2 v2))))) (not (Zero (f x1 x2))))",
		"(or (Mad_ x1 x2) (not (Zero (f x1 x2))))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_VC22_a.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_VC22_b = Problem("problem_from_2018_jmbl_fg_VC22_b", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("x1"), Symbol("x2")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("x1"), Symbol("x2")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("v1"), sort = "Int"),
		(name = Symbol("v2"), sort = "Int"),
	],
	constraints = [
		"(InVorZero (f1 x1 x2) (f2 x1 x2))",
		"(or (or (not (InV v1 v2)) (all_zero (f1 x1 x2) (f2 x1 x2))) (and (not (Unsafe x1 x2 (f1 x1 x2) (f2 x1 x2))) (not (all_zero (f1 (+ x1 (f1 x1 x2)) (+ x2 (f2 x1 x2))) (f2 (+ x1 (f1 x1 x2)) (+ x2 (f2 x1 x2)))))))",
		"(or (or (or (not (InV v1 v2)) (Unsafe x1 x2 v1 v2)) (all_zero (f1 (+ x1 v1) (+ x2 v2)) (f2 (+ x1 v1) (+ x2 v2)))) (not (all_zero (f1 x1 x2) (f2 x1 x2))))",
		"(or (Mad_ x1 x2) (not (all_zero (f1 x1 x2) (f2 x1 x2))))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_VC22_b.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_10 = Problem("problem_from_2018_jmbl_fg_array_search_10", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (> k x10) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 10)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (< x9 x10))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 k) 9)))",
	],
	n_constraints = 11,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_10.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_11 = Problem("problem_from_2018_jmbl_fg_array_search_11", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("y11"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (> k x11) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 11)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (< x10 x11)))))))))) (=> (and (> k x10) (< k x11)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 k) 10)))",
	],
	n_constraints = 12,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_11.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_12 = Problem("problem_from_2018_jmbl_fg_array_search_12", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("y11"), Symbol("y12"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (> k x12) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 12)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x10) (< k x11)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 10)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (< x11 x12))))))))))) (=> (and (> k x11) (< k x12)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 k) 11)))",
	],
	n_constraints = 13,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_12.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_13 = Problem("problem_from_2018_jmbl_fg_array_search_13", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("y11"), Symbol("y12"), Symbol("y13"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (> k x13) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 13)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x10) (< k x11)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 10)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x11) (< k x12)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 11)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (< x12 x13)))))))))))) (=> (and (> k x12) (< k x13)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 k) 12)))",
	],
	n_constraints = 14,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_13.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_14 = Problem("problem_from_2018_jmbl_fg_array_search_14", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("y11"), Symbol("y12"), Symbol("y13"), Symbol("y14"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (> k x14) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 14)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x10) (< k x11)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 10)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x11) (< k x12)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 11)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x12) (< k x13)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 12)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (< x13 x14))))))))))))) (=> (and (> k x13) (< k x14)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 k) 13)))",
	],
	n_constraints = 15,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_14.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_15 = Problem("problem_from_2018_jmbl_fg_array_search_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10"), Symbol("y11"), Symbol("y12"), Symbol("y13"), Symbol("y14"), Symbol("y15"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (> k x15) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 15)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x9) (< k x10)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x10) (< k x11)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 10)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x11) (< k x12)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 11)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x12) (< k x13)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 12)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x13) (< k x14)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 13)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (and (< x8 x9) (and (< x9 x10) (and (< x10 x11) (and (< x11 x12) (and (< x12 x13) (and (< x13 x14) (< x14 x15)))))))))))))) (=> (and (> k x14) (< k x15)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 k) 14)))",
	],
	n_constraints = 16,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_2 = Problem("problem_from_2018_jmbl_fg_array_search_2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("k1")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (< x1 x2) (=> (< k x1) (= (findIdx x1 x2 k) 0)))",
		"(=> (< x1 x2) (=> (> k x2) (= (findIdx x1 x2 k) 2)))",
		"(=> (< x1 x2) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 k) 1)))",
	],
	n_constraints = 3,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_3 = Problem("problem_from_2018_jmbl_fg_array_search_3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (< x2 x3)) (=> (< k x1) (= (findIdx x1 x2 x3 k) 0)))",
		"(=> (and (< x1 x2) (< x2 x3)) (=> (> k x3) (= (findIdx x1 x2 x3 k) 3)))",
		"(=> (and (< x1 x2) (< x2 x3)) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 k) 1)))",
		"(=> (and (< x1 x2) (< x2 x3)) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 k) 2)))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_4 = Problem("problem_from_2018_jmbl_fg_array_search_4", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (< x3 x4))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (< x3 x4))) (=> (> k x4) (= (findIdx x1 x2 x3 x4 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (< x3 x4))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (< x3 x4))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (< x3 x4))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 k) 3)))",
	],
	n_constraints = 5,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_4.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_5 = Problem("problem_from_2018_jmbl_fg_array_search_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (> k x5) (= (findIdx x1 x2 x3 x4 x5 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (< x4 x5)))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 k) 4)))",
	],
	n_constraints = 6,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_6 = Problem("problem_from_2018_jmbl_fg_array_search_6", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (> k x6) (= (findIdx x1 x2 x3 x4 x5 x6 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (< x5 x6))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 k) 5)))",
	],
	n_constraints = 7,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_6.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_7 = Problem("problem_from_2018_jmbl_fg_array_search_7", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (> k x7) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (< x6 x7)))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 k) 6)))",
	],
	n_constraints = 8,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_7.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_8 = Problem("problem_from_2018_jmbl_fg_array_search_8", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (> k x8) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 8)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (< x7 x8))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 k) 7)))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_8.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_search_9 = Problem("problem_from_2018_jmbl_fg_array_search_9", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("findIdx"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("k1")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("k"), sort = "Int"),
	],
	constraints = [
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (< k x1) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 0)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (> k x9) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 9)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x1) (< k x2)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 1)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x2) (< k x3)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 2)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x3) (< k x4)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 3)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x4) (< k x5)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 4)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x5) (< k x6)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 5)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x6) (< k x7)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 6)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x7) (< k x8)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 7)))",
		"(=> (and (< x1 x2) (and (< x2 x3) (and (< x3 x4) (and (< x4 x5) (and (< x5 x6) (and (< x6 x7) (and (< x7 x8) (< x8 x9)))))))) (=> (and (> k x8) (< k x9)) (= (findIdx x1 x2 x3 x4 x5 x6 x7 x8 x9 k) 8)))",
	],
	n_constraints = 10,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_search_9.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_10_15 = Problem("problem_from_2018_jmbl_fg_array_sum_10_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (> (+ x5 x6) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (<= (+ x5 x6) 15))))) (> (+ x6 x7) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (<= (+ x6 x7) 15)))))) (> (+ x7 x8) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x7 x8)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (<= (+ x7 x8) 15))))))) (> (+ x8 x9) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x8 x9)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (and (<= (+ x7 x8) 15) (<= (+ x8 x9) 15)))))))) (> (+ x9 x10) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x9 x10)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (and (<= (+ x7 x8) 15) (and (<= (+ x8 x9) 15) (<= (+ x9 x10) 15))))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) 0))",
	],
	n_constraints = 10,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_10_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_10_5 = Problem("problem_from_2018_jmbl_fg_array_sum_10_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9"), Symbol("y10")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (<= (+ x3 x4) 5))) (> (+ x4 x5) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (<= (+ x4 x5) 5)))) (> (+ x5 x6) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (<= (+ x5 x6) 5))))) (> (+ x6 x7) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (<= (+ x6 x7) 5)))))) (> (+ x7 x8) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x7 x8)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (<= (+ x7 x8) 5))))))) (> (+ x8 x9) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x8 x9)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (and (<= (+ x7 x8) 5) (<= (+ x8 x9) 5)))))))) (> (+ x9 x10) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) (+ x9 x10)))",
		"(=> (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (and (<= (+ x7 x8) 5) (and (<= (+ x8 x9) 5) (<= (+ x9 x10) 5))))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) 0))",
	],
	n_constraints = 10,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_10_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_2_15 = Problem("problem_from_2018_jmbl_fg_array_sum_2_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2) (+ x1 x2)))",
		"(=> (<= (+ x1 x2) 15) (= (fnd_sum x1 x2) 0))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_2_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_2_5 = Problem("problem_from_2018_jmbl_fg_array_sum_2_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2) (+ x1 x2)))",
		"(=> (<= (+ x1 x2) 5) (= (fnd_sum x1 x2) 0))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_2_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_3_15 = Problem("problem_from_2018_jmbl_fg_array_sum_3_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3) (+ x2 x3)))",
		"(=> (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3) 0))",
	],
	n_constraints = 3,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_3_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_3_5 = Problem("problem_from_2018_jmbl_fg_array_sum_3_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3) (+ x2 x3)))",
		"(=> (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3) 0))",
	],
	n_constraints = 3,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_3_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_4_15 = Problem("problem_from_2018_jmbl_fg_array_sum_4_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4")], param_sorts = String["Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4) (+ x3 x4)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (= (fnd_sum x1 x2 x3 x4) 0))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_4_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_4_5 = Problem("problem_from_2018_jmbl_fg_array_sum_4_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4")], param_sorts = String["Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (<= (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4) 0))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_4_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_5_15 = Problem("problem_from_2018_jmbl_fg_array_sum_5_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5")], param_sorts = String["Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5) (+ x4 x5)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (= (fnd_sum x1 x2 x3 x4 x5) 0))",
	],
	n_constraints = 5,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_5_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_6_15 = Problem("problem_from_2018_jmbl_fg_array_sum_6_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (> (+ x5 x6) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x5 x6)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (<= (+ x5 x6) 15))))) (= (fnd_sum x1 x2 x3 x4 x5 x6) 0))",
	],
	n_constraints = 6,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_6_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_6_5 = Problem("problem_from_2018_jmbl_fg_array_sum_6_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (<= (+ x3 x4) 5))) (> (+ x4 x5) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (<= (+ x4 x5) 5)))) (> (+ x5 x6) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6) (+ x5 x6)))",
		"(=> (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (<= (+ x5 x6) 5))))) (= (fnd_sum x1 x2 x3 x4 x5 x6) 0))",
	],
	n_constraints = 6,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_6_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_7_15 = Problem("problem_from_2018_jmbl_fg_array_sum_7_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (> (+ x5 x6) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (<= (+ x5 x6) 15))))) (> (+ x6 x7) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x6 x7)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (<= (+ x6 x7) 15)))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) 0))",
	],
	n_constraints = 7,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_7_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_7_5 = Problem("problem_from_2018_jmbl_fg_array_sum_7_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (<= (+ x3 x4) 5))) (> (+ x4 x5) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (<= (+ x4 x5) 5)))) (> (+ x5 x6) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (<= (+ x5 x6) 5))))) (> (+ x6 x7) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) (+ x6 x7)))",
		"(=> (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (<= (+ x6 x7) 5)))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7) 0))",
	],
	n_constraints = 7,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_7_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_8_15 = Problem("problem_from_2018_jmbl_fg_array_sum_8_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (> (+ x5 x6) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (<= (+ x5 x6) 15))))) (> (+ x6 x7) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (<= (+ x6 x7) 15)))))) (> (+ x7 x8) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x7 x8)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (<= (+ x7 x8) 15))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) 0))",
	],
	n_constraints = 8,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_8_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_8_5 = Problem("problem_from_2018_jmbl_fg_array_sum_8_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (<= (+ x3 x4) 5))) (> (+ x4 x5) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (<= (+ x4 x5) 5)))) (> (+ x5 x6) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (<= (+ x5 x6) 5))))) (> (+ x6 x7) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (<= (+ x6 x7) 5)))))) (> (+ x7 x8) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) (+ x7 x8)))",
		"(=> (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (<= (+ x7 x8) 5))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8) 0))",
	],
	n_constraints = 8,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_8_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_9_15 = Problem("problem_from_2018_jmbl_fg_array_sum_9_15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 15) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 15) (> (+ x2 x3) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 15) (<= (+ x2 x3) 15)) (> (+ x3 x4) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (<= (+ x3 x4) 15))) (> (+ x4 x5) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (<= (+ x4 x5) 15)))) (> (+ x5 x6) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (<= (+ x5 x6) 15))))) (> (+ x6 x7) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (<= (+ x6 x7) 15)))))) (> (+ x7 x8) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x7 x8)))",
		"(=> (and (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (<= (+ x7 x8) 15))))))) (> (+ x8 x9) 15)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x8 x9)))",
		"(=> (and (<= (+ x1 x2) 15) (and (<= (+ x2 x3) 15) (and (<= (+ x3 x4) 15) (and (<= (+ x4 x5) 15) (and (<= (+ x5 x6) 15) (and (<= (+ x6 x7) 15) (and (<= (+ x7 x8) 15) (<= (+ x8 x9) 15)))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) 0))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_9_15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_array_sum_9_5 = Problem("problem_from_2018_jmbl_fg_array_sum_9_5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("fnd_sum"), params = Symbol[Symbol("y1"), Symbol("y2"), Symbol("y3"), Symbol("y4"), Symbol("y5"), Symbol("y6"), Symbol("y7"), Symbol("y8"), Symbol("y9")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
	],
	constraints = [
		"(=> (> (+ x1 x2) 5) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x1 x2)))",
		"(=> (and (<= (+ x1 x2) 5) (> (+ x2 x3) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x2 x3)))",
		"(=> (and (and (<= (+ x1 x2) 5) (<= (+ x2 x3) 5)) (> (+ x3 x4) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x3 x4)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (<= (+ x3 x4) 5))) (> (+ x4 x5) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x4 x5)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (<= (+ x4 x5) 5)))) (> (+ x5 x6) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x5 x6)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (<= (+ x5 x6) 5))))) (> (+ x6 x7) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x6 x7)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (<= (+ x6 x7) 5)))))) (> (+ x7 x8) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x7 x8)))",
		"(=> (and (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (<= (+ x7 x8) 5))))))) (> (+ x8 x9) 5)) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) (+ x8 x9)))",
		"(=> (and (<= (+ x1 x2) 5) (and (<= (+ x2 x3) 5) (and (<= (+ x3 x4) 5) (and (<= (+ x4 x5) 5) (and (<= (+ x5 x6) 5) (and (<= (+ x6 x7) 5) (and (<= (+ x7 x8) 5) (<= (+ x8 x9) 5)))))))) (= (fnd_sum x1 x2 x3 x4 x5 x6 x7 x8 x9) 0))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_array_sum_9_5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_eightfuncs = Problem("problem_from_2018_jmbl_fg_eightfuncs", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
		"(= (+ 1 (g1 x y)) (g2 x y))",
		"(= (+ 1 (g2 x y)) (g3 x y))",
	],
	n_constraints = 7,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_eightfuncs.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_fivefuncs = Problem("problem_from_2018_jmbl_fg_fivefuncs", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_fivefuncs.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max10 = Problem("problem_from_2018_jmbl_fg_max10", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_10"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x1)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x2)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x3)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x4)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x5)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x6)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x7)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x8)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x9)",
		"(>= (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) x10)",
		"(or (= x1 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x2 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x3 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x4 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x5 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x6 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x7 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x8 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (or (= x9 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)) (= x10 (mux_10 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)))))))))))",
	],
	n_constraints = 11,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max10.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max11 = Problem("problem_from_2018_jmbl_fg_max11", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_11"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x1)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x2)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x3)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x4)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x5)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x6)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x7)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x8)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x9)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x10)",
		"(>= (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) x11)",
		"(or (= x1 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x2 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x3 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x4 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x5 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x6 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x7 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x8 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x9 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (or (= x10 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)) (= x11 (mux_11 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11))))))))))))",
	],
	n_constraints = 12,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max11.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max12 = Problem("problem_from_2018_jmbl_fg_max12", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_12"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x1)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x2)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x3)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x4)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x5)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x6)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x7)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x8)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x9)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x10)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x11)",
		"(>= (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) x12)",
		"(or (= x1 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x2 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x3 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x4 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x5 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x6 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x7 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x8 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x9 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x10 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (or (= x11 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)) (= x12 (mux_12 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)))))))))))))",
	],
	n_constraints = 13,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max12.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max13 = Problem("problem_from_2018_jmbl_fg_max13", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_13"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x1)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x2)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x3)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x4)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x5)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x6)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x7)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x8)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x9)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x10)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x11)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x12)",
		"(>= (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) x13)",
		"(or (= x1 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x2 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x3 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x4 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x5 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x6 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x7 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x8 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x9 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x10 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x11 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (or (= x12 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13)) (= x13 (mux_13 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13))))))))))))))",
	],
	n_constraints = 14,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max13.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max14 = Problem("problem_from_2018_jmbl_fg_max14", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_14"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x1)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x2)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x3)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x4)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x5)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x6)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x7)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x8)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x9)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x10)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x11)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x12)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x13)",
		"(>= (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14) x14)",
		"(or (= x1 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x2 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x3 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x4 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x5 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x6 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x7 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x8 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x9 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x10 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x11 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x12 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (or (= x13 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)) (= x14 (mux_14 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14)))))))))))))))",
	],
	n_constraints = 15,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max14.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max15 = Problem("problem_from_2018_jmbl_fg_max15", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_15"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x1)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x2)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x3)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x4)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x5)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x6)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x7)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x8)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x9)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x10)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x11)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x12)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x13)",
		"(>= (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x14)",
		"(or (= x1 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x2 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x3 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x4 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x5 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x6 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x7 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x8 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x9 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x10 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x11 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x12 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x13 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (or (= x14 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (= x15 (mux_15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))))))))))))))))",
	],
	n_constraints = 15,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max15.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max2 = Problem("problem_from_2018_jmbl_fg_max2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_2 x y) x)",
		"(>= (mux_2 x y) y)",
		"(or (= x (mux_2 x y)) (= y (mux_2 x y)))",
	],
	n_constraints = 3,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max3 = Problem("problem_from_2018_jmbl_fg_max3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_3"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_3 x y z) x)",
		"(>= (mux_3 x y z) y)",
		"(>= (mux_3 x y z) z)",
		"(or (= x (mux_3 x y z)) (or (= y (mux_3 x y z)) (= z (mux_3 x y z))))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max4 = Problem("problem_from_2018_jmbl_fg_max4", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_4"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z"), Symbol("w")], param_sorts = String["Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
		(name = Symbol("w"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_4 x y z w) x)",
		"(>= (mux_4 x y z w) y)",
		"(>= (mux_4 x y z w) z)",
		"(>= (mux_4 x y z w) w)",
		"(or (= x (mux_4 x y z w)) (or (= y (mux_4 x y z w)) (or (= z (mux_4 x y z w)) (= w (mux_4 x y z w)))))",
	],
	n_constraints = 5,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max4.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max5 = Problem("problem_from_2018_jmbl_fg_max5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_5"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z"), Symbol("w"), Symbol("u")], param_sorts = String["Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
		(name = Symbol("w"), sort = "Int"),
		(name = Symbol("u"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_5 x y z w u) x)",
		"(>= (mux_5 x y z w u) y)",
		"(>= (mux_5 x y z w u) z)",
		"(>= (mux_5 x y z w u) w)",
		"(>= (mux_5 x y z w u) u)",
		"(or (= x (mux_5 x y z w u)) (or (= y (mux_5 x y z w u)) (or (= z (mux_5 x y z w u)) (or (= w (mux_5 x y z w u)) (= u (mux_5 x y z w u))))))",
	],
	n_constraints = 6,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max6 = Problem("problem_from_2018_jmbl_fg_max6", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_6"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x1)",
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x2)",
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x3)",
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x4)",
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x5)",
		"(>= (mux_6 x1 x2 x3 x4 x5 x6) x6)",
		"(or (= x1 (mux_6 x1 x2 x3 x4 x5 x6)) (or (= x2 (mux_6 x1 x2 x3 x4 x5 x6)) (or (= x3 (mux_6 x1 x2 x3 x4 x5 x6)) (or (= x4 (mux_6 x1 x2 x3 x4 x5 x6)) (or (= x5 (mux_6 x1 x2 x3 x4 x5 x6)) (= x6 (mux_6 x1 x2 x3 x4 x5 x6)))))))",
	],
	n_constraints = 7,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max6.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max7 = Problem("problem_from_2018_jmbl_fg_max7", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_7"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x1)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x2)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x3)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x4)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x5)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x6)",
		"(>= (mux_7 x1 x2 x3 x4 x5 x6 x7) x7)",
		"(or (= x1 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (or (= x2 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (or (= x3 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (or (= x4 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (or (= x5 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (or (= x6 (mux_7 x1 x2 x3 x4 x5 x6 x7)) (= x7 (mux_7 x1 x2 x3 x4 x5 x6 x7))))))))",
	],
	n_constraints = 8,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max7.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max8 = Problem("problem_from_2018_jmbl_fg_max8", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_8"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x1)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x2)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x3)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x4)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x5)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x6)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x7)",
		"(>= (mux_8 x1 x2 x3 x4 x5 x6 x7 x8) x8)",
		"(or (= x1 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x2 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x3 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x4 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x5 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x6 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (or (= x7 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x8 (mux_8 x1 x2 x3 x4 x5 x6 x7 x8)))))))))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max8.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_max9 = Problem("problem_from_2018_jmbl_fg_max9", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("mux_9"), params = Symbol[Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
	],
	constraints = [
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x1)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x2)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x3)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x4)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x5)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x6)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x7)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x8)",
		"(>= (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9) x9)",
		"(or (= x1 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x2 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x3 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x4 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x5 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x6 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x7 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (or (= x8 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9)) (= x9 (mux_9 x1 x2 x3 x4 x5 x6 x7 x8 x9))))))))))",
	],
	n_constraints = 10,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_max9.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_example1 = Problem("problem_from_2018_jmbl_fg_mpg_example1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("ex"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(im (>= x 5) (= (ex x y) (plus_3 (five_times x) (three_times y) 17)) (= (ex x y) (plus_2 (three_times x) 1)))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_example1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_example2 = Problem("problem_from_2018_jmbl_fg_mpg_example2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (<= (plus_2 (two_times x) (minus 3)) (plus_3 z (minus (two_times y)) 4)) (>= (eq_1 x y z) x) (<= (eq_1 x y z) x))",
		"(im (<= (plus_2 (two_times x) (minus 3)) (plus_3 z (minus (two_times y)) 4)) (>= (eq_1 x y z) y) (<= (eq_1 x y z) y))",
		"(im (<= (plus_2 (two_times x) (minus 3)) (plus_3 z (minus (two_times y)) 4)) (>= (eq_1 x y z) z) (<= (eq_1 x y z) z))",
		"(or3 (= (eq_1 x y z) x) (= (eq_1 x y z) y) (= (eq_1 x y z) z))",
	],
	n_constraints = 4,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_example2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_example3 = Problem("problem_from_2018_jmbl_fg_mpg_example3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq2"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (three_times z) 5) (im (<= (two_times x) y) (= (eq2 x y z) (plus_4 (three_times x) (minus (five_times y)) (seven_times z) 9)) (= (eq2 x y z) (plus_4 x x (minus (nine_times z)) 5))) (im (<= (two_times z) (plus_3 (minus y) x x)) (= (eq2 x y z) (plus_3 (minus (six_times x)) (three_times y) 4)) (= (eq2 x y z) (plus_3 (nine_times (plus_2 x y)) (minus z) 5))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_example3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_example4 = Problem("problem_from_2018_jmbl_fg_mpg_example4", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq2"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z"), Symbol("z1")], param_sorts = String["Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
		(name = Symbol("z1"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_3 (two_times x) z (minus z1)) (minus y)) (im (<= (plus_2 x z1) y) (= (eq2 x y z z1) (plus_4 (ten_times x) (two_times (ten_times y)) (three_times (five_times z)) -99)) (= (eq2 x y z z1) (plus_3 (nine_times y) (five_times (five_times z1)) -11))) (im (<= (plus_3 x (three_times z) z1) -9) (= (eq2 x y z z1) (plus_5 (eleven_times x) (five_times (three_times y)) (three_times (ten_times z)) (two_times (eleven_times z1)) 11)) (= (eq2 x y z z1) (plus_4 (four_times (four_times x)) (three_times (six_times z)) (five_times z1) -55))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_example4.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_example5 = Problem("problem_from_2018_jmbl_fg_mpg_example5", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(ite (<= (plus_2 x y) 1) (= (eq_1 x y) (ten_times (plus_3 x y 1))) (ite (<= (plus_2 x y) 2) (= (eq_1 x y) (ten_times (two_times (plus_3 x y -1)))) (ite (<= (plus_2 x y) 3) (= (eq_1 x y) (ten_times (three_times (plus_3 x y 1)))) (ite (<= (plus_2 x y) 4) (= (eq_1 x y) (ten_times (four_times (plus_3 x y -1)))) (ite (<= (plus_2 x y) 5) (= (eq_1 x y) (ten_times (five_times (plus_3 x y 1)))) (= (eq_1 x y) (ten_times (six_times (plus_3 x y -1)))))))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_example5.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_guard1 = Problem("problem_from_2018_jmbl_fg_mpg_guard1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_2 x y) 1) (= (eq_1 x y z) (plus_2 x y)) (= (eq_1 x y z) (plus_2 x (minus y))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_guard1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_guard2 = Problem("problem_from_2018_jmbl_fg_mpg_guard2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_3 x y z) 1) (= (eq_1 x y z) (plus_2 x y)) (= (eq_1 x y z) (plus_2 x (minus y))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_guard2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_guard3 = Problem("problem_from_2018_jmbl_fg_mpg_guard3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_4 x x y z) 1) (= (eq_1 x y z) (plus_2 x y)) (= (eq_1 x y z) (plus_2 x (minus y))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_guard3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_guard4 = Problem("problem_from_2018_jmbl_fg_mpg_guard4", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_5 x x y y z) 1) (= (eq_1 x y z) (plus_2 x y)) (= (eq_1 x y z) (plus_2 x (minus y))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_guard4.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_ite1 = Problem("problem_from_2018_jmbl_fg_mpg_ite1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_2 x y) 1) (im (>= (plus_2 x z) 1) (= (eq_1 x y z) (+ x 1)) (= (eq_1 x y z) (+ y 1))) (= (eq_1 x y z) (+ z 1)))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_ite1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_ite2 = Problem("problem_from_2018_jmbl_fg_mpg_ite2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(im (>= (plus_2 x y) 1) (im (>= (plus_2 x z) 1) (= (eq_1 x y z) (+ x 1)) (= (eq_1 x y z) (+ y 1))) (im (>= (plus_2 y z) 1) (= (eq_1 x y z) (+ z 1)) (= (eq_1 x y z) (+ y 1))))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_ite2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_plane1 = Problem("problem_from_2018_jmbl_fg_mpg_plane1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(= (eq_1 x y z) (+ x y))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_plane1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_plane2 = Problem("problem_from_2018_jmbl_fg_mpg_plane2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(= (eq_1 x y z) (plus_3 (three_times x) (three_times y) 3))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_plane2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_mpg_plane3 = Problem("problem_from_2018_jmbl_fg_mpg_plane3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("eq_1"), params = Symbol[Symbol("x"), Symbol("y"), Symbol("z")], param_sorts = String["Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
		(name = Symbol("z"), sort = "Int"),
	],
	constraints = [
		"(= (eq_1 x y z) (plus_3 (five_times x) (five_times y) 5))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_mpg_plane3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_ninefuncs = Problem("problem_from_2018_jmbl_fg_ninefuncs", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
		"(= (+ 1 (g1 x y)) (g2 x y))",
		"(= (+ 1 (g2 x y)) (g3 x y))",
		"(= (+ (g3 x y) (g3 x y)) (g4 x y))",
	],
	n_constraints = 8,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_ninefuncs.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_polynomial = Problem("problem_from_2018_jmbl_fg_polynomial", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("add_expr_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("add_expr_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (add_expr_1 x y) (add_expr_2 y x))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_polynomial.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_polynomial1 = Problem("problem_from_2018_jmbl_fg_polynomial1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("add_expr_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("add_expr_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (add_expr_1 x y) (add_expr_2 y x)) (+ x y))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_polynomial1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_polynomial2 = Problem("problem_from_2018_jmbl_fg_polynomial2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("add_expr_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("add_expr_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (add_expr_1 x y) (add_expr_2 y x)) (- x y))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_polynomial2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_polynomial3 = Problem("problem_from_2018_jmbl_fg_polynomial3", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("add_expr_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("add_expr_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (add_expr_1 x y) (add_expr_2 y x)) (- x (+ x y)))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_polynomial3.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_polynomial4 = Problem("problem_from_2018_jmbl_fg_polynomial4", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("add_expr_1"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("add_expr_2"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (add_expr_1 x y) (add_expr_2 y x)) (+ (+ (+ x y) y) (+ x y)))",
	],
	n_constraints = 1,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_polynomial4.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_sevenfuncs = Problem("problem_from_2018_jmbl_fg_sevenfuncs", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
		"(= (+ 1 (g1 x y)) (g2 x y))",
	],
	n_constraints = 6,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_sevenfuncs.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_sixfuncs = Problem("problem_from_2018_jmbl_fg_sixfuncs", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
	],
	n_constraints = 5,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_sixfuncs.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_tenfunc1 = Problem("problem_from_2018_jmbl_fg_tenfunc1", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
		"(= (+ 1 (g1 x y)) (g2 x y))",
		"(= (+ 1 (g2 x y)) (g3 x y))",
		"(= (+ (g3 x y) (g3 x y)) (g4 x y))",
		"(= (+ (g4 x y) (f1 x y)) (g5 x y))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_tenfunc1.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_jmbl_fg_tenfunc2 = Problem("problem_from_2018_jmbl_fg_tenfunc2", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("f5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g1"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g2"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g3"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g4"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
		(name = Symbol("g5"), params = Symbol[Symbol("p1"), Symbol("P1")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (+ (f1 x y) (f1 x y)) (f2 x y))",
		"(= (- (+ (f1 x y) (f2 x y)) y) (f3 x y))",
		"(= (+ (f2 x y) (f2 x y)) (f4 x y))",
		"(= (+ (f4 x y) (f1 x y)) (f5 x y))",
		"(= (- (f1 x y) y) (g1 x y))",
		"(= (+ 1 (g1 x y)) (g2 x y))",
		"(= (+ 1 (g2 x y)) (g3 x y))",
		"(= (+ (g3 x y) (g3 x y)) (g4 x y))",
		"(= (+ (g4 x y) (f1 x y)) (g5 x y))",
	],
	n_constraints = 9,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_jmbl_fg_tenfunc2.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_large = Problem("problem_from_2018_large", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (f x y) (f y x))",
		"(and (>= x (f x y)) (>= y (f x y)))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_large.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_large_linear_func = Problem("problem_from_2018_large_linear_func", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (f x y) (f y x))",
		"(and (>= (func x) (f x y)) (>= (func y) (f x y)))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_large_linear_func.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_max16 = Problem("problem_from_2018_max16", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("max16"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
	],
	constraints = [
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x0)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x1)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x2)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x3)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x4)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x5)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x6)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x7)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x8)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x9)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x10)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x11)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x12)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x13)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x14)",
		"(>= (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15) x15)",
		"(or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (= x0 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)) (= x1 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x2 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x3 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x4 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x5 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x6 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x7 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x8 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x9 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x10 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x11 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x12 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x13 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x14 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15))) (= x15 (max16 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)))",
	],
	n_constraints = 17,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_max16.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_max17 = Problem("problem_from_2018_max17", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("max17"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
	],
	constraints = [
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x0)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x1)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x2)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x3)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x4)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x5)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x6)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x7)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x8)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x9)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x10)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x11)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x12)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x13)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x14)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x15)",
		"(>= (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16) x16)",
		"(or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (= x0 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16)) (= x1 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x2 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x3 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x4 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x5 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x6 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x7 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x8 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x9 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x10 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x11 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x12 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x13 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x14 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x15 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16))) (= x16 (max17 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16)))",
	],
	n_constraints = 18,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_max17.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_max18 = Problem("problem_from_2018_max18", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("max18"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
	],
	constraints = [
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x0)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x1)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x2)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x3)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x4)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x5)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x6)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x7)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x8)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x9)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x10)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x11)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x12)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x13)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x14)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x15)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x16)",
		"(>= (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17) x17)",
		"(or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (= x0 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17)) (= x1 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x2 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x3 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x4 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x5 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x6 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x7 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x8 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x9 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x10 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x11 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x12 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x13 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x14 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x15 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x16 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17))) (= x17 (max18 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17)))",
	],
	n_constraints = 19,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_max18.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_max19 = Problem("problem_from_2018_max19", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("max19"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17"), Symbol("x18")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
		(name = Symbol("x18"), sort = "Int"),
	],
	constraints = [
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x0)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x1)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x2)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x3)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x4)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x5)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x6)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x7)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x8)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x9)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x10)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x11)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x12)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x13)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x14)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x15)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x16)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x17)",
		"(>= (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18) x18)",
		"(or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (= x0 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18)) (= x1 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x2 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x3 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x4 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x5 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x6 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x7 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x8 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x9 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x10 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x11 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x12 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x13 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x14 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x15 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x16 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x17 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18))) (= x18 (max19 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18)))",
	],
	n_constraints = 20,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_max19.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_max20 = Problem("problem_from_2018_max20", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("max20"), params = Symbol[Symbol("x0"), Symbol("x1"), Symbol("x2"), Symbol("x3"), Symbol("x4"), Symbol("x5"), Symbol("x6"), Symbol("x7"), Symbol("x8"), Symbol("x9"), Symbol("x10"), Symbol("x11"), Symbol("x12"), Symbol("x13"), Symbol("x14"), Symbol("x15"), Symbol("x16"), Symbol("x17"), Symbol("x18"), Symbol("x19")], param_sorts = String["Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x0"), sort = "Int"),
		(name = Symbol("x1"), sort = "Int"),
		(name = Symbol("x2"), sort = "Int"),
		(name = Symbol("x3"), sort = "Int"),
		(name = Symbol("x4"), sort = "Int"),
		(name = Symbol("x5"), sort = "Int"),
		(name = Symbol("x6"), sort = "Int"),
		(name = Symbol("x7"), sort = "Int"),
		(name = Symbol("x8"), sort = "Int"),
		(name = Symbol("x9"), sort = "Int"),
		(name = Symbol("x10"), sort = "Int"),
		(name = Symbol("x11"), sort = "Int"),
		(name = Symbol("x12"), sort = "Int"),
		(name = Symbol("x13"), sort = "Int"),
		(name = Symbol("x14"), sort = "Int"),
		(name = Symbol("x15"), sort = "Int"),
		(name = Symbol("x16"), sort = "Int"),
		(name = Symbol("x17"), sort = "Int"),
		(name = Symbol("x18"), sort = "Int"),
		(name = Symbol("x19"), sort = "Int"),
	],
	constraints = [
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x0)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x1)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x2)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x3)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x4)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x5)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x6)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x7)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x8)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x9)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x10)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x11)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x12)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x13)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x14)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x15)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x16)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x17)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x18)",
		"(>= (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19) x19)",
		"(or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (= x0 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19)) (= x1 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x2 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x3 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x4 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x5 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x6 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x7 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x8 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x9 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x10 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x11 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x12 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x13 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x14 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x15 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x16 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x17 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x18 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19))) (= x19 (max20 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19)))",
	],
	n_constraints = 21,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_max20.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_small = Problem("problem_from_2018_small", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (f x y) (f y x))",
		"(and (<= x (f x y)) (<= y (f x y)))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_small.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

problem_from_2018_small_linear_func = Problem("problem_from_2018_small_linear_func", SMTSpecification((
	logic = "LIA",
	synth_funs = [
		(name = Symbol("f"), params = Symbol[Symbol("x"), Symbol("y")], param_sorts = String["Int", "Int"], ret_sort = "Int"),
	],
	free_vars = [
		(name = Symbol("x"), sort = "Int"),
		(name = Symbol("y"), sort = "Int"),
	],
	constraints = [
		"(= (f x y) (f y x))",
		"(and (<= (func x) (f x y)) (<= (func y) (f x y)))",
	],
	n_constraints = 2,
	spec_file = joinpath(@__DIR__, "specifications", "from_2018_small_linear_func.sl"),
	nt_sorts = Dict{Symbol,String}(Symbol("Cond") => "Bool", Symbol("Start") => "Int", Symbol("Term") => "Int"),
)))

