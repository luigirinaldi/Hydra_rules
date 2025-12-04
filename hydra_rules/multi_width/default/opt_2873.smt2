(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (pextract (bvxor symconst_1 (pzero_extend (- r t) v0)) (- t 1) 0)
    (bvxor v0 (pextract symconst_1 (- t 1) 0))
))
(check-sat)
