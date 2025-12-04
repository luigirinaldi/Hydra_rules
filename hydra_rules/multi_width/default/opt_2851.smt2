(set-logic ALL)
(declare-const v Int)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (pextract (bvlshr (pzero_extend (- s v) v0) symconst_1) (- v 1) 0)
    (bvlshr v0 (pextract symconst_1 (- v 1) 0))
))
(check-sat)
