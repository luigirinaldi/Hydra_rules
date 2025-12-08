(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (int_to_pbv r 255) (bvsub v0 symconst_2))
    (bvadd v0 (bvxor (int_to_pbv r 255) symconst_2))
))
(check-sat)
