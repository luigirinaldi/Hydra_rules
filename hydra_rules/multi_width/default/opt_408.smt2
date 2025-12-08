(set-logic ALL)
(declare-const v Int)
(declare-fun newvar0 () (_ BitVec v))
(declare-fun symconst_3 () (_ BitVec v))

; Preconditions:
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (bvmul symconst_3 (pzero_extend (- v 1) (bvxor (_ bv1 1) (bvxor (_ bv1 1) (distinct (int_to_pbv v 0) (bvand (int_to_pbv v 1) newvar0))))))
    (bvmul symconst_3 (bvand (int_to_pbv v 1) newvar0))
))
(check-sat)
