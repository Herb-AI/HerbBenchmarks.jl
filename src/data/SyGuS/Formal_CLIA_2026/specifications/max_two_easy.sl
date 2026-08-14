;; Easy: Maximum of Two Numbers
;; Simple specification with basic constraints
;; Expected solution: max(x, y) or ifelse(x > y, x, y)

(set-logic LIA)

(synth-fun max2 ((x Int) (y Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Constraint 1: Result must be >= x
(constraint (>= (max2 x y) x))

;; Constraint 2: Result must be >= y
(constraint (>= (max2 x y) y))

;; Constraint 3: Result must be either x or y
(constraint (or (= x (max2 x y)) (= y (max2 x y))))

(check-synth)
