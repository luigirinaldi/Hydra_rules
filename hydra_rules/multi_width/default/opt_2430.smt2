(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- s q) (bvadd (int_to_pbv q 0) v0))
    (pzero_extend (- s q) v0)
))
(check-sat)
