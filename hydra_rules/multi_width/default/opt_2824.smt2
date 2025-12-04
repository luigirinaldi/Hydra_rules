(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

(assert (distinct 
    (pextract (pzero_extend (- q p) v0) (- s 1) 0)
    (pzero_extend (- s p) v0)
))
(check-sat)
