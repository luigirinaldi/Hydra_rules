(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvor (pzero_extend (- s r) v0) (pzero_extend (- s r) newvar1)))
    (bvor v0 newvar1)
))
(check-sat)
