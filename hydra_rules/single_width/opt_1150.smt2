(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-fun symconst_3 () (_ BitVec r))
(declare-fun newvar1 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

(assert (distinct 
    (bvor symconst_3 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (bvor symconst_3 symconst_1) (bvor symconst_3 symconst_2))
))
(check-sat)
