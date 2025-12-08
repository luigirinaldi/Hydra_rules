(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvxor true (distinct newvar0 symconst_1))
    (= newvar0 symconst_1)
))
(check-sat)
