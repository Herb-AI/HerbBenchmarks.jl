;; Medium: Clamp with Variable Bounds
;; Constrain value x to be within [min_val, max_val] range
;; Expected solution: nested max/min or ifelse

(set-logic LIA)

(synth-fun clamp ((x Int) (min_val Int) (max_val Int)) Int)

(declare-var x Int)
(declare-var min_val Int)
(declare-var max_val Int)

;; If x < min_val, return min_val
(constraint (=> (< x min_val) (= (clamp x min_val max_val) min_val)))

;; If x > max_val, return max_val
(constraint (=> (> x max_val) (= (clamp x min_val max_val) max_val)))

;; If min_val <= x <= max_val, return x
(constraint (=> (and (>= x min_val) (<= x max_val)) 
                (= (clamp x min_val max_val) x)))

;; Result is always in range [min_val, max_val]
(constraint (and (>= (clamp x min_val max_val) min_val) 
                 (<= (clamp x min_val max_val) max_val)))

;; Property: clamping is monotonic in x
(constraint (=> (< x min_val)
                (> (clamp (+ x 1) min_val max_val) (clamp x min_val max_val))))

;; Idempotence: clamp(clamp(x, a, b), a, b) = clamp(x, a, b)
(constraint (= (clamp (clamp x min_val max_val) min_val max_val)
               (clamp x min_val max_val)))

(check-synth)
