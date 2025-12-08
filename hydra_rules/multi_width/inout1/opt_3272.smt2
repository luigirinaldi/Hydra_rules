(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec s))

; Preconditions:
(assert (> r s))
(assert (< s r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (pextract (- s 1) 0 (pzero_extend (- r s) newvar0)))
    newvar0
))
(check-sat)
