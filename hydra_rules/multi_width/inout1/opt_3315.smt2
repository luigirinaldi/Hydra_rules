(set-logic ALL)
(declare-const t Int)
(declare-const u Int)
(declare-const s Int)
(declare-fun v0 () (_ BitVec u))
(declare-fun newvar5 () (_ BitVec u))

; Preconditions:
(assert (< t u))
(assert (> s t))
(assert (< u s))
(assert (< u u))

; assert lhs != rhs:
(assert (distinct 
    (distinct (pzero_extend (- u u) v0) (pzero_extend (- u t) (pextract (- t 1) 0 (pzero_extend (- s u) newvar5))))
    (bvxor v0 newvar5)
))
(check-sat)
