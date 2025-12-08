(set-logic ALL)
(declare-const r Int)
(declare-const s Int)
(declare-const t Int)
(declare-const u Int)
(declare-fun newvar5 () (_ BitVec r))
(declare-fun v0 () (_ BitVec r))

; Preconditions:
(assert (< r s))
(assert (< r u))
(assert (< t u))
(assert (> s t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- u r) v0) (pzero_extend (- u t) (pextract (- t 1) 0 (pzero_extend (- s r) newvar5))))
    (bvxor v0 newvar5)
))
(check-sat)
