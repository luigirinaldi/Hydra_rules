(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const v Int)
(declare-fun symconst_1 () (_ BitVec t))
(declare-fun v0 () (_ BitVec v))

; Preconditions:
(assert (< s t))
(assert (< v t))
(assert (> t v))
(assert (and (bvult (int_to_pbv t 0) symconst_1) (bvule symconst_1 (pzero_extend (- t v) (int_to_pbv v v)))))

; assert lhs != rhs:
(assert (distinct 
    (bvult (pzero_extend (- t v) v0) symconst_1)
    (bvult v0 (pextract (- v 1) 0 symconst_1))
))
(check-sat)
