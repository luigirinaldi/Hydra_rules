(set-logic ALL)
(declare-const s Int)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v3 () (_ BitVec r))

; Preconditions:
(assert (> s r))
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvadd (pzero_extend (- s r) v0) (pzero_extend (- s r) v3)))
    (bvadd v0 v3)
))
(check-sat)
