(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v3 () (_ BitVec r))
(declare-fun v6 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (bvsle (pzero_extend (- s r) v3) (pzero_extend (- s r) v6))
    (bvule v3 v6)
))
(check-sat)
