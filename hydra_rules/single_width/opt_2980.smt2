(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (bvsub newvar0 symconst_2))
    (= newvar0 (bvadd symconst_1 symconst_2))
))
(check-sat)
