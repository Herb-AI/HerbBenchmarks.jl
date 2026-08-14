; Formal spec: clamp x into [0,1]. Three-way implication spec.
(set-logic LIA)
(synth-fun clamp ((x Int)) Int)
(declare-var x Int)
(constraint (=> (< x 0) (= (clamp x) 0)))
(constraint (=> (> x 1) (= (clamp x) 1)))
(constraint (=> (and (>= x 0) (<= x 1)) (= (clamp x) x)))
(check-synth)
