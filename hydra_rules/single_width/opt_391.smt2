(set-logic ALL)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (bvmul (int_to_pbv q 255) (bvsub newvar0 symconst_1))
    (bvsub symconst_1 newvar0)
))
(check-sat)
