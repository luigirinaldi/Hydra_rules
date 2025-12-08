(set-logic ALL)
(declare-const v Int)
(declare-const s Int)
(declare-const r Int)
(declare-const x Int)
(declare-const u Int)
(declare-const w Int)
(declare-const q Int)
(declare-fun symconst_3 () (_ BitVec r))
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec s))

; Preconditions:
(assert (> r x))
(assert (> r v))
(assert (> r v))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvor symconst_3 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (pextract (- v 1) 0 (bvor symconst_3 (ite (int_to_pbv u 1) symconst_1 symconst_2))) (pextract (- x 1) 0 (bvor symconst_3 (ite (int_to_pbv w 0) symconst_1 symconst_2))))
))
(check-sat)
