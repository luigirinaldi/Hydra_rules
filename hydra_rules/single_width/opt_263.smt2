(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec q))

(assert (distinct 
    (bvsub (bvadd v0 symconst_1) symconst_1)
    v0
))
(check-sat)
