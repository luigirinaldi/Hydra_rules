(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun v0 () (_ BitVec s))

; Preconditions:
(assert (> s s))
(assert (< s s))
(assert (< s s))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv s 1) (pzero_extend (- s s) r)) (int_to_pbv s 1))))

; assert lhs != rhs:
(assert (distinct 
    (bvslt (pzero_extend (- s s) v0) symconst_1)
    (bvult v0 (pextract (- s 1) 0 symconst_1))
))
(check-sat)
