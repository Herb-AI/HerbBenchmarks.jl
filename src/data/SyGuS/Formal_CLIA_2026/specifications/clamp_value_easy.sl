;; Easy: Clamp Value
;; Constrain value to be within [0, 10] range
;; Expected solution: max(0, min(x, 10)) or nested ifelse

(set-logic LIA)

(synth-fun clamp ((x Int)) Int)

(declare-var x Int)

;; If x < 0, return 0
(constraint (=> (< x 0) (= (clamp x) 0)))

;; If x > 10, return 10
(constraint (=> (> x 10) (= (clamp x) 10)))

;; If 0 <= x <= 10, return x
(constraint (=> (and (>= x 0) (<= x 10)) (= (clamp x) x)))

;; Result is always in range [0, 10]
(constraint (and (>= (clamp x) 0) (<= (clamp x) 10)))

(check-synth)
