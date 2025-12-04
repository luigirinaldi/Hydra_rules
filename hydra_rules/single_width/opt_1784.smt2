(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec r))

(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 2) newvar0)) (int_to_pbv r 2) (int_to_pbv t 0))
    (bvand (int_to_pbv r 2) newvar0)
))
(check-sat)
