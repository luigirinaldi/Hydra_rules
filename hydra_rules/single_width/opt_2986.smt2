(set-logic ALL)
(declare-const r Int)
(declare-fun v1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))

(assert (distinct 
    (= (int_to_pbv r 0) (bvadd v1 symconst_2))
    (= v1 (bvsub (int_to_pbv r 0) symconst_2))
))
(check-sat)
