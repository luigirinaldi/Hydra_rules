(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec r))

(assert (distinct 
    (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) newvar0)))
    (pextract newvar0 (- s 1) 0)
))
(check-sat)
