(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (= (int_to_pbv r 0) (pzero_extend (- r 1) (ite v0 (_ bv1 1) (_ bv0 1))))
    (not v0)
))
(check-sat)
