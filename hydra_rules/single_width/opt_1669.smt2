(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec s))

(assert (distinct 
    (ite (distinct (int_to_pbv r 0) (bvand v0 (bvshl (int_to_pbv r 1) newvar0))) (int_to_pbv r 1) (int_to_pbv u 0))
    (bvlshr (bvand v0 (bvshl (int_to_pbv r 1) newvar0)) newvar0)
))
(check-sat)
