(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (pzero_extend (- r r) v0))
    (bvxor (int_to_pbv r 1) v0)
))
(check-sat)
