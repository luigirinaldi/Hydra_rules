(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv q 0) (bvsub v0 symconst_2))
    (bvsub symconst_2 v0)
))
(check-sat)
