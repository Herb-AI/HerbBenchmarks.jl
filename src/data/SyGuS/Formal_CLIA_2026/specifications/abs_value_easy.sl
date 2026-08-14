;; Easy: Absolute Value
;; Simple specification to compute absolute value of a single integer
;; Expected solution: ifelse(x >= 0, x, -(x)) or ifelse(x < 0, -(x), x)

(set-logic LIA)

(synth-fun abs_val ((x Int)) Int)

(declare-var x Int)

;; Result is non-negative
(constraint (>= (abs_val x) 0))

;; Result equals input if input is non-negative
(constraint (=> (>= x 0) (= (abs_val x) x)))

;; Result equals negation if input is negative
(constraint (=> (< x 0) (= (abs_val x) (- x))))

(check-synth)
