(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const w Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun symconst_2 () (_ BitVec s))
(declare-fun v0 () (_ BitVec w))

; Preconditions:
(assert (< r s))
(assert (< w s))
(assert (> s w))
(assert (> s w))
(assert (= symconst_1 (bvxor symconst_2 (psign_extend (- s r) (int_to_pbv r 1)))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- w 1) 0 (bvor symconst_2 (bvand symconst_1 (pzero_extend (- s w) v0))))
    (bvor v0 (pextract (- w 1) 0 symconst_2))
))
(check-sat)
