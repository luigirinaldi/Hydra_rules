(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (= (int_to_pbv r 1) (bvand (int_to_pbv r 1) v0))
    (pextract v0 (- r 1) 0)
))
(check-sat)
