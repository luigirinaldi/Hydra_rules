(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar6 () (_ BitVec r))

(assert (distinct 
    (pzero_extend (- r u) (pextract (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar6)) (int_to_pbv s 1) (int_to_pbv t 0)) (- u 1) 0))
    (bvand (int_to_pbv r 1) newvar6)
))
(check-sat)
