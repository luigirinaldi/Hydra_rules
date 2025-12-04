(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (distinct (int_to_pbv s 0) (pextract (pzero_extend (- r s) newvar0) (- s 1) 0))
    newvar0
))
(check-sat)
