(set-logic ALL)
(declare-const s Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pzero_extend (- s q) (bvadd (int_to_pbv q 0) v0))
    (pzero_extend (- s q) v0)
))
(check-sat)
