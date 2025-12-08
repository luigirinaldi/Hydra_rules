(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvand (bvnot (int_to_pbv q 0)) newvar0)
    newvar0
))
(check-sat)
