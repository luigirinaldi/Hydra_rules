(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (bvxor (_ bv1 1) (bvxor (_ bv1 1) (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)))))
    (bvand (int_to_pbv t 1) newvar0)
))
(check-sat)
