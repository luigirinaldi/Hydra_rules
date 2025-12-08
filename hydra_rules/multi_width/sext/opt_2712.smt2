(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q s))
(assert (< q s))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (bvadd (int_to_pbv q 0) newvar0))
    (psign_extend (- s q) newvar0)
))
(check-sat)
