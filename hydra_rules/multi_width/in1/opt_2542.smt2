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
    (pzero_extend (- t r) (distinct (int_to_pbv r 0) (pzero_extend (- r q) newvar0)))
    (pzero_extend (- t q) newvar0)
))
(check-sat)
