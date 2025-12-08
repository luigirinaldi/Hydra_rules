(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (bvadd symconst_1 v1))
    (= (int_to_pbv q 0) v1)
))
(check-sat)
