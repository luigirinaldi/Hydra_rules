(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec r))

(assert (distinct 
    (= symconst_1 (ite newvar0 symconst_1 symconst_2))
    newvar0
))
(check-sat)
