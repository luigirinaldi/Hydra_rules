(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v5 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (pzero_extend (- s r) v5) (pzero_extend (- s r) v0))
    (bvult v5 v0)
))
(check-sat)
