(set-logic ALL)
(declare-const t Int)
(declare-fun newvar52 () Bool)
(declare-fun v0 () Bool)

; Preconditions:
(assert (< 1 t))
(assert (< 1 t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvxor (pzero_extend (- t 1) (ite v0 (_ bv1 1) (_ bv0 1))) (pzero_extend (- t 1) (ite newvar52 (_ bv1 1) (_ bv0 1)))))
    (xor v0 newvar52)
))
(check-sat)
