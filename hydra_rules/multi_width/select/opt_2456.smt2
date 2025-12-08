(set-logic ALL)
(declare-const p Int)
(declare-const r Int)
(declare-const t Int)
(declare-const u Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (< r u))
(assert (< q t))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t q) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- t q) symconst_1) (pzero_extend (- u r) symconst_2))
))
(check-sat)
