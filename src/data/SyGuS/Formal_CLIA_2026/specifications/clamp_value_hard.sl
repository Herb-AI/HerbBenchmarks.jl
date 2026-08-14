;; Hard: Multi-range Clamp Function
;; Constrain values to multiple ranges with different behaviors
;; Expected solution: Complex multi-branch conditional

(set-logic LIA)

(synth-fun adaptive_clamp ((x Int) (soft_min Int) (hard_min Int) 
                           (soft_max Int) (hard_max Int)) Int)

(declare-var x Int)
(declare-var soft_min Int)
(declare-var hard_min Int)
(declare-var soft_max Int)
(declare-var hard_max Int)
(declare-var y Int)

;; Hard constraints: must be within [hard_min, hard_max]
(constraint (and (>= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_min)
                 (<= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_max)))

;; If x < hard_min, clamp to hard_min
(constraint (=> (< x hard_min) 
                (= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_min)))

;; If x > hard_max, clamp to hard_max
(constraint (=> (> x hard_max)
                (= (adaptive_clamp x soft_min hard_min soft_max hard_max) hard_max)))

;; If in soft range, return x
(constraint (=> (and (>= x soft_min) (<= x soft_max))
                (= (adaptive_clamp x soft_min hard_min soft_max hard_max) x)))

;; If between hard_min and soft_min, clamp to soft_min
(constraint (=> (and (>= x hard_min) (< x soft_min))
                (= (adaptive_clamp x soft_min hard_min soft_max hard_max) soft_min)))

;; If between soft_max and hard_max, clamp to soft_max
(constraint (=> (and (> x soft_max) (<= x hard_max))
                (= (adaptive_clamp x soft_min hard_min soft_max hard_max) soft_max)))

;; Monotonicity: if x increases, result doesn't decrease
(constraint (=> (< x y) 
                (<= (adaptive_clamp x soft_min hard_min soft_max hard_max)
                    (adaptive_clamp y soft_min hard_min soft_max hard_max))))

;; Idempotence
(constraint (= (adaptive_clamp (adaptive_clamp x soft_min hard_min soft_max hard_max)
                                soft_min hard_min soft_max hard_max)
               (adaptive_clamp x soft_min hard_min soft_max hard_max)))

(check-synth)
