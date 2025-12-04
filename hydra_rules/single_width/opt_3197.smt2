(set-logic ALL)
(declare-const q Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun newvar1 () (_ BitVec r))

(assert (distinct 
    (distinct symconst_1 (ite newvar1 symconst_2 symconst_1))
    newvar1
))
(check-sat)
