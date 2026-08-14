; Formal spec: sign(x) in {-1,0,1}. Three-way, needs the constant -1.
(set-logic LIA)
(synth-fun sign ((x Int)) Int)
(declare-var x Int)
(constraint (=> (> x 0) (= (sign x) 1)))
(constraint (=> (< x 0) (= (sign x) (- 1))))
(constraint (=> (= x 0) (= (sign x) 0)))
(check-synth)
