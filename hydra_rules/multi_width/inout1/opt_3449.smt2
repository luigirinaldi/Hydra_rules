(set-logic ALL)
(declare-const s Int)
(declare-const t Int)
(declare-fun newvar0 () (_ BitVec s))
(declare-fun newvar24 () (_ BitVec s))

; Preconditions:
(assert (< s t))
(assert (< s t))

; assert lhs != rhs:
(assert (distinct 
    (distinct (int_to_pbv t 0) (bvor (pzero_extend (- t s) newvar0) (pzero_extend (- t s) newvar24)))
    (bvor newvar0 newvar24)
))
(check-sat)
