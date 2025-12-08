(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

; Preconditions:
(assert (= symconst_1 (bvmul (bvnot (int_to_pbv q 0)) symconst_2)))

; assert lhs != rhs:
(assert (distinct 
    (bvadd symconst_2 (bvadd symconst_1 v1))
    v1
))
(check-sat)
