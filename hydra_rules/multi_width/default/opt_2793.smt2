(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun v3 () (_ BitVec r))

(assert (distinct 
    (pextract (bvadd (pzero_extend (- s r) v0) (pzero_extend (- s r) v3)) (- r 1) 0)
    (bvadd v0 v3)
))
(check-sat)
