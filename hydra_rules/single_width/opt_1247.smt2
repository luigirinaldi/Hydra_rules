(set-logic ALL)
(declare-const q Int)
(declare-fun newvar4 () (_ BitVec q))

(assert (distinct 
    (bvxor (int_to_pbv q 1) (bvxor (int_to_pbv q 1) newvar4))
    newvar4
))
(check-sat)
