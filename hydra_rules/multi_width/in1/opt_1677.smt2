(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar3 () Bool)

; Preconditions:
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar3 (int_to_pbv s 1) (int_to_pbv r 0))
    (pzero_extend (- s 1) (ite newvar3 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
