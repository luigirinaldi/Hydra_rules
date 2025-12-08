(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< 1 u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u 1) (ite (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar0)) (_ bv1 1) (_ bv0 1)))
    (pextract (- u 1) 0 (bvand (int_to_pbv r 1) newvar0))
))
(check-sat)
