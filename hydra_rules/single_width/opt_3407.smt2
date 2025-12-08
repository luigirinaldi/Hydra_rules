(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec 1))
(declare-fun newvar4 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (bvult symconst_2 symconst_1))

; assert lhs != rhs:
(assert (distinct 
    (distinct (ite (= newvar1 (_ bv1 1)) symconst_1 symconst_2) (ite (= newvar4 (_ bv1 1)) symconst_1 symconst_2))
    (bvxor newvar1 newvar4)
))
(check-sat)
