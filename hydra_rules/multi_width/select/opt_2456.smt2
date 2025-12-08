(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< q t))
(assert (< q t))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t q) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- t q) symconst_1) (pzero_extend (- u r) symconst_2))
))
(check-sat)
