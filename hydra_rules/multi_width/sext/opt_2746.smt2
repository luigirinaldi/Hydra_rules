(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

(assert (distinct 
    (pextract (psign_extend (- q p) v0) (- p 1) 0)
    v0
))
(check-sat)
