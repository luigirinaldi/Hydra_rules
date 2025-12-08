(set-logic ALL)
(declare-const t Int)
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (> t t))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (int_to_pbv t 1) (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) (bvsub v0 (int_to_pbv t 1)))))
    (pextract (- t 1) 0 v0)
))
(check-sat)
