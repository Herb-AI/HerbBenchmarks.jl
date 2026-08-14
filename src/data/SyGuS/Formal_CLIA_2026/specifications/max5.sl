(set-logic LIA)

(synth-fun max5 ((x1 Int) (x2 Int) (x3 Int) (x4 Int) (x5 Int)) Int)

(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var x4 Int)
(declare-var x5 Int)

(constraint (>= (max5 x1 x2 x3 x4 x5) x1))
(constraint (>= (max5 x1 x2 x3 x4 x5) x2))
(constraint (>= (max5 x1 x2 x3 x4 x5) x3))
(constraint (>= (max5 x1 x2 x3 x4 x5) x4))
(constraint (>= (max5 x1 x2 x3 x4 x5) x5))
(constraint (or (= x1 (max5 x1 x2 x3 x4 x5)) (= x2 (max5 x1 x2 x3 x4 x5)) (= x3 (max5 x1 x2 x3 x4 x5)) (= x4 (max5 x1 x2 x3 x4 x5)) (= x5 (max5 x1 x2 x3 x4 x5))))

(check-synth)
