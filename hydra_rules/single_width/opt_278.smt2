(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub v0 symconst_1)
    (bvsub (int_to_pbv q 1) symconst_1)
))
(check-sat)
