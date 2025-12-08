(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 q))
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (int_to_pbv q 0) (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1))))
    (psign_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
