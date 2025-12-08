(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const u Int)
(declare-const w Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec q))

; Preconditions:
(assert (> q u))
(assert (> q u))
(assert (> q w))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (bvor symconst_3 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (pextract (- u 1) 0 (bvor symconst_3 (ite true symconst_1 symconst_2))) (pextract (- w 1) 0 (bvor symconst_3 (ite false symconst_1 symconst_2))))
))
(check-sat)
