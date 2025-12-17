(set-logic ALL)
(declare-const t Int)
(declare-const v Int)
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (ite (not (distinct (int_to_pbv v 0) (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) v0)) (int_to_pbv v 1) (int_to_pbv v 0)))) (_ bv1 1) (_ bv0 1)))
    (bvsub (int_to_pbv t 1) (bvand (int_to_pbv t 1) v0))
))
(check-sat)
