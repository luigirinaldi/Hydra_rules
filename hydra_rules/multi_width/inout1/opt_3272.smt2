(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 r))
(assert (> r s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (pextract (- s 1) 0 (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))))
    newvar0
))
(check-sat)
