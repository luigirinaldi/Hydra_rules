(set-logic ALL)
(declare-const u Int)
(declare-fun symconst_6 () (_ BitVec u))
(declare-fun symconst_7 () (_ BitVec u))
(declare-fun v0 () (_ BitVec u))

; Preconditions:
(assert (= (int_to_pbv u 1) (bvsub symconst_6 symconst_7)))

; assert lhs != rhs:
(assert (distinct 
    (ite (distinct (int_to_pbv u 0) (bvand (int_to_pbv u 1) v0)) symconst_6 symconst_7)
    (bvadd symconst_7 (bvand (int_to_pbv u 1) v0))
))
(check-sat)
