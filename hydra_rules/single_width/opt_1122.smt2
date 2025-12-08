(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (= symconst_2 (bvxor (int_to_pbv q 255) symconst_1)))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_1 (bvand symconst_2 v0))
    (bvor symconst_1 v0)
))
(check-sat)
