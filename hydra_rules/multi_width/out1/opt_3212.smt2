(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (> r r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (bvurem v0 (int_to_pbv r 2)))
    (pextract (- r 1) 0 v0)
))
(check-sat)
