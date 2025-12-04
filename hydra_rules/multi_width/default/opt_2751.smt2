(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v4 () (_ BitVec p))
(declare-fun v1 () (_ BitVec r))

(assert (distinct 
    (pextract (bvsub (pzero_extend (- s r) v4) (pzero_extend (- s r) v1)) (- r 1) 0)
    (bvsub v4 v1)
))
(check-sat)
