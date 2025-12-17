(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () (_ BitVec t))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))) newvar5 (int_to_pbv t 0))
    (ite newvar0 newvar5 (int_to_pbv t 0))
))
(check-sat)
