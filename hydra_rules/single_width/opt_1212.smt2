(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun newvar0 () (_ BitVec s))

(assert (distinct 
    (bvxor (int_to_pbv q 1) (distinct symconst_1 (ite (distinct symconst_1 newvar0) symconst_2 symconst_1)))
    (= symconst_1 newvar0)
))
(check-sat)
