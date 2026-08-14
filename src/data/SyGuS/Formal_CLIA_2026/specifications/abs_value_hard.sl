;; Hard: Absolute Value with Complex Mathematical Properties
;; Complex specification with triangle inequality and composition properties
;; Expected solution: ifelse(x >= 0, x, -(x))

(set-logic LIA)

(synth-fun abs_val ((x Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Core constraints - STRICT: no OR clauses
;; These MUST be satisfied - no alternatives
(constraint (>= (abs_val x) 0))
(constraint (=> (>= x 0) (= (abs_val x) x)))
(constraint (=> (< x 0) (= (abs_val x) (- x))))
(constraint (= (abs_val 0) 0))

;; FORCED TEST CASES: Initial counterexamples that reject trivial solutions
;; Multiple negative cases ensure identity fails
(constraint (= (abs_val (- 1)) 1))
(constraint (= (abs_val (- 2)) 2))
(constraint (= (abs_val (- 5)) 5))
(constraint (= (abs_val (- 10)) 10))

;; Positive cases for comparison
(constraint (= (abs_val 1) 1))
(constraint (= (abs_val 2) 2))
(constraint (= (abs_val 5) 5))
(constraint (= (abs_val 7) 7))

;; Properties
(constraint (= (abs_val (abs_val x)) (abs_val x)))
(constraint (= (abs_val (- x)) (abs_val x)))
(constraint (<= (abs_val (+ x y)) (+ (abs_val x) (abs_val y))))

(check-synth)
