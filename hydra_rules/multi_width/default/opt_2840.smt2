(set-logic ALL)
(declare-const t Int)
(declare-const r Int)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun newvar1 () (_ BitVec t))

; Preconditions:
(assert (> r t))
(assert (> r t))
(assert (< t r))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvadd symconst_1 (pzero_extend (- r t) newvar1)))
    (bvadd newvar1 (pextract (- t 1) 0 symconst_1))
))
(check-sat)
