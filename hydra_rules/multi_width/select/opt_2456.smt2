(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () Bool)

; Preconditions:
(assert (< q t))
(assert (< q t))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t q) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- t q) symconst_1) (pzero_extend (- t q) symconst_2))
))
(check-sat)
