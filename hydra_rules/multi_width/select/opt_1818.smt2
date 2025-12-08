(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () (_ BitVec r))

; Preconditions:
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv q 0) (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))) newvar5 (int_to_pbv s 0))
    (ite newvar0 newvar5 (int_to_pbv t 0))
))
(check-sat)
