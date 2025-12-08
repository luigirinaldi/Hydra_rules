(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar3 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar3 (int_to_pbv r 1) (int_to_pbv q 0))
    (pzero_extend (- r 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
