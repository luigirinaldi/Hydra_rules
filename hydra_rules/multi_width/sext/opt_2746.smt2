(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> q p))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- p 1) 0 (psign_extend (- q p) v0))
    v0
))
(check-sat)
