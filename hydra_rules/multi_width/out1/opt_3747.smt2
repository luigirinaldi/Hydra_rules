(set-logic ALL)
(declare-const s Int)
(declare-fun v0 () (_ BitVec s))
(declare-fun v2 () (_ BitVec s))

; Preconditions:
(assert (< s s))
(assert (< s s))

; assert lhs != rhs:
(assert (distinct 
    (bvule (pzero_extend (- s s) v0) (pzero_extend (- s s) v2))
    (bvule v0 v2)
))
(check-sat)
