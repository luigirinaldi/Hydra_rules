(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (bvor (int_to_pbv q 0) newvar0)
    newvar0
))
(check-sat)
