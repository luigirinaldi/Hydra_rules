(set-logic ALL)
(declare-const p Int)
(declare-const r Int)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 p))
(assert (< 1 r))
(assert (> p r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- r 1) 0 (pzero_extend (- p 1) (ite newvar1 (_ bv1 1) (_ bv0 1))))
    (pzero_extend (- r 1) (ite newvar1 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
