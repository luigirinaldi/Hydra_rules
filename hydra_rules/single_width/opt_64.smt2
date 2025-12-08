(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (bvnot (int_to_pbv r 0)) (bvsub v0 symconst_2))
    (bvadd v0 (bvxor (bvnot (int_to_pbv r 0)) symconst_2))
))
(check-sat)
