(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< 1 s))
(assert (< 1 s))
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s 1) (ite (distinct symconst_1 (ite newvar1 symconst_2 symconst_1)) (_ bv1 1) (_ bv0 1)))
    (pzero_extend (- s 1) (ite newvar1 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
