(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar0 symconst_1 symconst_1)
    symconst_1
))
(check-sat)
