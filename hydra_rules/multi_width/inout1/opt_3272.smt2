(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec q))

; Preconditions:
(assert (< q r))
(assert (> r s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (pextract (- s 1) 0 (pzero_extend (- r q) newvar0)))
    newvar0
))
(check-sat)
