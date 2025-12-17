(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec t))

; Preconditions:
(assert (> s t))
(assert (> s t))
(assert (> s t))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_3 (pextract (- t 1) 0 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (bvand symconst_3 (pextract (- t 1) 0 (ite true symconst_1 symconst_2))) (bvand symconst_3 (pextract (- t 1) 0 (ite false symconst_1 symconst_2))))
))
(check-sat)
