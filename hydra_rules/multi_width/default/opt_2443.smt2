(set-logic ALL)
(declare-const u Int)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (> r u))
(assert (< r u))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- u r) (distinct (int_to_pbv r 0) (bvand (int_to_pbv r 1) newvar0)))
    (pextract (- u 1) 0 (bvand (int_to_pbv r 1) newvar0))
))
(check-sat)
