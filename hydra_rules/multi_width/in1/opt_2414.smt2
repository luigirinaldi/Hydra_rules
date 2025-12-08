(set-logic ALL)
(declare-const q Int)
(declare-const s Int)
(declare-const t Int)
(declare-const w Int)
(declare-const x Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar7 () (_ BitVec s))

; Preconditions:
(assert (< q t))
(assert (< q w))
(assert (< s t))
(assert (< s w))
(assert (< t x))
(assert (> w x))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- x t) (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t q) newvar2) (pzero_extend (- t s) newvar7))))
    (pextract (- x 1) 0 (bvor (pzero_extend (- w q) newvar2) (pzero_extend (- w s) newvar7)))
))
(check-sat)
