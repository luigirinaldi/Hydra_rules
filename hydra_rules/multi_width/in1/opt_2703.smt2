(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (psign_extend (- t r) (bvsub (int_to_pbv r 0) (pzero_extend (- r q) newvar0)))
    (psign_extend (- t q) newvar0)
))
(check-sat)
