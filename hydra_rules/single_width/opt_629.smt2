(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec s))

(assert (distinct 
    (bvand symconst_2 (bvand symconst_1 v0))
    (int_to_pbv q 0)
))
(check-sat)
