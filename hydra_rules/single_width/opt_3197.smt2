(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (ite (= newvar1 (_ bv1 1)) symconst_2 symconst_1))
    newvar1
))
(check-sat)
