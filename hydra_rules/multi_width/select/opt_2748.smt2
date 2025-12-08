(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar1 () Bool)
(declare-fun symconst_1 () (_ BitVec p))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (> p s))
(assert (> p s))
(assert (> q t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- s 1) 0 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (pextract (- s 1) 0 symconst_1) (pextract (- t 1) 0 symconst_2))
))
(check-sat)
