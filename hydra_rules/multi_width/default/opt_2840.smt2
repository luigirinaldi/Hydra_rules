(set-logic ALL)
(declare-const r Int)
(declare-const t Int)
(declare-fun newvar1 () (_ BitVec t))
(declare-fun symconst_1 () (_ BitVec r))

; Preconditions:
(assert (< t r))
(assert (> r t))
(assert (> r t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvadd symconst_1 (pzero_extend (- r t) newvar1)))
    (bvadd newvar1 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
