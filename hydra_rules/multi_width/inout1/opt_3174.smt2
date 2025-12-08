(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv q 0) (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1))))
    newvar0
))
(check-sat)
