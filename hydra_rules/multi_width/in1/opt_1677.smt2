(set-logic ALL)
(declare-const q Int)
(declare-fun newvar3 () Bool)

; Preconditions:
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar3 (int_to_pbv q 1) (int_to_pbv q 0))
    (pzero_extend (- q 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
