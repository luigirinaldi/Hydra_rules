(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))

(assert (distinct 
    (bvurem newvar0 symconst_1)
    (bvand newvar0 (bvsub symconst_1 (int_to_pbv r 1)))
))
(check-sat)
