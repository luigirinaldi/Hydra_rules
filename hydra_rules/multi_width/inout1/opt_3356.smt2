(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () Bool)
(declare-fun newvar1 () Bool)

; Preconditions:
(assert (< 1 q))
(assert (< 1 q))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- q 1) (ite newvar0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- q 1) (ite newvar1 (_ bv1 1) (_ bv0 1))))
    (xor newvar0 newvar1)
))
(check-sat)
