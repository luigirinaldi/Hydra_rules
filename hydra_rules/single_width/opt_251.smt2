(set-logic ALL)
(declare-const q Int)
(declare-fun v0 () (_ BitVec q))
(declare-fun v1 () (_ BitVec q))

(assert (distinct 
    (bvsub (int_to_pbv q 0) (bvsub v0 v1))
    (bvsub v1 v0)
))
(check-sat)
