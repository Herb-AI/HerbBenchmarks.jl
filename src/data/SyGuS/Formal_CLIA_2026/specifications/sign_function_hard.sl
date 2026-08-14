;; Hard: Sign Function with Advanced Properties
;; Complex sign function with properties over multiple variables
;; Expected solution: Multi-branch conditional with negation

(set-logic LIA)

(synth-fun sign ((x Int)) Int)

(declare-var x Int)
(declare-var y Int)
(declare-var z Int)

;; Core constraints
(constraint (=> (> x 0) (= (sign x) 1)))
(constraint (=> (= x 0) (= (sign x) 0)))
(constraint (=> (< x 0) (= (sign x) (- 1))))

;; CRITICAL TEST CASES: Force branching
(constraint (= (sign 1) 1))
(constraint (= (sign 5) 1))
(constraint (= (sign 100) 1))
(constraint (= (sign (- 1)) (- 1)))
(constraint (= (sign (- 5)) (- 1)))
(constraint (= (sign (- 100)) (- 1)))
(constraint (= (sign 0) 0))

;; Explicit contradictions to identity
(constraint (not (= (sign 5) 5)))
(constraint (not (= (sign 10) 10)))
(constraint (not (= (sign 100) 100)))
(constraint (not (= (sign (- 5)) (- 5))))
(constraint (not (= (sign (- 10)) (- 10))))

;; Idempotence on sign: sign(sign(x)) = sign(x) when result is in {-1,0,1}
(constraint (= (sign (sign x)) (sign x)))

;; Symmetry: sign(-x) = -sign(x) for non-zero x
(constraint (=> (not (= x 0)) (= (sign (- x)) (- (sign x)))))

;; Bounded: |sign(x)| <= 1
(constraint (and (<= (sign x) 1) (>= (sign x) (- 1))))

(check-synth)

