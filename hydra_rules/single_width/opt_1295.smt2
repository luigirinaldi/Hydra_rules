(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (bvnot (int_to_pbv q 0)) (bvand (bvnot (int_to_pbv q 0)) newvar2))
    (bvsub (bvnot (int_to_pbv q 0)) newvar2)
))
(check-sat)
