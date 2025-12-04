(set-logic ALL)
(declare-const r Int)
(declare-const q Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun newvar1 () (_ BitVec r))

(assert (distinct 
    (pzero_extend (- t q) (distinct symconst_1 (ite newvar1 symconst_2 symconst_1)))
    (pzero_extend (- t r) newvar1)
))
(check-sat)
