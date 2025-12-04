(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun newvar1 () (_ BitVec r))

(assert (distinct 
    (pextract (bvor (pzero_extend (- s r) v0) (pzero_extend (- s r) newvar1)) (- r 1) 0)
    (bvor v0 newvar1)
))
(check-sat)
