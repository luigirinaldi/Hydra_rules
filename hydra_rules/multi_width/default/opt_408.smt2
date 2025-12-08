(set-logic ALL)
(declare-const v Int)
(declare-fun newvar0 () (_ BitVec v))
(declare-fun symconst_3 () (_ BitVec v))

; Preconditions:
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (bvmul symconst_3 (pzero_extend (- v 1) (ite (bvxor true (bvxor true (distinct (int_to_pbv v 0) (bvand (int_to_pbv v 1) newvar0)))) (_ bv1 1) (_ bv0 1))))
    (bvmul symconst_3 (bvand (int_to_pbv v 1) newvar0))
))
(check-sat)
