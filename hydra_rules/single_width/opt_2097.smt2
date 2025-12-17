(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun symconst_3 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)) symconst_3 (int_to_pbv t 0))
    (bvmul symconst_3 (bvand (int_to_pbv t 1) newvar0))
))
(check-sat)
