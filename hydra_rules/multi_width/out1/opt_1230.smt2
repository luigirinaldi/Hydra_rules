(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-const x Int)
(declare-fun newvar1 () (_ BitVec x))
(declare-fun symconst_1 () (_ BitVec t))

; Preconditions:
(assert (< s t))
(assert (< x t))
(assert (> t x))
(assert (bvule symconst_1 (bvsub (bvshl (int_to_pbv t 1) (pzero_extend (- t x) (int_to_pbv x x))) (int_to_pbv t 1))))

; assert lhs != rhs:
(assert (distinct 
    (not (distinct symconst_1 (pzero_extend (- t x) newvar1)))
    (= newvar1 (pextract (- x 1) 0 symconst_1))
))
(check-sat)
