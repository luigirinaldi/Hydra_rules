(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v1 () (_ BitVec s))

(assert (distinct 
    (bvadd symconst_2 (bvadd symconst_1 v1))
    v1
))
(check-sat)
