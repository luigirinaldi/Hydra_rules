(set-logic ALL)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec t))
(declare-fun symconst_3 () (_ BitVec t))
(declare-fun v1 () (_ BitVec t))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand v1 symconst_3) (ite (distinct (int_to_pbv t 0) (bvand v1 symconst_2)) symconst_2 (int_to_pbv t 0)))
    (bvand v1 (bvor symconst_3 symconst_2))
))
(check-sat)
