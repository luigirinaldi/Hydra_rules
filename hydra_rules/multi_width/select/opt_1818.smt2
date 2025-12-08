(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar0 () (_ BitVec 1))
(declare-fun newvar5 () (_ BitVec s))

; Preconditions:
(assert (< 1 r))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (pzero_extend (- r 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))) newvar5 (int_to_pbv t 0))
    (ite (= newvar0 (_ bv1 1)) newvar5 (int_to_pbv u 0))
))
(check-sat)
