(set-logic ALL)
(declare-const s Int)
(declare-fun newvar1 () Bool)
(declare-fun newvar2 () Bool)

; Preconditions:
(assert (< 1 s))
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (bvor (pzero_extend (- s 1) (ite newvar2 (_ bv1 1) (_ bv0 1))) (pzero_extend (- s 1) (ite (not newvar1) (_ bv1 1) (_ bv0 1)))))
    (bvule newvar1 newvar2)
))
(check-sat)
