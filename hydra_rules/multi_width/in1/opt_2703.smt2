(set-logic ALL)
(declare-const t Int)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q t))
(assert (< r t))
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- t r) (bvsub (int_to_pbv r 0) (pzero_extend (- r q) newvar0)))
    (psign_extend (- t q) newvar0)
))
(check-sat)
