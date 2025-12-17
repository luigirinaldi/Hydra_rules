(set-logic ALL)
(declare-const r Int)
(declare-const u Int)
(declare-fun newvar2 () Bool)
(declare-fun symconst_1 () (_ BitVec r))
(declare-fun symconst_2 () (_ BitVec r))

; Preconditions:
(assert (> r u))
(assert (> r u))
(assert (> r u))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- u 1) 0 (ite newvar2 symconst_1 symconst_2))
    (ite newvar2 (pextract (- u 1) 0 symconst_1) (pextract (- u 1) 0 symconst_2))
))
(check-sat)
