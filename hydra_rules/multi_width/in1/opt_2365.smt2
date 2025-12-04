(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar3 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- t r) (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar3)))
    (pzero_extend (- t q) newvar3)
))
(check-sat)
