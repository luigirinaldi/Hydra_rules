(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun symconst_3 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvxor symconst_3 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (bvxor symconst_3 symconst_1) (bvxor symconst_3 symconst_2))
))
(check-sat)
