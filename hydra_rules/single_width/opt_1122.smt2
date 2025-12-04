(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec s))

(assert (distinct 
    (bvor symconst_1 (bvand symconst_2 v0))
    (bvor symconst_1 v0)
))
(check-sat)
