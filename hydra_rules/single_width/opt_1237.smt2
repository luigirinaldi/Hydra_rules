(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (_ bv1 1) (= symconst_1 (bvand symconst_1 v0)))
    (bvult (bvand symconst_1 v0) symconst_1)
))
(check-sat)
