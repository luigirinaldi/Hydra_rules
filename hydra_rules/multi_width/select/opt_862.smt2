(set-logic ALL)
(declare-const q Int)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-const w Int)
(declare-fun newvar0 () (_ BitVec q))
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun symconst_3 () (_ BitVec t))

; Preconditions:
(assert (> r t))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (bvand symconst_3 (pextract (- t 1) 0 (ite newvar0 symconst_1 symconst_2)))
    (ite newvar0 (bvand symconst_3 (pextract (- t 1) 0 (ite (int_to_pbv u 1) symconst_1 symconst_2))) (bvand symconst_3 (pextract (- t 1) 0 (ite (int_to_pbv w 0) symconst_1 symconst_2))))
))
(check-sat)
