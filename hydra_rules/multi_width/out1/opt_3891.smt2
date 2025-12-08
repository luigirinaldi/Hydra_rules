(set-logic ALL)
(declare-const s Int)
(declare-fun v3 () (_ BitVec s))
(declare-fun v6 () (_ BitVec s))

; Preconditions:
(assert (< s s))
(assert (< s s))

; assert lhs != rhs:
(assert (distinct 
    (bvsle (pzero_extend (- s s) v3) (pzero_extend (- s s) v6))
    (bvule v3 v6)
))
(check-sat)
