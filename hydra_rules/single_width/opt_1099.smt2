(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const q Int)
(declare-fun symconst_3 () (_ BitVec r))
(declare-fun newvar5 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))

(assert (distinct 
    (bvor symconst_3 (ite newvar5 symconst_1 (int_to_pbv s 0)))
    (ite newvar5 (bvor symconst_3 symconst_1) symconst_3)
))
(check-sat)
