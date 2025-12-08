(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun v0 () (_ BitVec t))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvor symconst_1 (psign_extend (- r t) v0)))
    (bvor v0 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
