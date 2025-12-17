(set-logic ALL)
(declare-const s Int)
(declare-fun newvar5 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_3 (ite newvar5 symconst_1 (int_to_pbv s 0)))
    (ite newvar5 (bvor symconst_3 symconst_1) symconst_3)
))
(check-sat)
