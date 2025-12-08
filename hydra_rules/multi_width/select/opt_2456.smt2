(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () Bool)

; Preconditions:
(assert (< p s))
(assert (< p s))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s p) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- s p) symconst_1) (pzero_extend (- t q) symconst_2))
))
(check-sat)
