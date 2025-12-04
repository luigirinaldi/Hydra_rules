(set-logic ALL)
(declare-const r Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (bvor (bvand symconst_2 v0) (bvand v0 symconst_1))
    (bvand v0 (bvor symconst_2 symconst_1))
))
(check-sat)
