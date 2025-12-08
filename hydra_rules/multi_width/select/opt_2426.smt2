(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar1 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t 1) (distinct symconst_1 (ite newvar1 symconst_2 symconst_1)))
    (pzero_extend (- t 1) newvar1)
))
(check-sat)
