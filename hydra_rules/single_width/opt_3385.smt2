(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () Bool)

; Preconditions:
(assert (distinct symconst_1 symconst_2))

; assert lhs != rhs:
(assert (distinct 
    (distinct symconst_1 (ite v0 symconst_1 symconst_2))
    (not v0)
))
(check-sat)
