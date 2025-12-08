(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (= symconst_2 (bvxor (bvnot (int_to_pbv q 0)) symconst_1)))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_2 (bvand symconst_1 v0))
    (int_to_pbv q 0)
))
(check-sat)
