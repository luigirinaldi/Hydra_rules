(set-logic ALL)
(declare-const r Int)
(declare-fun newvar1 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; assert lhs != rhs:
(assert (distinct 
    (bvor symconst_3 (ite (= newvar1 (_ bv1 1)) symconst_1 symconst_2))
    (ite (= newvar1 (_ bv1 1)) (bvor symconst_3 symconst_1) (bvor symconst_3 symconst_2))
))
(check-sat)
