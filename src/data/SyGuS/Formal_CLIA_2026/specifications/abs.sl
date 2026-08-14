; Formal spec: absolute value. Implication constraints, relational.
(set-logic LIA)
(synth-fun absv ((x Int)) Int)
(declare-var x Int)
(constraint (>= (absv x) 0))
(constraint (=> (>= x 0) (= (absv x) x)))
(constraint (=> (< x 0) (= (absv x) (- x))))
(check-synth)
