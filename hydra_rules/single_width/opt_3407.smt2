(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () Bool)
(declare-fun newvar4 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (bvult symconst_2 symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (distinct (ite newvar1 symconst_1 symconst_2) (ite newvar4 symconst_1 symconst_2))
    (bvxor newvar1 newvar4)
))
(check-sat)
