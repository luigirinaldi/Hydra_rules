(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec p))
(declare-fun v10 () (_ BitVec q))

(assert (distinct 
    (bvadd newvar0 (bvsub v10 newvar0))
    v10
))
(check-sat)
