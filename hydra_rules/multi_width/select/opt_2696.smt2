(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (< p s))
(assert (< p s))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s p) (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (psign_extend (- s p) symconst_1) (psign_extend (- t q) symconst_2))
))
(check-sat)
