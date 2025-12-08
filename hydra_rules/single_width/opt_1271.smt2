(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvxor true (= (int_to_pbv r 0) v0))
    (bvslt (int_to_pbv r 0) v0)
))
(check-sat)
