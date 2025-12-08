(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (bvxor true (bvxor true (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)))) (_ bv1 1) (_ bv0 1)))
    (bvand (int_to_pbv t 1) newvar0)
))
(check-sat)
