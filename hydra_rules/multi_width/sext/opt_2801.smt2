(set-logic ALL)
(declare-const t Int)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (> r t))
(assert (> r t))
(assert (< t r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvand symconst_1 (psign_extend (- r t) v0)))
    (bvand v0 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
