(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (= (pzero_extend (- r 1) (ite newvar1 (_ bv1 1) (_ bv0 1))) (pzero_extend (- r 1) (ite (not newvar0) (_ bv1 1) (_ bv0 1))))
    (xor newvar1 newvar0)
))
(check-sat)
