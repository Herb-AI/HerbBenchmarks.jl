;; Easy: Sign Function
;; Return -1 for negative, 0 for zero, 1 for positive
;; Expected solution: ifelse conditions checking value ranges

(set-logic LIA)

(synth-fun sign ((x Int)) Int)

(declare-var x Int)

;; For positive x, result is 1
(constraint (=> (> x 0) (= (sign x) 1)))

;; For x = 0, result is 0
(constraint (=> (= x 0) (= (sign x) 0)))

;; For negative x, result is -1
(constraint (=> (< x 0) (= (sign x) (- 1))))

;; Result is in {-1, 0, 1}
(constraint (or (= (sign x) (- 1)) (or (= (sign x) 0) (= (sign x) 1))))

(check-synth)
