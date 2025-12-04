(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))

(assert (distinct 
    (bvand v0 symconst_1)
    (bvand (int_to_pbv q 1) symconst_1)
))
(check-sat)
