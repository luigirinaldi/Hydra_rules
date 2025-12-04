(set-logic ALL)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))

(assert (distinct 
    (bvmul (int_to_pbv q 1) newvar2)
    newvar2
))
(check-sat)
