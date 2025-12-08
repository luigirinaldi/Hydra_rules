(set-logic ALL)
(declare-const s Int)
(declare-const x Int)
(declare-const t Int)
(declare-const w Int)
(declare-const q Int)
(declare-fun newvar2 () (_ BitVec q))
(declare-fun newvar7 () (_ BitVec s))

; Preconditions:
(assert (> w x))
(assert (< s w))
(assert (< q w))
(assert (< t x))
(assert (< s t))
(assert (< q t))

; assert lhs != rhs:
(assert (distinct 
    (pzero_extend (- x t) (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t q) newvar2) (pzero_extend (- t s) newvar7))))
    (pextract (- x 1) 0 (bvor (pzero_extend (- w q) newvar2) (pzero_extend (- w s) newvar7)))
))
(check-sat)
