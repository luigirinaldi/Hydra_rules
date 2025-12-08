(set-logic ALL)
(declare-const u Int)
(declare-const r Int)
(declare-fun v0 () (_ BitVec u))
(declare-fun symconst_1 () (_ BitVec r))

; Preconditions:
(assert (> r u))
(assert (> r u))
(assert (< u r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (bvshl (pzero_extend (- r u) v0) symconst_1))
    (bvmul v0 (pextract (- u 1) 0 (bvshl (int_to_pbv r 1) symconst_1)))
))
(check-sat)
