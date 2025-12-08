(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (< p s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (psign_extend (- q p) v0))
    (psign_extend (- s p) v0)
))
(check-sat)
