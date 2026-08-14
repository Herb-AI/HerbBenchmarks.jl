;; Medium: Maximum of Three with Ordering Properties
;; Extended specification with additional properties
;; Expected solution: Nested ifelse conditions

(set-logic LIA)

(declare-fun min (Int Int) Int)
(declare-fun max (Int Int) Int)

(synth-fun max3 ((x Int) (y Int) (z Int)) Int)

(declare-var x Int)
(declare-var y Int)
(declare-var z Int)

;; Core constraints
(constraint (>= (max3 x y z) x))
(constraint (>= (max3 x y z) y))
(constraint (>= (max3 x y z) z))
(constraint (or (= x (max3 x y z)) 
                (or (= y (max3 x y z)) (= z (max3 x y z)))))

;; Idempotence
(constraint (= (max3 x x x) x))

;; Commutativity (first two args)
(constraint (= (max3 x y z) (max3 y x z)))

;; Commutativity (last two args)
(constraint (= (max3 x y z) (max3 x z y)))

;; Associativity-like property
(constraint (>= (max3 x y z) (max x y)))
(constraint (>= (max3 x y z) (max y z)))
(constraint (>= (max3 x y z) (max x z)))

(check-synth)
