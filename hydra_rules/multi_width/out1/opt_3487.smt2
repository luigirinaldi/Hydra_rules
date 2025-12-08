(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (> r s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (pzero_extend (- s r) (bvand (int_to_pbv r 1) newvar0)))
    (pextract (- s 1) 0 newvar0)
))
(check-sat)
