(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (pextract (bvsub (psign_extend (- r u) v0) symconst_1) (- u 1) 0)
    (bvadd v0 (pextract (bvsub (int_to_pbv r 0) symconst_1) (- u 1) 0))
))
(check-sat)
