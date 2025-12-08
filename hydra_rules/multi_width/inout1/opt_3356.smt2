(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec r))
(declare-fun newvar1 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r s))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- s r) newvar0) (pzero_extend (- s r) newvar1))
    (bvxor newvar0 newvar1)
))
(check-sat)
