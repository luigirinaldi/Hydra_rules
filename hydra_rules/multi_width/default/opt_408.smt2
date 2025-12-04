(set-logic ALL)
(declare-const v Int)
(declare-fun symconst_3 () (_ BitVec p))
(declare-fun newvar0 () (_ BitVec u))

(assert (distinct 
    (bvmul symconst_3 (pzero_extend (- v v) (bvxor (int_to_pbv v 1) (bvxor (int_to_pbv v 1) (distinct (int_to_pbv v 0) (bvand (int_to_pbv v 1) newvar0))))))
    (bvmul symconst_3 (bvand (int_to_pbv v 1) newvar0))
))
(check-sat)
