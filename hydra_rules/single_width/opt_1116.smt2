(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun v0 () (_ BitVec q))

(assert (distinct 
    (bvor symconst_1 (bvor symconst_2 v0))
    (bvor v0 (bvor symconst_1 symconst_2))
))
(check-sat)
