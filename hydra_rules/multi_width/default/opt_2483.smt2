(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (pzero_extend (- r r) (= (int_to_pbv r 0) (bvand (int_to_pbv r 1) v0)))
    (bvsub (int_to_pbv r 1) (bvand (int_to_pbv r 1) v0))
))
(check-sat)
