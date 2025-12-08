(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (> q s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (bvadd (int_to_pbv q 0) v0))
    (pextract (- s 1) 0 v0)
))
(check-sat)
