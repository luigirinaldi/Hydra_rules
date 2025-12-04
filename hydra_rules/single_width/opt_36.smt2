(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (bvadd symconst_1 (bvadd symconst_1 v0))
    (bvadd v0 (bvadd symconst_1 symconst_1))
))
(check-sat)
