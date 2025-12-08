(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () Bool)

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_2 (ite v0 (int_to_pbv q 0) symconst_2))
    (ite v0 (int_to_pbv q 0) symconst_2)
))
(check-sat)
