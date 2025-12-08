(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const x Int)
(declare-fun v0 () (_ BitVec s))

; Preconditions:
(assert (< 1 x))
(assert (> s x))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- x 1) (ite (distinct (int_to_pbv t 0) (ite (distinct (int_to_pbv s 0) (bvand (int_to_pbv s 1) v0)) (int_to_pbv t 1) (int_to_pbv u 0))) (_ bv1 1) (_ bv0 1)))
    (pextract (- x 1) 0 (bvand (int_to_pbv s 1) v0))
))
(check-sat)
