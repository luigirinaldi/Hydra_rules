(set-logic ALL)
(declare-const s Int)
(declare-const w Int)
(declare-fun newvar1 () (_ BitVec w))
(declare-fun symconst_1 () (_ BitVec s))

; Preconditions:
(assert (< w s))
(assert (< w s))
(assert (> s w))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv s 1) (pzero_extend (- s w) r)) (int_to_pbv s 1))))

; assert lhs != rhs:
(assert (distinct 
    (bvxor (_ bv1 1) (distinct symconst_1 (pzero_extend (- s w) newvar1)))
    (= newvar1 (pextract (- w 1) 0 symconst_1))
))
(check-sat)
