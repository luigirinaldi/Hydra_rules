(set-logic ALL)
(declare-const t Int)
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (> t 1))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (_ bv1 1) (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) (bvsub v0 (int_to_pbv t 1)))))
    (pextract (- 1 1) 0 v0)
))
(check-sat)
