(set-logic ALL)
(declare-const p Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec p))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar0 symconst_1 symconst_1)
    symconst_1
))
(check-sat)
