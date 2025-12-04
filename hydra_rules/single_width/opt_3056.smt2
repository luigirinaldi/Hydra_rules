(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v1 () (_ BitVec s))

(assert (distinct 
    (= symconst_2 (bvadd symconst_1 v1))
    (= symconst_1 v1)
))
(check-sat)
