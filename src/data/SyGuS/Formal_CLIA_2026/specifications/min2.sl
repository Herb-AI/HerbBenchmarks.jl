; Formal spec (universally quantified, not I/O examples): minimum of two integers.
(set-logic LIA)
(synth-fun min2 ((x Int) (y Int)) Int)
(declare-var x Int)
(declare-var y Int)
(constraint (<= (min2 x y) x))
(constraint (<= (min2 x y) y))
(constraint (or (= x (min2 x y)) (= y (min2 x y))))
(check-synth)
