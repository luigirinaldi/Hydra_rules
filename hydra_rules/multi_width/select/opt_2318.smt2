(set-logic ALL)
(declare-const x Int)
(declare-const u Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun v0 () (_ BitVec s))

(assert (distinct 
    (pzero_extend (- x t) (distinct (int_to_pbv t 0) (ite (distinct (int_to_pbv s 0) (bvand (int_to_pbv s 1) v0)) (int_to_pbv t 1) (int_to_pbv u 0))))
    (pextract (bvand (int_to_pbv s 1) v0) (- x 1) 0)
))
(check-sat)
