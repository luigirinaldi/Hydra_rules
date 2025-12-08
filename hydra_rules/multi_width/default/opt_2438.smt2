(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< r t))
(assert (< r t))
(assert (> t r))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- t r) (bvand symconst_1 (pextract (- r 1) 0 v0)))
    (bvand v0 (pzero_extend (- t r) symconst_1))
))
(check-sat)
