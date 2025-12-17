(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const v Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r v))
(assert (< 1 v))
(assert (< 1 v))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- v 1) (ite (not (distinct (int_to_pbv s 0) (pzero_extend (- s r) v0))) (_ bv1 1) (_ bv0 1)))
    (bvsub (pzero_extend (- v 1) (ite true (_ bv1 1) (_ bv0 1))) (pzero_extend (- v r) v0))
))
(check-sat)
