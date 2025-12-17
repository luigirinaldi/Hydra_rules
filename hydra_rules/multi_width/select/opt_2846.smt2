(set-logic ALL)
(declare-const r Int)
(declare-const v Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun symconst_3 () (_ BitVec r))

; Preconditions:
(assert (> r v))
(assert (> r v))
(assert (> r v))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvxor symconst_3 (ite newvar1 symconst_1 symconst_2)))
    (ite newvar1 (pextract (- v 1) 0 (bvxor symconst_3 symconst_1)) (pextract (- v 1) 0 (bvxor symconst_3 symconst_2)))
))
(check-sat)
