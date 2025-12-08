(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-fun newvar0 () (_ BitVec p))

; Preconditions:
(assert (> p q))
(assert (> p s))
(assert (> q s))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (pextract (- q 1) 0 newvar0))
    (pextract (- s 1) 0 newvar0)
))
(check-sat)
