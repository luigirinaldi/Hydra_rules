(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec 1))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_2 (ite v0 (int_to_pbv r 0) symconst_2))
    (ite v0 (int_to_pbv r 0) symconst_2)
))
(check-sat)
