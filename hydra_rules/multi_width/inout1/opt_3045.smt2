(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))
(declare-fun newvar1 () (_ BitVec t))

; Preconditions:
(assert (< t t))
(assert (< t t))

; assert lhs != rhs:
(assert (distinct 
    (= (pzero_extend (- t t) newvar1) (pzero_extend (- t t) (bvxor (int_to_pbv t 1) newvar0)))
    (bvxor newvar1 newvar0)
))
(check-sat)
