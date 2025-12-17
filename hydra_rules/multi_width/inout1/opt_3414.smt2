(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () Bool)

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (bvxor (ite newvar0 (int_to_pbv r 1) (int_to_pbv r 0)) (pzero_extend (- r 1) (ite newvar5 (_ bv1 1) (_ bv0 1)))))
    (xor newvar0 newvar5)
))
(check-sat)
