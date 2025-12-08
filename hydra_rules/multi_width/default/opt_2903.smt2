(set-logic ALL)
(declare-const v Int)
(declare-const s Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (> s v))
(assert (> s v))
(assert (< v s))
(assert (< v s))
(assert (bvand (bvult (int_to_pbv s 0) symconst_1) (bvult symconst_1 (pzero_extend (- s v) r))))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- v 1) 0 (bvashr (pzero_extend (- s v) v0) symconst_1))
    (bvlshr v0 (pextract (- v 1) 0 symconst_1))
))
(check-sat)
