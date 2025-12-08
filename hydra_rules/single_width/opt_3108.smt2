(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))
(declare-fun v2 () (_ BitVec q))

; assert lhs != rhs:
(assert (distinct 
    (= (bvadd v0 symconst_1) (bvadd symconst_1 v2))
    (= v0 v2)
))
(check-sat)
