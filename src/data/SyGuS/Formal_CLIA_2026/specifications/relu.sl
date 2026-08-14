; Formal spec: relu(x) = max(x, 0). One var, max-with-constant.
(set-logic LIA)
(synth-fun relu ((x Int)) Int)
(declare-var x Int)
(constraint (>= (relu x) x))
(constraint (>= (relu x) 0))
(constraint (or (= (relu x) x) (= (relu x) 0)))
(check-synth)
