(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))
(declare-fun v1 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand v1 symconst_3) (ite (distinct (int_to_pbv s 0) (bvand v1 symconst_2)) symconst_2 (int_to_pbv t 0)))
    (bvand v1 (bvor symconst_3 symconst_2))
))
(check-sat)
