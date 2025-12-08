(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvadd (int_to_pbv q 1) (bvxor (int_to_pbv q 18446744073709551615) v0))
    (bvmul (int_to_pbv q 18446744073709551615) v0)
))
(check-sat)
