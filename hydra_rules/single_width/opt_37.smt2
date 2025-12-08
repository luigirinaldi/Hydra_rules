(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (int_to_pbv q 0) v0)
    v0
))
(check-sat)
