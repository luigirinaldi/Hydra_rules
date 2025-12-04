(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec r))

(assert (distinct 
    (pzero_extend (- u r) (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar0)))
    (pextract (bvand (int_to_pbv r 1) newvar0) (- u 1) 0)
))
(check-sat)
