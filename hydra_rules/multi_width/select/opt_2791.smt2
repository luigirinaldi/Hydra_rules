(set-logic ALL)
(declare-const r Int)
(declare-const w Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; Preconditions:
(assert (> r w))
(assert (> r w))
(assert (> r w))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- w 1) 0 (bvor symconst_3 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (pextract (- w 1) 0 (bvor symconst_3 (ite true symconst_1 symconst_2))) (pextract (- w 1) 0 (bvor symconst_3 (ite false symconst_1 symconst_2))))
))
(check-sat)
