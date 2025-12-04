(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun v0 () (_ BitVec r))

(assert (distinct 
    (bvult (pzero_extend (- s s) v0) symconst_1)
    (bvult v0 (pextract symconst_1 (- s 1) 0))
))
(check-sat)
