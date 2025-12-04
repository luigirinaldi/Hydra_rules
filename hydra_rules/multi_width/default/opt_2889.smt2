(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (pextract (bvshl (pzero_extend (- r u) v0) symconst_1) (- u 1) 0)
    (bvmul v0 (pextract (bvshl (int_to_pbv r 1) symconst_1) (- u 1) 0))
))
(check-sat)
