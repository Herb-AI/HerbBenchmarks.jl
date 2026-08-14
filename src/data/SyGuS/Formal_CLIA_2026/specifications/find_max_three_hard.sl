;; Hard: Maximum of Three with Complex Algebraic Properties
;; Complex specification with mathematical properties and edge cases
;; Expected solution: Nested ifelse with multiple levels

(set-logic LIA)

(declare-fun min (Int Int) Int)
(declare-fun max (Int Int) Int)

(synth-fun max3 ((x Int) (y Int) (z Int)) Int)

(declare-var x Int)
(declare-var y Int)
(declare-var z Int)
(declare-var w Int)

;; Core constraints
(constraint (>= (max3 x y z) x))
(constraint (>= (max3 x y z) y))
(constraint (>= (max3 x y z) z))
(constraint (or (= x (max3 x y z)) 
                (or (= y (max3 x y z)) (= z (max3 x y z)))))

;; Idempotence and symmetries
(constraint (= (max3 x x x) x))
(constraint (= (max3 x y z) (max3 y x z)))
(constraint (= (max3 x y z) (max3 x z y)))

;; Pairwise consistency
(constraint (>= (max3 x y z) (max x y)))
(constraint (>= (max3 x y z) (max y z)))
(constraint (>= (max3 x y z) (max x z)))

;; Ordering: if x <= y <= z, then max3(x,y,z) = z
(constraint (=> (and (<= x y) (<= y z)) (= (max3 x y z) z)))

;; Ordering: if z <= y <= x, then max3(x,y,z) = x
(constraint (=> (and (<= z y) (<= y x)) (= (max3 x y z) x)))

;; Mixed ordering: if y is between x and z
(constraint (=> (and (<= x y) (<= y z)) (= (max3 x y z) z)))
(constraint (=> (and (<= z y) (<= y x)) (= (max3 x y z) x)))

;; Strict monotonicity in the max: if one input increases, max doesn't decrease
(constraint (=> (and (<= x w) (= w (+ x 1))) 
                (<= (max3 x y z) (max3 w y z))))

(check-synth)
