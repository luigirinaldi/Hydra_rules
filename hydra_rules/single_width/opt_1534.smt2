(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_3 () (_ BitVec t))
(declare-fun symconst_7 () (_ BitVec t))
(declare-fun symconst_8 () (_ BitVec q))
(declare-fun symconst_9 () (_ BitVec q))

; Preconditions:
(assert (bvult symconst_9 symconst_8))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct symconst_9 (ite newvar1 symconst_8 symconst_9)) symconst_3 symconst_7)
    (ite newvar1 symconst_3 symconst_7)
))
(check-sat)
