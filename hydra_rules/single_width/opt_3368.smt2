(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec p))

(assert (distinct 
    (distinct newvar0 newvar0)
    (distinct (int_to_pbv r 0) (int_to_pbv r 0))
))
(check-sat)
