(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec s))
(declare-fun newvar1 () (_ BitVec s))

; Preconditions:
(assert (< s t))
(assert (< s t))

; assert lhs != rhs:
(assert (distinct 
    (= (pzero_extend (- t s) newvar1) (pzero_extend (- t s) (bvxor (int_to_pbv s 1) newvar0)))
    (bvxor newvar1 newvar0)
))
(check-sat)
