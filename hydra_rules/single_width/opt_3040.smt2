(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (ite (= newvar0 (_ bv1 1)) symconst_1 symconst_2))
    newvar0
))
(check-sat)
