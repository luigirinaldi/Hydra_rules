(set-logic ALL)
(declare-const q Int)
(declare-fun v1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub v1 (bvsub v1 v0))
    v0
))
(check-sat)
