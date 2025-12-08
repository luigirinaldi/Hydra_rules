(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (bvmul (bvnot (int_to_pbv q 0)) (bvsub newvar0 symconst_1))
    (bvsub symconst_1 newvar0)
))
(check-sat)
