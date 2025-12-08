(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (ite v0 symconst_1 symconst_2))
    (bvxor (int_to_pbv q 1) v0)
))
(check-sat)
