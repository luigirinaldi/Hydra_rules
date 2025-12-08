(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec s))

; Preconditions:
(assert (> q s))
(assert (> q s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_3 (pextract (- s 1) 0 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (bvand symconst_3 (pextract (- s 1) 0 (ite true symconst_1 symconst_2))) (bvand symconst_3 (pextract (- s 1) 0 (ite false symconst_1 symconst_2))))
))
(check-sat)
