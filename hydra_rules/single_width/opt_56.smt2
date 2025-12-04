(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))

(assert (distinct 
    (bvadd v0 symconst_1)
    (bvadd (int_to_pbv q 1) symconst_1)
))
(check-sat)
