(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun v2 () (_ BitVec r))

(assert (distinct 
    (pextract (bvand (pzero_extend (- s r) v0) (pzero_extend (- s r) v2)) (- r 1) 0)
    (bvand v0 v2)
))
(check-sat)
