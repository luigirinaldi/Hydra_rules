(set-logic ALL)
(declare-const q Int)
(declare-fun newvar5 () (_ BitVec p))
(declare-fun newvar2 () (_ BitVec r))

(assert (distinct 
    (bvmul newvar5 (bvshl (int_to_pbv q 1) newvar2))
    (bvshl newvar5 newvar2)
))
(check-sat)
