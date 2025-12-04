(set-logic ALL)
(declare-const r Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))

(assert (distinct 
    (bvsub (bvadd v0 symconst_1) symconst_2)
    (bvadd v0 (bvsub symconst_1 symconst_2))
))
(check-sat)
