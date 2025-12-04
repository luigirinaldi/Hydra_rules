(set-logic ALL)
(declare-const r Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (bvxor (int_to_pbv r 1) (distinct newvar0 symconst_1))
    (= newvar0 symconst_1)
))
(check-sat)
