(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; Preconditions:
(assert (= (int_to_pbv q 1) (bvsub symconst_2 symconst_1)))

; assert lhs != rhs:
(assert (distinct 
    (bvsub (bvadd symconst_1 v1) symconst_2)
    (bvadd (int_to_pbv q 255) v1)
))
(check-sat)
