(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv r 0) (pzero_extend (- r q) newvar0))
    (psign_extend (- r q) newvar0)
))
(check-sat)
