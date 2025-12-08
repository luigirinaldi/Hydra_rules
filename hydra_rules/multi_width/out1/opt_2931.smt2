(set-logic ALL)
(declare-const s Int)
(declare-const u Int)
(declare-fun symconst_1 () (_ BitVec s))
(declare-fun v1 () (_ BitVec u))

; Preconditions:
(assert (< u s))
(assert (< u s))
(assert (> s u))
(assert (bvand (bvult (int_to_pbv s 0) symconst_1) (bvule symconst_1 (pzero_extend (- s u) r))))

; assert lhs != rhs:
(assert (distinct 
    (= symconst_1 (pzero_extend (- s u) v1))
    (= v1 (pextract (- u 1) 0 symconst_1))
))
(check-sat)
