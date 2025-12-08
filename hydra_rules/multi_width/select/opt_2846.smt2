(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))
(declare-fun symconst_3 () (_ BitVec q))

; Preconditions:
(assert (> q t))
(assert (> q t))
(assert (> q u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (bvxor symconst_3 (ite newvar1 symconst_1 symconst_2)))
    (ite newvar1 (pextract (- t 1) 0 (bvxor symconst_3 symconst_1)) (pextract (- u 1) 0 (bvxor symconst_3 symconst_2)))
))
(check-sat)
