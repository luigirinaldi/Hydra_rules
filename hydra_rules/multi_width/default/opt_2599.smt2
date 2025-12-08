(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (ite (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) v0))) (_ bv1 1) (_ bv0 1)))
    (bvand (int_to_pbv r 1) v0)
))
(check-sat)
