(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_1 (bvor symconst_1 newvar0))
    symconst_1
))
(check-sat)
