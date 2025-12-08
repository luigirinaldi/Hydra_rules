(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar52 () (_ BitVec s))
(declare-fun v0 () (_ BitVec s))

; Preconditions:
(assert (< s t))
(assert (< s t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvxor (pzero_extend (- t s) v0) (pzero_extend (- t s) newvar52)))
    (bvxor v0 newvar52)
))
(check-sat)
