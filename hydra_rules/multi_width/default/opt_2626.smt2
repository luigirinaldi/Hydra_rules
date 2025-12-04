(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

(assert (distinct 
    (pzero_extend (- s q) (pzero_extend (- q p) v0))
    (pzero_extend (- s p) v0)
))
(check-sat)
