(set-logic ALL)
(declare-const p Int)
(declare-const r Int)
(declare-const s Int)
(declare-fun newvar3 () (_ BitVec p))

; Preconditions:
(assert (< p s))

; assert lhs != rhs:
(assert (distinct 
    (ite newvar3 (int_to_pbv s 1) (int_to_pbv r 0))
    (pzero_extend (- s p) newvar3)
))
(check-sat)
