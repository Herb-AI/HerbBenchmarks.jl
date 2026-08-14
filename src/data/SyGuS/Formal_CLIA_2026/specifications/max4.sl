(set-logic LIA)

(synth-fun max4 ((x1 Int) (x2 Int) (x3 Int) (x4 Int)) Int)

(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var x4 Int)

(constraint (>= (max4 x1 x2 x3 x4) x1))
(constraint (>= (max4 x1 x2 x3 x4) x2))
(constraint (>= (max4 x1 x2 x3 x4) x3))
(constraint (>= (max4 x1 x2 x3 x4) x4))
(constraint (or (= x1 (max4 x1 x2 x3 x4)) (= x2 (max4 x1 x2 x3 x4)) (= x3 (max4 x1 x2 x3 x4)) (= x4 (max4 x1 x2 x3 x4))))

(check-synth)
