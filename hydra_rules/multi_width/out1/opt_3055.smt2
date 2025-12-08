(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (> r 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (= (int_to_pbv r 1) (bvand (int_to_pbv r 1) v0)) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 v0)
))
(check-sat)
