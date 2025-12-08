(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-fun newvar0 () (_ BitVec p))

; Preconditions:
(assert (< p q))
(assert (> q p))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- p 1) 0 (pzero_extend (- q p) newvar0))
    newvar0
))
(check-sat)
