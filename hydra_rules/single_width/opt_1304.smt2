(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_3 () (_ BitVec q))
(declare-fun v0 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec s))

(assert (distinct 
    (bvshl (bvand symconst_1 (bvand symconst_3 (bvlshr v0 symconst_2))) symconst_2)
    (bvand v0 (bvshl (bvand symconst_1 symconst_3) symconst_2))
))
(check-sat)
