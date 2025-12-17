(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 2) newvar0)) (int_to_pbv t 2) (int_to_pbv t 0))
    (bvand (int_to_pbv t 2) newvar0)
))
(check-sat)
