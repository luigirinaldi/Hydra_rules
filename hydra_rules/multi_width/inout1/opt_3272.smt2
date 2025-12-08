(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< 1 q))
(assert (> q r))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv r 0) (pextract (- r 1) 0 (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))))
    newvar0
))
(check-sat)
