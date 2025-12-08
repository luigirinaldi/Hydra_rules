(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; Preconditions:
(assert (= symconst_2 (bvmul (int_to_pbv q 2) symconst_1)))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_2 (bvadd symconst_1 v1))
    (= symconst_1 v1)
))
(check-sat)
