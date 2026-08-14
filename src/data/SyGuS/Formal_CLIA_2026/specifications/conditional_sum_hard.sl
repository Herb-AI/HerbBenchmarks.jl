;; Hard: Weighted Conditional Aggregation
;; Complex nested conditions with weighted sums
;; Expected solution: Complex multi-branch nested conditionals

(set-logic LIA)

(declare-fun min (Int Int) Int)
(declare-fun max (Int Int) Int)

(synth-fun cond_sum ((x Int) (y Int) (z Int)) Int)

(declare-var x Int)
(declare-var y Int)
(declare-var z Int)

;; Primary branch: All three positive and sum > 20 -> return triple sum
(constraint (=> (and (> x 0) (> y 0) (> z 0) (> (+ (+ x y) z) 20))
                (= (cond_sum x y z) (+ (+ x y) z))))

;; Secondary branch: Two positive, sum > 15 -> return sum of two
(constraint (=> (and (> x 0) (> y 0) (<= z 0) (> (+ x y) 15))
                (= (cond_sum x y z) (+ x y))))

(constraint (=> (and (> x 0) (<= y 0) (> z 0) (> (+ x z) 15))
                (= (cond_sum x y z) (+ x z))))

(constraint (=> (and (<= x 0) (> y 0) (> z 0) (> (+ y z) 15))
                (= (cond_sum x y z) (+ y z))))

;; Tertiary branch: Only one positive, value >= 10 -> return it
(constraint (=> (and (> x 0) (<= y 0) (<= z 0) (>= x 10))
                (= (cond_sum x y z) x)))

(constraint (=> (and (<= x 0) (> y 0) (<= z 0) (>= y 10))
                (= (cond_sum x y z) y)))

(constraint (=> (and (<= x 0) (<= y 0) (> z 0) (>= z 10))
                (= (cond_sum x y z) z)))

;; Default case: return 0 for all other combinations
(constraint (=> (or (<= (+ (+ x y) z) 0)
                    (and (or (<= x 0) (<= y 0) (<= z 0))
                         (< (+ (+ x y) z) 20)))
                (= (cond_sum x y z) 0)))

(check-synth)
