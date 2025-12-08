(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- r 1) (ite (= (int_to_pbv r 0) (bvand (int_to_pbv r 1) v0)) (_ bv1 1) (_ bv0 1)))
    (bvsub (int_to_pbv r 1) (bvand (int_to_pbv r 1) v0))
))
(check-sat)
