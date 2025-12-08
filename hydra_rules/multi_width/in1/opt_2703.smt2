(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () Bool)

; Preconditions:
(assert (< q s))
(assert (< 1 q))
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (psign_extend (- s q) (bvsub (int_to_pbv q 0) (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))))
    (psign_extend (- s 1) (ite newvar0 (_ bv1 1) (_ bv0 1)))
))
(check-sat)
