(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (> r 1))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvurem v0 (int_to_pbv r 2))) (_ bv1 1) (_ bv0 1))
    (pextract (- 1 1) 0 v0)
))
(check-sat)
