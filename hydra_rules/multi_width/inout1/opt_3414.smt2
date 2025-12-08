(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar5 () Bool)

; Preconditions:
(assert (< 1 s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv s 0) (bvxor (ite newvar0 (int_to_pbv s 1) (int_to_pbv r 0)) (pzero_extend (- s 1) (ite newvar5 (_ bv1 1) (_ bv0 1)))))
    (xor newvar0 newvar5)
))
(check-sat)
