(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< q t))
(assert (< q t))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- t q) (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (psign_extend (- t q) symconst_1) (psign_extend (- t q) symconst_2))
))
(check-sat)
