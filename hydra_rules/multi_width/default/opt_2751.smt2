(set-logic ALL)
(declare-const s Int)
(declare-const r Int)
(declare-fun v4 () (_ BitVec r))
(declare-fun v1 () (_ BitVec r))

; Preconditions:
(assert (> s r))
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvsub (pzero_extend (- s r) v4) (pzero_extend (- s r) v1)))
    (bvsub v4 v1)
))
(check-sat)
