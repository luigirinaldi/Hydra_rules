(set-logic ALL)
(declare-const q Int)
(declare-const t Int)
(declare-fun newvar2 () Bool)
(declare-fun symconst_1 () (_ BitVec q))
(declare-fun symconst_2 () (_ BitVec q))

; Preconditions:
(assert (> q t))
(assert (> q t))
(assert (> q t))

; assert lhs != rhs:
(assert (distinct 
    (pextract (- t 1) 0 (ite newvar2 symconst_1 symconst_2))
    (ite newvar2 (pextract (- t 1) 0 symconst_1) (pextract (- t 1) 0 symconst_2))
))
(check-sat)
