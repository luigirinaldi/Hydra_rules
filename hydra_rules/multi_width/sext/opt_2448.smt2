(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v2 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (< q t))
(assert (< r t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t r) (pzero_extend (- r q) (bvand v2 symconst_1)))
    (psign_extend (- t q) (bvand v2 symconst_1))
))
(check-sat)
