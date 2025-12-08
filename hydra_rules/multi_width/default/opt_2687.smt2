(set-logic ALL)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec t))

; Preconditions:
(assert (< t t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t t) (bvxor (int_to_pbv t 1) (bvxor (int_to_pbv t 1) (distinct (int_to_pbv t 0) (bvand (int_to_pbv t 1) newvar0)))))
    (bvand (int_to_pbv t 1) newvar0)
))
(check-sat)
