(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v1 () (_ BitVec r))
(declare-fun v4 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))
(assert (> s r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (bvsub (pzero_extend (- s r) v4) (pzero_extend (- s r) v1)))
    (bvsub v4 v1)
))
(check-sat)
