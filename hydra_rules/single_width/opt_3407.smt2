(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_2 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun newvar1 () (_ BitVec r))
(declare-fun newvar4 () (_ BitVec s))

(assert (distinct 
    (distinct (ite newvar1 symconst_1 symconst_2) (ite newvar4 symconst_1 symconst_2))
    (bvxor newvar1 newvar4)
))
(check-sat)
