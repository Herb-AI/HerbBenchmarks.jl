;; Medium: Maximum of Two Numbers with Extra Constraints
;; Slightly more complex with additional verification constraints
;; Expected solution: max(x, y) or ifelse(x > y, x, y)

(set-logic LIA)

(synth-fun max2 ((x Int) (y Int)) Int)

(declare-var x Int)
(declare-var y Int)

;; Core constraints
(constraint (>= (max2 x y) x))
(constraint (>= (max2 x y) y))
(constraint (or (= x (max2 x y)) (= y (max2 x y))))

;; Additional constraint: Result must be different from the other value if they differ
(constraint (=> (not (= x y)) (or (= (max2 x y) x) (= (max2 x y) y))))

;; Additional constraint: If both are equal, result should be that value
(constraint (=> (= x y) (= (max2 x y) x)))

(check-synth)
