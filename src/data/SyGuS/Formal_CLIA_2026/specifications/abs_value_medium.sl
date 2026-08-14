;; Medium: Absolute Value with Extra Properties
;; Specification with additional properties about absolute value behavior
;; Expected solution: ifelse(x >= 0, x, -(x))

(set-logic LIA)

(synth-fun abs_val ((x Int)) Int)

(declare-var x Int)

;; Core constraints - NO IMPLICATIONS, only requirements
(constraint (>= (abs_val x) 0))

;; Key insight: Use 'and' not '=>' to force both must hold
;; The solution must handle BOTH cases correctly simultaneously
(constraint (and
  (=> (>= x 0) (= (abs_val x) x))
  (=> (< x 0) (= (abs_val x) (- x)))
  (= (abs_val 0) 0)
))

;; Property: Absolute value is idempotent
(constraint (= (abs_val (abs_val x)) (abs_val x)))

;; CRITICAL: Concrete test case requirements from distinct input groups
;; Positive inputs
(constraint (= (abs_val 1) 1))
(constraint (= (abs_val 5) 5))
(constraint (= (abs_val 10) 10))

;; Negative inputs - DIFFERENT OUTPUT REQUIRED
(constraint (= (abs_val (- 1)) 1))
(constraint (= (abs_val (- 5)) 5))
(constraint (= (abs_val (- 10)) 10))

;; Zero
(constraint (= (abs_val 0) 0))

;; Symmetry: abs(-x) = abs(x)
(constraint (= (abs_val (- x)) (abs_val x)))

(check-synth)
