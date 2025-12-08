(set-logic ALL)
(declare-const t Int)
(declare-const q Int)
(declare-const r Int)
(declare-fun v2 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; Preconditions:
(assert (< q t))
(assert (< r t))
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t r) (pzero_extend (- r q) (bvand v2 symconst_1)))
    (psign_extend (- t q) (bvand v2 symconst_1))
))
(check-sat)
