(set-logic ALL)
(declare-const r Int)
(declare-const v Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (< v r))
(assert (< 1 r))
(assert (> r v))
(assert (> r v))
(assert (= symconst_1 (bvxor symconst_2 (psign_extend (- r 1) (ite true (_ bv1 1) (_ bv0 1))))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvor symconst_2 (bvand symconst_1 (pzero_extend (- r v) v0))))
    (bvor v0 (pextract (- v 1) 0 symconst_2))
))
(check-sat)
