;; Medium: Conditional Multi-branch Sum
;; Multiple conditions: sum if high, individual values if medium, 0 if low
;; Expected solution: Complex multi-branch conditional

(set-logic LIA)

(declare-fun min (Int Int) Int)
(declare-fun max (Int Int) Int)

(synth-fun cond_sum ((x Int) (y Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Case 1: If both x and y are positive and sum >= 15, return sum
(constraint (=> (and (> x 0) (> y 0) (>= (+ x y) 15)) 
                (= (cond_sum x y) (+ x y))))

;; Case 2: If only one is positive, return the positive one if >= 7, else 0
(constraint (=> (and (> x 0) (<= y 0) (>= x 7))
                (= (cond_sum x y) x)))

(constraint (=> (and (<= x 0) (> y 0) (>= y 7))
                (= (cond_sum x y) y)))

;; Case 3: If both are positive but sum < 15, return just the larger
(constraint (=> (and (> x 0) (> y 0) (< (+ x y) 15))
                (or (= (cond_sum x y) (max x y)) (= (cond_sum x y) (+ x y)))))

;; Case 4: All other cases return 0
(constraint (=> (or (and (> x 0) (<= y 0) (< x 7))
                    (and (<= x 0) (> y 0) (< y 7))
                    (and (<= x 0) (<= y 0)))
                (= (cond_sum x y) 0)))

(check-synth)
