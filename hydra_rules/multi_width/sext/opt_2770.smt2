(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v2 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvxor (psign_extend (- s r) v0) (psign_extend (- s r) v2)))
    (bvxor v0 v2)
))
(check-sat)
