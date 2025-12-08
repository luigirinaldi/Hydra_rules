(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))

; Preconditions:
(assert (> q p))
(assert (< p q))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- p 1) 0 (psign_extend (- q p) v0))
    v0
))
(check-sat)
