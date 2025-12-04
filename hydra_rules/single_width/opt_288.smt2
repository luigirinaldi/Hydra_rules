(set-logic ALL)
(declare-const q Int)
(declare-fun newvar1 () (_ BitVec p))

(assert (distinct 
    (bvsub newvar1 (int_to_pbv q 0))
    newvar1
))
(check-sat)
