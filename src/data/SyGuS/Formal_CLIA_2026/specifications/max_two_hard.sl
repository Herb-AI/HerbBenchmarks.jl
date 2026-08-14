;; Hard: Maximum with Negative Number Verification
;; Complex specification with strict properties for negative/positive numbers
;; Expected solution: max(x, y) or ifelse(x > y, x, y)

(set-logic LIA)

(declare-fun min (Int Int) Int)
(declare-fun max (Int Int) Int)

(synth-fun max2 ((x Int) (y Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Core constraints
(constraint (>= (max2 x y) x))
(constraint (>= (max2 x y) y))
(constraint (or (= x (max2 x y)) (= y (max2 x y))))

;; Property: For positive numbers, result is at least the larger value
(constraint (=> (and (> x 0) (> y 0)) (and (>= (max2 x y) x) (>= (max2 x y) y))))

;; Property: For negative numbers, result is larger (closer to zero)
(constraint (=> (and (< x 0) (< y 0)) (>= (max2 x y) (+ (min x y) 1))))

;; Property: Mixed signs - result is maximum distance from zero that's still <= distance of each
(constraint (=> (and (<= x 0) (>= y 0)) 
                (or (= (max2 x y) x) (= (max2 x y) y))))

;; Property: Idempotence - max of same value is that value
(constraint (= (max2 x x) x))

;; CRITICAL TEST CASES: Cover both branches
;; These force the synthesizer to recognize when x > y vs y > x
(constraint (= (max2 1 5) 5))      ; y > x case
(constraint (= (max2 10 3) 10))    ; x > y case
(constraint (= (max2 5 5) 5))      ; x = y case
(constraint (= (max2 (- 3) (- 1)) (- 1)))  ; both negative, y > x
(constraint (= (max2 (- 1) (- 3)) (- 1)))  ; both negative, x > y
(constraint (= (max2 (- 5) 2) 2))  ; mixed signs

;; Explicit contradictions
;; Solution cannot be just 'y' (fails when x > y) or just 'x' (fails when y > x)
(constraint (not (= (max2 10 3) 3)))
(constraint (not (= (max2 1 5) 1)))

(check-synth)
