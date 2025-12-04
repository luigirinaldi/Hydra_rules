(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const r Int)
(declare-fun newvar3 () (_ BitVec p))

(assert (distinct 
    (ite newvar3 (int_to_pbv s 1) (int_to_pbv r 0))
    (pzero_extend (- s p) newvar3)
))
(check-sat)
