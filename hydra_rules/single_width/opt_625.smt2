(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))

(assert (distinct 
    (bvand (int_to_pbv q 65535) newvar0)
    newvar0
))
(check-sat)
