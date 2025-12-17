(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar24 () Bool)

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t 1) (ite newvar0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- t 1) (ite newvar24 (_ bv1 1) (_ bv0 1)))))
    (or newvar0 newvar24)
))
(check-sat)
