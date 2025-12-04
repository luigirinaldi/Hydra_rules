(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (pzero_extend (- r s) (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) v0))))
    (bvand (int_to_pbv r 1) v0)
))
(check-sat)
