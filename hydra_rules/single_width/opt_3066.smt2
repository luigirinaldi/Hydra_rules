(set-logic ALL)
(declare-const r Int)
(declare-fun newvar1 () (_ BitVec p))

(assert (distinct 
    (= newvar1 newvar1)
    (= (int_to_pbv r 0) (int_to_pbv r 0))
))
(check-sat)
