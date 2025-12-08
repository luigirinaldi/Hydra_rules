(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-const v Int)
(declare-fun newvar2 () Bool)
(declare-fun newvar7 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (< 1 r))
(assert (< 1 u))
(assert (< 1 u))
(assert (< 1 v))
(assert (> u v))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- v 1) (ite (distinct (int_to_pbv r 0) (bvor (pzero_extend (- r 1) (ite newvar2 (_ bv1 1) (_ bv0 1))) (pzero_extend (- r 1) (ite newvar7 (_ bv1 1) (_ bv0 1))))) (_ bv1 1) (_ bv0 1)))
    (pextract (- v 1) 0 (bvor (pzero_extend (- u 1) (ite newvar2 (_ bv1 1) (_ bv0 1))) (pzero_extend (- u 1) (ite newvar7 (_ bv1 1) (_ bv0 1)))))
))
(check-sat)
