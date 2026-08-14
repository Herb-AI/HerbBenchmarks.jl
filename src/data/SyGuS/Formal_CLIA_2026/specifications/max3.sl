(set-logic LIA)

(synth-fun max3 ((x1 Int) (x2 Int) (x3 Int)) Int)

(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)

(constraint (>= (max3 x1 x2 x3) x1))
(constraint (>= (max3 x1 x2 x3) x2))
(constraint (>= (max3 x1 x2 x3) x3))
(constraint (or (= x1 (max3 x1 x2 x3)) (= x2 (max3 x1 x2 x3)) (= x3 (max3 x1 x2 x3))))

(check-synth)
