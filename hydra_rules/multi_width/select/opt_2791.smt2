(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const v Int)
(declare-const x Int)
(declare-fun newvar0 () (_ BitVec 1))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec r))

; Preconditions:
(assert (> r v))
(assert (> r v))
(assert (> r x))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvor symconst_3 (ite (= newvar0 (_ bv1 1)) symconst_1 symconst_2)))
    (ite (= newvar0 (_ bv1 1)) (pextract (- v 1) 0 (bvor symconst_3 (ite true symconst_1 symconst_2))) (pextract (- x 1) 0 (bvor symconst_3 (ite false symconst_1 symconst_2))))
))
(check-sat)
