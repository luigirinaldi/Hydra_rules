(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun newvar1 () (_ BitVec s))
(declare-fun newvar4 () (_ BitVec s))

; Preconditions:
(assert (bvult symconst_2 symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (distinct (ite newvar1 symconst_1 symconst_2) (ite newvar4 symconst_1 symconst_2))
    (bvxor newvar1 newvar4)
))
(check-sat)
