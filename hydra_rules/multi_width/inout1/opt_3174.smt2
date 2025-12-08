(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))

; Preconditions:
(assert (< r r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (pzero_extend (- r r) newvar0))
    newvar0
))
(check-sat)
