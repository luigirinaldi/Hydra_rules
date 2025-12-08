(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec r))
(declare-fun v2 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (= (psign_extend (- s r) v0) (psign_extend (- s r) v2))
    (= v0 v2)
))
(check-sat)
