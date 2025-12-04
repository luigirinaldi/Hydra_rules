(set-logic ALL)
(declare-const p Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

(assert (distinct 
    (psign_extend (- s q) (psign_extend (- q p) v0))
    (psign_extend (- s p) v0)
))
(check-sat)
