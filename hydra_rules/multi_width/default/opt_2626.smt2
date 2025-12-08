(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p s))
(assert (< q s))
(assert (< p q))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s q) (pzero_extend (- q p) v0))
    (pzero_extend (- s p) v0)
))
(check-sat)
