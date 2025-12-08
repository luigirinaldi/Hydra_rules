(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-const v Int)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< t v))
(assert (< 1 r))
(assert (< 1 v))
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- v 1) (ite (not (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite v0 (_ bv1 1) (_ bv0 1))))) (_ bv1 1) (_ bv0 1)))
    (bvsub (pzero_extend (- v t) (int_to_pbv t 1)) (pzero_extend (- v 1) (ite v0 (_ bv1 1) (_ bv0 1))))
))
(check-sat)
