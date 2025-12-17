(set-logic ALL)
(declare-const p Int)
(declare-fun newvar1 () Bool)
(declare-fun newvar4 () Bool)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec p))

; Preconditions:
(assert (bvult symconst_2 symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (distinct (ite newvar1 symconst_1 symconst_2) (ite newvar4 symconst_1 symconst_2))
    (xor newvar1 newvar4)
))
(check-sat)
