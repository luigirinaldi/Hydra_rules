(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar24 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (bvor (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- r 1) (ite newvar24 (_ bv1 1) (_ bv0 1)))))
    (or newvar0 newvar24)
))
(check-sat)
