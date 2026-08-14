;; Medium: Sign Function with Properties
;; Sign function with additional mathematical properties
;; Expected solution: Nested ifelse with property checks

(set-logic LIA)

(synth-fun sign ((x Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Core constraints
(constraint (=> (> x 0) (= (sign x) 1)))
(constraint (=> (= x 0) (= (sign x) 0)))
(constraint (=> (< x 0) (= (sign x) (- 1))))

;; CRITICAL TEST CASES: Impossible for identity to satisfy
;; These force required branching logic
(constraint (= (sign 1) 1))        ; sign(1) = 1, NOT 1 (happens to work)
(constraint (= (sign 5) 1))        ; sign(5) = 1, NOT 5 (forces failure of identity)
(constraint (= (sign 2) 1))        ; sign(2) = 1, NOT 2 (forces failure of identity)
(constraint (= (sign (- 1)) (- 1)))  ; sign(-1) = -1, NOT -1 (happens to work)
(constraint (= (sign (- 3)) (- 1)))  ; sign(-3) = -1, NOT -3 (forces failure)
(constraint (= (sign (- 5)) (- 1)))  ; sign(-5) = -1, NOT -5 (forces failure)
(constraint (= (sign 0) 0))        ; sign(0) = 0

;; Explicit contradictions to identity function
(constraint (not (= (sign 5) 5)))     ; 5 ≠ sign(5)
(constraint (not (= (sign 10) 10)))   ; 10 ≠ sign(10)
(constraint (not (= (sign (- 5)) (- 5))))  ; -5 ≠ sign(-5)

;; Bounded: |sign(x)| <= 1
(constraint (and (<= (sign x) 1) (>= (sign x) (- 1))))

;; Property: sign(-x) = -sign(x) for non-zero x
(constraint (=> (not (= x 0)) (= (sign (- x)) (- (sign x)))))

;; Property: sign of positive is 1, negative is -1
(constraint (=> (> x 0) (> (sign x) 0)))
(constraint (=> (< x 0) (< (sign x) 0)))

(check-synth)
