(set-logic ALL)
(declare-const p Int)
(declare-const q Int)
(declare-const r Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar1 () (_ BitVec p))
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (> q t))
(assert (> q t))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (ite newvar1 symconst_1 symconst_2))
    (ite newvar1 (pextract (- t 1) 0 symconst_1) (pextract (- u 1) 0 symconst_2))
))
(check-sat)
