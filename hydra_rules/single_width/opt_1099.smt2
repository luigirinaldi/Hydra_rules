(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar5 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_3 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_3 (ite newvar5 symconst_1 (int_to_pbv r 0)))
    (ite newvar5 (bvor symconst_3 symconst_1) symconst_3)
))
(check-sat)
