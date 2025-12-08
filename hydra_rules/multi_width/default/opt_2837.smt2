(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvmul symconst_1 (pzero_extend (- r t) v0)))
    (bvmul v0 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
