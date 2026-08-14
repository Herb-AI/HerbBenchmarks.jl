;; Easy: Simple Conditional Sum
;; Sum the first two numbers if their sum exceeds threshold
;; Expected solution: ifelse(x + y > threshold, x + y, 0)

(set-logic LIA)

(synth-fun cond_sum ((x Int) (y Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Constraint 1: If sum >= 10, return sum
(constraint (=> (>= (+ x y) 10) (= (cond_sum x y) (+ x y))))

;; Constraint 2: If sum < 10, return 0
(constraint (=> (< (+ x y) 10) (= (cond_sum x y) 0)))

;; Constraint 3: Result is non-negative
(constraint (>= (cond_sum x y) 0))

(check-synth)
