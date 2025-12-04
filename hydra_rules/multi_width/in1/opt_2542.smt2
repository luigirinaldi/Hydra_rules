(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- t r) (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar0)))
    (pzero_extend (- t q) newvar0)
))
(check-sat)
