(set-logic ALL)
(declare-const s Int)
(declare-fun v0 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvor (bvand v0 symconst_2) (bvand symconst_1 (bvand v0 symconst_3)))
    (bvand v0 (bvor symconst_2 (bvand symconst_1 symconst_3)))
))
(check-sat)
