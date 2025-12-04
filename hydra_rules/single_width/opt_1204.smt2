(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun v4 () (_ BitVec q))

(assert (distinct 
    (bvxor (int_to_pbv q 1) (bvult newvar0 v4))
    (bvule v4 newvar0)
))
(check-sat)
