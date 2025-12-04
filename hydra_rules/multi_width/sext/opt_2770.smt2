(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun v2 () (_ BitVec r))

(assert (distinct 
    (pextract (bvxor (psign_extend (- s r) v0) (psign_extend (- s r) v2)) (- r 1) 0)
    (bvxor v0 v2)
))
(check-sat)
