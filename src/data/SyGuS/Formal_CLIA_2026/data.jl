# NOTE: This file is generated from specifications/*.sl
# (see the generator description in README.md). Do not edit by hand.

problem_abs = Problem("problem_abs", SMTSpecification((
	logic = "LIA",
	fname = :absv,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(>= (absv x) 0)",
		"(=> (>= x 0) (= (absv x) x))",
		"(=> (< x 0) (= (absv x) (- x)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "abs.sl"),
)))

problem_abs_diff = Problem("problem_abs_diff", SMTSpecification((
	logic = "LIA",
	fname = :adiff,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(>= (adiff x y) 0)",
		"(>= (adiff x y) (- x y))",
		"(>= (adiff x y) (- y x))",
		"(or (= (adiff x y) (- x y)) (= (adiff x y) (- y x)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "abs_diff.sl"),
)))

problem_clamp01 = Problem("problem_clamp01", SMTSpecification((
	logic = "LIA",
	fname = :clamp,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(=> (< x 0) (= (clamp x) 0))",
		"(=> (> x 1) (= (clamp x) 1))",
		"(=> (and (>= x 0) (<= x 1)) (= (clamp x) x))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "clamp01.sl"),
)))

problem_min2 = Problem("problem_min2", SMTSpecification((
	logic = "LIA",
	fname = :min2,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(<= (min2 x y) x)",
		"(<= (min2 x y) y)",
		"(or (= x (min2 x y)) (= y (min2 x y)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "min2.sl"),
)))

problem_min3 = Problem("problem_min3", SMTSpecification((
	logic = "LIA",
	fname = :min3,
	params = [:x, :y, :z],
	free_vars = [:x, :y, :z],
	constraints = [
		"(<= (min3 x y z) x)",
		"(<= (min3 x y z) y)",
		"(<= (min3 x y z) z)",
		"(or (= x (min3 x y z)) (or (= y (min3 x y z)) (= z (min3 x y z))))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "min3.sl"),
)))

problem_relu = Problem("problem_relu", SMTSpecification((
	logic = "LIA",
	fname = :relu,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(>= (relu x) x)",
		"(>= (relu x) 0)",
		"(or (= (relu x) x) (= (relu x) 0))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "relu.sl"),
)))

problem_sign = Problem("problem_sign", SMTSpecification((
	logic = "LIA",
	fname = :sign,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(=> (> x 0) (= (sign x) 1))",
		"(=> (< x 0) (= (sign x) (- 1)))",
		"(=> (= x 0) (= (sign x) 0))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "sign.sl"),
)))

problem_max3 = Problem("problem_max3", SMTSpecification((
	logic = "LIA",
	fname = :max3,
	params = [:x1, :x2, :x3],
	free_vars = [:x1, :x2, :x3],
	constraints = [
		"(>= (max3 x1 x2 x3) x1)",
		"(>= (max3 x1 x2 x3) x2)",
		"(>= (max3 x1 x2 x3) x3)",
		"(or (= x1 (max3 x1 x2 x3)) (= x2 (max3 x1 x2 x3)) (= x3 (max3 x1 x2 x3)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max3.sl"),
)))

problem_max4 = Problem("problem_max4", SMTSpecification((
	logic = "LIA",
	fname = :max4,
	params = [:x1, :x2, :x3, :x4],
	free_vars = [:x1, :x2, :x3, :x4],
	constraints = [
		"(>= (max4 x1 x2 x3 x4) x1)",
		"(>= (max4 x1 x2 x3 x4) x2)",
		"(>= (max4 x1 x2 x3 x4) x3)",
		"(>= (max4 x1 x2 x3 x4) x4)",
		"(or (= x1 (max4 x1 x2 x3 x4)) (= x2 (max4 x1 x2 x3 x4)) (= x3 (max4 x1 x2 x3 x4)) (= x4 (max4 x1 x2 x3 x4)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max4.sl"),
)))

problem_max5 = Problem("problem_max5", SMTSpecification((
	logic = "LIA",
	fname = :max5,
	params = [:x1, :x2, :x3, :x4, :x5],
	free_vars = [:x1, :x2, :x3, :x4, :x5],
	constraints = [
		"(>= (max5 x1 x2 x3 x4 x5) x1)",
		"(>= (max5 x1 x2 x3 x4 x5) x2)",
		"(>= (max5 x1 x2 x3 x4 x5) x3)",
		"(>= (max5 x1 x2 x3 x4 x5) x4)",
		"(>= (max5 x1 x2 x3 x4 x5) x5)",
		"(or (= x1 (max5 x1 x2 x3 x4 x5)) (= x2 (max5 x1 x2 x3 x4 x5)) (= x3 (max5 x1 x2 x3 x4 x5)) (= x4 (max5 x1 x2 x3 x4 x5)) (= x5 (max5 x1 x2 x3 x4 x5)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max5.sl"),
)))

problem_max6 = Problem("problem_max6", SMTSpecification((
	logic = "LIA",
	fname = :max6,
	params = [:x1, :x2, :x3, :x4, :x5, :x6],
	free_vars = [:x1, :x2, :x3, :x4, :x5, :x6],
	constraints = [
		"(>= (max6 x1 x2 x3 x4 x5 x6) x1)",
		"(>= (max6 x1 x2 x3 x4 x5 x6) x2)",
		"(>= (max6 x1 x2 x3 x4 x5 x6) x3)",
		"(>= (max6 x1 x2 x3 x4 x5 x6) x4)",
		"(>= (max6 x1 x2 x3 x4 x5 x6) x5)",
		"(>= (max6 x1 x2 x3 x4 x5 x6) x6)",
		"(or (= x1 (max6 x1 x2 x3 x4 x5 x6)) (= x2 (max6 x1 x2 x3 x4 x5 x6)) (= x3 (max6 x1 x2 x3 x4 x5 x6)) (= x4 (max6 x1 x2 x3 x4 x5 x6)) (= x5 (max6 x1 x2 x3 x4 x5 x6)) (= x6 (max6 x1 x2 x3 x4 x5 x6)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max6.sl"),
)))

problem_max7 = Problem("problem_max7", SMTSpecification((
	logic = "LIA",
	fname = :max7,
	params = [:x1, :x2, :x3, :x4, :x5, :x6, :x7],
	free_vars = [:x1, :x2, :x3, :x4, :x5, :x6, :x7],
	constraints = [
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x1)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x2)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x3)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x4)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x5)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x6)",
		"(>= (max7 x1 x2 x3 x4 x5 x6 x7) x7)",
		"(or (= x1 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x2 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x3 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x4 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x5 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x6 (max7 x1 x2 x3 x4 x5 x6 x7)) (= x7 (max7 x1 x2 x3 x4 x5 x6 x7)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max7.sl"),
)))

problem_max8 = Problem("problem_max8", SMTSpecification((
	logic = "LIA",
	fname = :max8,
	params = [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8],
	free_vars = [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8],
	constraints = [
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x1)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x2)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x3)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x4)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x5)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x6)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x7)",
		"(>= (max8 x1 x2 x3 x4 x5 x6 x7 x8) x8)",
		"(or (= x1 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x2 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x3 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x4 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x5 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x6 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x7 (max8 x1 x2 x3 x4 x5 x6 x7 x8)) (= x8 (max8 x1 x2 x3 x4 x5 x6 x7 x8)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max8.sl"),
)))

# Students' reference solution (cegis_success): ifelse(x < 0, 0 - x, x)
problem_abs_value_easy = Problem("problem_abs_value_easy", SMTSpecification((
	logic = "LIA",
	fname = :abs_val,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(>= (abs_val x) 0)",
		"(=> (>= x 0) (= (abs_val x) x))",
		"(=> (< x 0) (= (abs_val x) (- x)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "abs_value_easy.sl"),
)))

# Students' reference solution (cegis_success): x
problem_abs_value_medium = Problem("problem_abs_value_medium", SMTSpecification((
	logic = "LIA",
	fname = :abs_val,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(>= (abs_val x) 0)",
		"(and (=> (>= x 0) (= (abs_val x) x)) (=> (< x 0) (= (abs_val x) (- x))) (= (abs_val 0) 0))",
		"(= (abs_val (abs_val x)) (abs_val x))",
		"(= (abs_val 1) 1)",
		"(= (abs_val 5) 5)",
		"(= (abs_val 10) 10)",
		"(= (abs_val (- 1)) 1)",
		"(= (abs_val (- 5)) 5)",
		"(= (abs_val (- 10)) 10)",
		"(= (abs_val 0) 0)",
		"(= (abs_val (- x)) (abs_val x))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "abs_value_medium.sl"),
)))

# Students' reference solution (cegis_success): x
problem_abs_value_hard = Problem("problem_abs_value_hard", SMTSpecification((
	logic = "LIA",
	fname = :abs_val,
	params = [:x],
	free_vars = [:x, :y],
	constraints = [
		"(>= (abs_val x) 0)",
		"(=> (>= x 0) (= (abs_val x) x))",
		"(=> (< x 0) (= (abs_val x) (- x)))",
		"(= (abs_val 0) 0)",
		"(= (abs_val (- 1)) 1)",
		"(= (abs_val (- 2)) 2)",
		"(= (abs_val (- 5)) 5)",
		"(= (abs_val (- 10)) 10)",
		"(= (abs_val 1) 1)",
		"(= (abs_val 2) 2)",
		"(= (abs_val 5) 5)",
		"(= (abs_val 7) 7)",
		"(= (abs_val (abs_val x)) (abs_val x))",
		"(= (abs_val (- x)) (abs_val x))",
		"(<= (abs_val (+ x y)) (+ (abs_val x) (abs_val y)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "abs_value_hard.sl"),
)))

# Students' reference solution (cegis_failure): ifelse(x < 10, 0 < x, 10)
problem_clamp_value_easy = Problem("problem_clamp_value_easy", SMTSpecification((
	logic = "LIA",
	fname = :clamp,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(=> (< x 0) (= (clamp x) 0))",
		"(=> (> x 10) (= (clamp x) 10))",
		"(=> (and (>= x 0) (<= x 10)) (= (clamp x) x))",
		"(and (>= (clamp x) 0) (<= (clamp x) 10))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "clamp_value_easy.sl"),
)))

# Students' reference solution (cegis_success): ifelse(max_val < x, max_val, x)
problem_clamp_value_medium = Problem("problem_clamp_value_medium", SMTSpecification((
	logic = "LIA",
	fname = :clamp,
	params = [:x, :min_val, :max_val],
	free_vars = [:x, :min_val, :max_val],
	constraints = [
		"(=> (< x min_val) (= (clamp x min_val max_val) min_val))",
		"(=> (> x max_val) (= (clamp x min_val max_val) max_val))",
		"(=> (and (>= x min_val) (<= x max_val)) (= (clamp x min_val max_val) x))",
		"(and (>= (clamp x min_val max_val) min_val) (<= (clamp x min_val max_val) max_val))",
		"(=> (< x min_val) (> (clamp (+ x 1) min_val max_val) (clamp x min_val max_val)))",
		"(= (clamp (clamp x min_val max_val) min_val max_val) (clamp x min_val max_val))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "clamp_value_medium.sl"),
)))

# Students' reference solution (cegis_failure): (hard_max < 0 - soft_min) * soft_min
problem_clamp_value_hard = Problem("problem_clamp_value_hard", SMTSpecification((
	logic = "LIA",
	fname = :adaptive_clamp,
	params = [:x, :soft_min, :hard_min, :soft_max, :hard_max],
	free_vars = [:x, :soft_min, :hard_min, :soft_max, :hard_max, :y],
	constraints = [
		"(and (>= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_min) (<= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_max))",
		"(=> (< x hard_min) (= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_min))",
		"(=> (> x hard_max) (= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_max))",
		"(=> (and (>= x soft_min) (<= x soft_max)) (= (adaptive_clamp x soft_min hard_min soft_max hard_max) x))",
		"(=> (and (>= x hard_min) (< x soft_min)) (= (adaptive_clamp x soft_min hard_min soft_max hard_max) soft_min))",
		"(=> (and (> x soft_max) (<= x hard_max)) (= (adaptive_clamp x soft_min hard_min soft_max hard_max) soft_max))",
		"(=> (< x y) (<= (adaptive_clamp x soft_min hard_min soft_max hard_max) (adaptive_clamp y soft_min hard_min soft_max hard_max)))",
		"(= (adaptive_clamp (adaptive_clamp x soft_min hard_min soft_max hard_max) soft_min hard_min soft_max hard_max) (adaptive_clamp x soft_min hard_min soft_max hard_max))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "clamp_value_hard.sl"),
)))

# Students' reference solution (cegis_failure): (x < x * x) * 10
problem_conditional_sum_easy = Problem("problem_conditional_sum_easy", SMTSpecification((
	logic = "LIA",
	fname = :cond_sum,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(=> (>= (+ x y) 10) (= (cond_sum x y) (+ x y)))",
		"(=> (< (+ x y) 10) (= (cond_sum x y) 0))",
		"(>= (cond_sum x y) 0)",
	],
	spec_file = joinpath(@__DIR__, "specifications", "conditional_sum_easy.sl"),
)))

# Students' reference solution (cegis_failure): 0 - (x < y)
problem_conditional_sum_medium = Problem("problem_conditional_sum_medium", SMTSpecification((
	logic = "LIA",
	fname = :cond_sum,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(=> (and (> x 0) (> y 0) (>= (+ x y) 15)) (= (cond_sum x y) (+ x y)))",
		"(=> (and (> x 0) (<= y 0) (>= x 7)) (= (cond_sum x y) x))",
		"(=> (and (<= x 0) (> y 0) (>= y 7)) (= (cond_sum x y) y))",
		"(=> (and (> x 0) (> y 0) (< (+ x y) 15)) (or (= (cond_sum x y) (max x y)) (= (cond_sum x y) (+ x y))))",
		"(=> (or (and (> x 0) (<= y 0) (< x 7)) (and (<= x 0) (> y 0) (< y 7)) (and (<= x 0) (<= y 0))) (= (cond_sum x y) 0))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "conditional_sum_medium.sl"),
)))

# Students' reference solution (cegis_failure): ifelse(z < 15, 0, z)
problem_conditional_sum_hard = Problem("problem_conditional_sum_hard", SMTSpecification((
	logic = "LIA",
	fname = :cond_sum,
	params = [:x, :y, :z],
	free_vars = [:x, :y, :z],
	constraints = [
		"(=> (and (> x 0) (> y 0) (> z 0) (> (+ (+ x y) z) 20)) (= (cond_sum x y z) (+ (+ x y) z)))",
		"(=> (and (> x 0) (> y 0) (<= z 0) (> (+ x y) 15)) (= (cond_sum x y z) (+ x y)))",
		"(=> (and (> x 0) (<= y 0) (> z 0) (> (+ x z) 15)) (= (cond_sum x y z) (+ x z)))",
		"(=> (and (<= x 0) (> y 0) (> z 0) (> (+ y z) 15)) (= (cond_sum x y z) (+ y z)))",
		"(=> (and (> x 0) (<= y 0) (<= z 0) (>= x 10)) (= (cond_sum x y z) x))",
		"(=> (and (<= x 0) (> y 0) (<= z 0) (>= y 10)) (= (cond_sum x y z) y))",
		"(=> (and (<= x 0) (<= y 0) (> z 0) (>= z 10)) (= (cond_sum x y z) z))",
		"(=> (or (<= (+ (+ x y) z) 0) (and (or (<= x 0) (<= y 0) (<= z 0)) (< (+ (+ x y) z) 20))) (= (cond_sum x y z) 0))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "conditional_sum_hard.sl"),
)))

# Students' reference solution (cegis_failure): (1 >= y * x) - 1
problem_find_max_three_easy = Problem("problem_find_max_three_easy", SMTSpecification((
	logic = "LIA",
	fname = :max3,
	params = [:x, :y, :z],
	free_vars = [:x, :y, :z],
	constraints = [
		"(>= (max3 x y z) x)",
		"(>= (max3 x y z) y)",
		"(>= (max3 x y z) z)",
		"(or (= x (max3 x y z)) (or (= y (max3 x y z)) (= z (max3 x y z))))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "find_max_three_easy.sl"),
)))

# Students' reference solution (cegis_success): ifelse(y < x, x, y)
problem_find_max_three_medium = Problem("problem_find_max_three_medium", SMTSpecification((
	logic = "LIA",
	fname = :max3,
	params = [:x, :y, :z],
	free_vars = [:x, :y, :z],
	constraints = [
		"(>= (max3 x y z) x)",
		"(>= (max3 x y z) y)",
		"(>= (max3 x y z) z)",
		"(or (= x (max3 x y z)) (or (= y (max3 x y z)) (= z (max3 x y z))))",
		"(= (max3 x x x) x)",
		"(= (max3 x y z) (max3 y x z))",
		"(= (max3 x y z) (max3 x z y))",
		"(>= (max3 x y z) (max x y))",
		"(>= (max3 x y z) (max y z))",
		"(>= (max3 x y z) (max x z))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "find_max_three_medium.sl"),
)))

# Students' reference solution (cegis_success): ifelse(y < x, x, y)
problem_find_max_three_hard = Problem("problem_find_max_three_hard", SMTSpecification((
	logic = "LIA",
	fname = :max3,
	params = [:x, :y, :z],
	free_vars = [:x, :y, :z, :w],
	constraints = [
		"(>= (max3 x y z) x)",
		"(>= (max3 x y z) y)",
		"(>= (max3 x y z) z)",
		"(or (= x (max3 x y z)) (or (= y (max3 x y z)) (= z (max3 x y z))))",
		"(= (max3 x x x) x)",
		"(= (max3 x y z) (max3 y x z))",
		"(= (max3 x y z) (max3 x z y))",
		"(>= (max3 x y z) (max x y))",
		"(>= (max3 x y z) (max y z))",
		"(>= (max3 x y z) (max x z))",
		"(=> (and (<= x y) (<= y z)) (= (max3 x y z) z))",
		"(=> (and (<= z y) (<= y x)) (= (max3 x y z) x))",
		"(=> (and (<= x y) (<= y z)) (= (max3 x y z) z))",
		"(=> (and (<= z y) (<= y x)) (= (max3 x y z) x))",
		"(=> (and (<= x w) (= w (+ x 1))) (<= (max3 x y z) (max3 w y z)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "find_max_three_hard.sl"),
)))

# Students' reference solution (cegis_success): ifelse(y < x, x, y)
problem_max_two_easy = Problem("problem_max_two_easy", SMTSpecification((
	logic = "LIA",
	fname = :max2,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(>= (max2 x y) x)",
		"(>= (max2 x y) y)",
		"(or (= x (max2 x y)) (= y (max2 x y)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max_two_easy.sl"),
)))

# Students' reference solution (cegis_success): ifelse(y < x, x, y)
problem_max_two_medium = Problem("problem_max_two_medium", SMTSpecification((
	logic = "LIA",
	fname = :max2,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(>= (max2 x y) x)",
		"(>= (max2 x y) y)",
		"(or (= x (max2 x y)) (= y (max2 x y)))",
		"(=> (not (= x y)) (or (= (max2 x y) x) (= (max2 x y) y)))",
		"(=> (= x y) (= (max2 x y) x))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max_two_medium.sl"),
)))

# Students' reference solution (cegis_success): y
problem_max_two_hard = Problem("problem_max_two_hard", SMTSpecification((
	logic = "LIA",
	fname = :max2,
	params = [:x, :y],
	free_vars = [:x, :y],
	constraints = [
		"(>= (max2 x y) x)",
		"(>= (max2 x y) y)",
		"(or (= x (max2 x y)) (= y (max2 x y)))",
		"(=> (and (> x 0) (> y 0)) (and (>= (max2 x y) x) (>= (max2 x y) y)))",
		"(=> (and (< x 0) (< y 0)) (>= (max2 x y) (+ (min x y) 1)))",
		"(=> (and (<= x 0) (>= y 0)) (or (= (max2 x y) x) (= (max2 x y) y)))",
		"(= (max2 x x) x)",
		"(= (max2 1 5) 5)",
		"(= (max2 10 3) 10)",
		"(= (max2 5 5) 5)",
		"(= (max2 (- 3) (- 1)) (- 1))",
		"(= (max2 (- 1) (- 3)) (- 1))",
		"(= (max2 (- 5) 2) 2)",
		"(not (= (max2 10 3) 3))",
		"(not (= (max2 1 5) 1))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "max_two_hard.sl"),
)))

# Students' reference solution (cegis_success): (0 < x) - (x < 0)
problem_sign_function_easy = Problem("problem_sign_function_easy", SMTSpecification((
	logic = "LIA",
	fname = :sign,
	params = [:x],
	free_vars = [:x],
	constraints = [
		"(=> (> x 0) (= (sign x) 1))",
		"(=> (= x 0) (= (sign x) 0))",
		"(=> (< x 0) (= (sign x) (- 1)))",
		"(or (= (sign x) (- 1)) (or (= (sign x) 0) (= (sign x) 1)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "sign_function_easy.sl"),
)))

# Students' reference solution (cegis_success): x
problem_sign_function_medium = Problem("problem_sign_function_medium", SMTSpecification((
	logic = "LIA",
	fname = :sign,
	params = [:x],
	free_vars = [:x, :y],
	constraints = [
		"(=> (> x 0) (= (sign x) 1))",
		"(=> (= x 0) (= (sign x) 0))",
		"(=> (< x 0) (= (sign x) (- 1)))",
		"(= (sign 1) 1)",
		"(= (sign 5) 1)",
		"(= (sign 2) 1)",
		"(= (sign (- 1)) (- 1))",
		"(= (sign (- 3)) (- 1))",
		"(= (sign (- 5)) (- 1))",
		"(= (sign 0) 0)",
		"(not (= (sign 5) 5))",
		"(not (= (sign 10) 10))",
		"(not (= (sign (- 5)) (- 5)))",
		"(and (<= (sign x) 1) (>= (sign x) (- 1)))",
		"(=> (not (= x 0)) (= (sign (- x)) (- (sign x))))",
		"(=> (> x 0) (> (sign x) 0))",
		"(=> (< x 0) (< (sign x) 0))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "sign_function_medium.sl"),
)))

# Students' reference solution (cegis_success): x
problem_sign_function_hard = Problem("problem_sign_function_hard", SMTSpecification((
	logic = "LIA",
	fname = :sign,
	params = [:x],
	free_vars = [:x, :y, :z],
	constraints = [
		"(=> (> x 0) (= (sign x) 1))",
		"(=> (= x 0) (= (sign x) 0))",
		"(=> (< x 0) (= (sign x) (- 1)))",
		"(= (sign 1) 1)",
		"(= (sign 5) 1)",
		"(= (sign 100) 1)",
		"(= (sign (- 1)) (- 1))",
		"(= (sign (- 5)) (- 1))",
		"(= (sign (- 100)) (- 1))",
		"(= (sign 0) 0)",
		"(not (= (sign 5) 5))",
		"(not (= (sign 10) 10))",
		"(not (= (sign 100) 100))",
		"(not (= (sign (- 5)) (- 5)))",
		"(not (= (sign (- 10)) (- 10)))",
		"(= (sign (sign x)) (sign x))",
		"(=> (not (= x 0)) (= (sign (- x)) (- (sign x))))",
		"(and (<= (sign x) 1) (>= (sign x) (- 1)))",
	],
	spec_file = joinpath(@__DIR__, "specifications", "sign_function_hard.sl"),
)))
