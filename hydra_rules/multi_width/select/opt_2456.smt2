(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () Bool)

; Preconditions:
(assert (< r u))
(assert (< r u))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u r) (ite v0 symconst_1 symconst_2))
    (ite v0 (pzero_extend (- u r) symconst_1) (pzero_extend (- u r) symconst_2))
))
(check-sat)
