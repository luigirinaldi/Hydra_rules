(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (< q r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (pzero_extend (- r q) v0))
    (bvxor (int_to_pbv q 1) v0)
))
(check-sat)
