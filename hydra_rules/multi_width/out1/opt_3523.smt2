(set-logic ALL)
(declare-const s Int)
(declare-const v Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (< v s))
(assert (< v s))
(assert (> s v))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv s 1) (pzero_extend (- s v) r)) (int_to_pbv s 1))))

; assert lhs != rhs:
(assert (distinct 
    (bvult (pzero_extend (- s v) v0) symconst_1)
    (bvult v0 (pextract (- v 1) 0 symconst_1))
))
(check-sat)
