(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun symconst_3 () (_ BitVec q))
(declare-fun v0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec s))

(assert (distinct 
    (bvadd symconst_2 (bvadd symconst_3 (bvadd v0 symconst_1)))
    (bvadd v0 (bvadd symconst_3 (bvadd symconst_2 symconst_1)))
))
(check-sat)
