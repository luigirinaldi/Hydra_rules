(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar1 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> p s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pzero_extend (- q p) newvar1))
    (pextract (- s 1) 0 newvar1)
))
(check-sat)
