(set-logic ALL)
(declare-const r Int)
(declare-fun newvar1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

(assert (distinct 
    (bvsub (int_to_pbv r 0) (bvadd newvar1 symconst_2))
    (bvsub (bvsub (int_to_pbv r 0) symconst_2) newvar1)
))
(check-sat)
