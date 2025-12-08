(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (> r r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) v0))
    (pextract (- r 1) 0 v0)
))
(check-sat)
