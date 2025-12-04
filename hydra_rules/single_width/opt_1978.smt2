(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 536870912) v0)) (int_to_pbv r 536870912) (int_to_pbv t 0))
    (bvand (int_to_pbv r 536870912) v0)
))
(check-sat)
