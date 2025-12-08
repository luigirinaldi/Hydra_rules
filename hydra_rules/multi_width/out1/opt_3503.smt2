(set-logic ALL)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun v0 () (_ BitVec s))

; Preconditions:
(assert (< s s))
(assert (< s s))
(assert (> s s))
(assert (bvand (bvult (int_to_pbv s 0) symconst_1) (bvule symconst_1 (pzero_extend (- s s) r))))

; assert lhs != rhs:
(assert (distinct 
    (bvult (pzero_extend (- s s) v0) symconst_1)
    (bvult v0 (pextract (- s 1) 0 symconst_1))
))
(check-sat)
