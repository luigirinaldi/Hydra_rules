(set-logic ALL)
(declare-const s Int)
(declare-const x Int)
(declare-fun newvar0 () Bool)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec s))

; Preconditions:
(assert (> s x))
(assert (> s x))
(assert (> s x))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- x 1) 0 (bvor symconst_3 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (pextract (- x 1) 0 (bvor symconst_3 (ite true symconst_1 symconst_2))) (pextract (- x 1) 0 (bvor symconst_3 (ite false symconst_1 symconst_2))))
))
(check-sat)
